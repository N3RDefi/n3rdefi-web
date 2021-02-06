// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

import "../libraries/LibAppStorage.sol";
import "../libraries/LibDiamond.sol";
import "../libraries/LibERC20.sol";
import "../interfaces/IERC20.sol";
import "../libraries/LibMeta.sol";

// import "hardhat/console.sol";

contract CollateralFacet is LibAppStorageModifiers {
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    event IncreaseStake(uint256 indexed _tokenId, uint256 _stakeAmount);
    event DecreaseStake(uint256 indexed _tokenId, uint256 _reduceAmount);
    event ExperienceTransfer(uint256 indexed _fromTokenId, uint256 indexed _toTokenId, uint256 experience);

    struct N3rdCollateralTypeIO {
        address collateralType;
        N3rdCollateralTypeInfo collateralTypeInfo;
    }

    /***********************************|
   |             Read Functions         |
   |__________________________________*/

    function collaterals() external view returns (address[] memory collateralTypes_) {
        collateralTypes_ = s.collateralTypes;
    }

    function collateralInfo(uint256 _collateralId) external view returns (N3rdCollateralTypeIO memory collateralInfo_) {
        address collateral = s.collateralTypes[_collateralId];
        collateralInfo_ = N3rdCollateralTypeIO(collateral, s.collateralTypeInfo[collateral]);
        return collateralInfo_;
    }

    function getCollateralInfo() external view returns (N3rdCollateralTypeIO[] memory collateralInfo_) {
        address[] memory collateralTypes = s.collateralTypes;

        collateralInfo_ = new N3rdCollateralTypeIO[](collateralTypes.length);

        for (uint256 i; i < collateralTypes.length; i++) {
            address collateral = collateralTypes[i];
            collateralInfo_[i].collateralType = collateral;
            collateralInfo_[i].collateralTypeInfo = s.collateralTypeInfo[collateral];
        }
    }

    function collateralBalance(uint256 _tokenId)
        external
        view
        returns (
            address collateralType_,
            address escrow_,
            uint256 balance_
        )
    {
        escrow_ = s.n3rd[_tokenId].escrow;
        require(escrow_ != address(0), "CollateralFacet: Does not have an escrow");
        collateralType_ = s.n3rd[_tokenId].collateralType;
        balance_ = IERC20(collateralType_).balanceOf(escrow_);
    }

    /***********************************|
   |             Write Functions        |
   |__________________________________*/

    function increaseStake(uint256 _tokenId, uint256 _stakeAmount) external onlyN3rdOwner(_tokenId) {
        address escrow = s.n3rd[_tokenId].escrow;
        require(escrow != address(0), "CollateralFacet: Does not have an escrow");
        address collateralType = s.n3rd[_tokenId].collateralType;
        emit IncreaseStake(_tokenId, _stakeAmount);
        LibERC20.transferFrom(collateralType, LibMeta.msgSender(), escrow, _stakeAmount);
    }

    function decreaseStake(uint256 _tokenId, uint256 _reduceAmount) external onlyUnlocked(_tokenId) onlyN3rdOwner(_tokenId) {
        address escrow = s.n3rd[_tokenId].escrow;
        require(escrow != address(0), "CollateralFacet: Does not have an escrow");

        address collateralType = s.n3rd[_tokenId].collateralType;
        uint256 currentStake = IERC20(collateralType).balanceOf(escrow);
        uint256 minimumStake = s.n3rd[_tokenId].minimumStake;

        require(currentStake - _reduceAmount >= minimumStake, "CollateralFacet: Cannot reduce below minimum stake");
        emit DecreaseStake(_tokenId, _reduceAmount);
        LibERC20.transferFrom(collateralType, escrow, LibMeta.msgSender(), _reduceAmount);
    }

    function decreaseAndDestroy(uint256 _tokenId, uint256 _toId) external onlyUnlocked(_tokenId) onlyN3rdOwner(_tokenId) {
        address escrow = s.n3rd[_tokenId].escrow;
        require(escrow != address(0), "CollateralFacet: Does not have an escrow");

        // check that all wearables have been removed from inventory before burning
        uint256 itemTypesLength = s.itemTypes.length;
        for (uint256 itemTypeId; itemTypeId < itemTypesLength; itemTypeId++) {
            if (s.itemTypes[itemTypeId].category == LibAppStorage.ITEM_CATEGORY_WEARABLE) {
                require(s.nftBalances[address(this)][_tokenId][itemTypeId] == 0, "CollateralFacet: Can't burn n3rd with wearables");
            }
        }

        //If the toId is different from the tokenId, then perform an essence transfer
        if (_tokenId != _toId) {
            uint32 experience = s.n3rd[_tokenId].experience;
            emit ExperienceTransfer(_tokenId, _toId, experience);
            s.n3rd[_toId].experience += experience;
        }

        s.n3rdBalance[LibMeta.msgSender()]--;
        // delete token approval if any
        if (s.approved[_tokenId] != address(0)) {
            delete s.approved[_tokenId];
            emit Approval(LibMeta.msgSender(), address(0), _tokenId);
        }

        // transfer all collateral to LibMeta.msgSender()
        address collateralType = s.n3rd[_tokenId].collateralType;
        uint256 reduceAmount = IERC20(collateralType).balanceOf(escrow);
        emit DecreaseStake(_tokenId, reduceAmount);
        LibERC20.transferFrom(collateralType, escrow, LibMeta.msgSender(), reduceAmount);

        // delete n3rd info
        delete s.n3rdNamesUsed[s.n3rd[_tokenId].name];
        delete s.n3rd[_tokenId];

        emit Transfer(LibMeta.msgSender(), address(0), _tokenId);
    }
}
