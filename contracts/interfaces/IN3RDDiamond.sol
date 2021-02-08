// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

import "../libraries/LibAppStorage.sol";
import "../facets/N3RDFacet.sol";
import "../facets/CollateralFacet.sol";

interface IN3RDiamond {
    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    // N3rd Facet
    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);

    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    event OpenPortals(uint256[] _tokenIds);

    event ClaimN3rd(uint256 indexed _tokenId);

    event SetN3rdName(uint256 indexed _tokenId, string _oldName, string _newName);

    event SetBatchId(uint256 indexed _batchId, uint256[] tokenIds);

    event SpendSkillpoints(uint256 indexed _tokenId, int8[4] _values);

    event LockN3rd(uint256 indexed _tokenId, uint256 _lockDuration);

    function totalSupply() external view returns (uint256 totalSupply_);

    function n3rdNameAvailable(string memory _name) external view returns (bool available_);

    function currentHaunt() external view returns (uint16 hauntId_, Haunt memory haunt_);

    struct RevenueSharesIO {
        address burnAddress;
        address daoAddress;
        address rarityFarming;
        address pixelCraft;
    }

    function revenueShares() external view returns (RevenueSharesIO memory);

    struct InternalPortalN3rdTraitsIO {
        uint256 randomNumber;
        uint256 numericTraits;
        address collateralType;
        uint256 minimumStake;
    }

    struct PortalN3rdTraitsIO {
        uint256 randomNumber;
        int256[] numericTraits;
        uint256 numericTraitsUint;
        address collateralType;
        uint256 minimumStake;
    }

    /* function portalN3rdTraits(uint256 _tokenId) external view returns (PortalN3rdTraitsIO[10] memory portalN3rdTraits_);
     */

    function n3rdyAddress() external view returns (address contract_);

    function balanceOf(address _owner) external view returns (uint256 balance_);

    struct N3rdInfo {
        uint256 tokenId;
        string name;
        address owner;
        uint256 randomNumber;
        uint256 status;
        int256[] numericTraits;
        uint256[16] equippedWearables;
        address collateral;
        address escrow;
        uint256 stakedAmount;
        uint256 minimumStake;
        //New
        uint256 kinship; //The kinship value of this N3rd. Default is 50.
        uint256 lastInteracted;
        uint256 experience; //How much XP this N3rd has accrued. Begins at 0.
        uint256 usedSkillPoints; //number of skill points used
        uint256 level; //the current n3rd level
        uint256 batchId;
        uint256 hauntId;
    }

    function getNumericTraits(uint256 _tokenId) external view returns (uint256 numericTraits_);

    function getN3rd(uint256 _tokenId) external view returns (N3rdInfo memory n3rdInfo_);

    function availableSkillPoints(uint256 _tokenId) external view returns (uint256);

    function n3rdLevel(uint32 _experience) external pure returns (uint256 level_);

    function rarityMultiplier(uint256 _numericTraits, address _collateralType) external view returns (uint256 multiplier);

    //Calculates the base rarity score, including collateral modifier
    function baseRarityScore(uint256 _numericTraits, address collateralType) external view returns (uint256 _rarityScore);

    struct ModifiedRarityScore {
        uint256 rarityScore_;
        int256[] numericTraits_;
    }

    //Only valid for claimed N3rds
    function modifiedRarityScore(uint256 _tokenId) external view returns (ModifiedRarityScore memory info_);

    function kinship(uint256 _tokenId) external view returns (uint256 score_);

    function ownerOf(uint256 _tokenId) external view returns (address owner_);

    function getApproved(uint256 _tokenId) external view returns (address approved_);

    function isApprovedForAll(address _owner, address _operator) external view returns (bool approved_);

    function setBatchId(uint256[] calldata _tokenIds) external;

    function openPortals(uint256[] calldata _tokenIds) external;

    function claimN3rd(
        uint256 _tokenId,
        uint256 _option,
        uint256 _stakeAmount
    ) external;

    function setN3rdName(uint256 _tokenId, string memory _name) external;

    function interact(uint256 _tokenId) external;

    function spendSkillPoints(uint256 _tokenId, int8[4] calldata _values) external;

    function lockN3rd(uint256 _tokenId, uint256 _lockDuration) external;

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata _data
    ) external;

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external;

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external;

    function approve(address _approved, uint256 _tokenId) external;

    function setApprovalForAll(address _operator, bool _approved) external;

    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    // CollateralFacet
    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////

    event IncreaseStake(uint256 indexed _tokenId, uint256 _stakeAmount);
    event DecreaseStake(uint256 indexed _tokenId, uint256 _reduceAmount);
    event ExperienceTransfer(uint256 indexed _fromTokenId, uint256 indexed _toTokenId, uint256 experience);

    struct N3rdCollateralTypeIO {
        address collateralType;
        N3rdCollateralTypeInfo collateralTypeInfo;
    }

    function collateralInfo(uint256 _collateralId) external view returns (N3rdCollateralTypeIO memory collateralInfo_);

    function collateralBalance(uint256 _tokenId)
        external
        view
        returns (
            address collateralType_,
            address escrow_,
            uint256 balance_
        );

    function increaseStake(uint256 _tokenId, uint256 _stakeAmount) external;

    function decreaseStake(uint256 _tokenId, uint256 _reduceAmount) external;

    function decreaseAndDestroy(uint256 _tokenId, uint256 _toId) external;

    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    // DAOFacet
    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    event DaoTransferred(address indexed previousDao, address indexed newDao);
    event DaoTreasuryTransferred(address indexed previousDaoTreasury, address indexed newDaoTreasury);
    event UpdateCollateralModifiers(uint256 _oldModifiers, uint256 _newModifiers);
    event AddCollateralType(N3rdCollateralTypeIO _collateralType);
    event CreateHaunt(uint256 indexed _hauntId, uint256 _hauntMaxSize, uint256 _portalPrice, bytes32 _bodyColor);
    event GrantExperience(uint256[] _tokenIds, uint32[] _xpValues);
    event AddWearableSet(WearableSet _wearableSet);
    event AddItemType(ItemType _itemType);
    event GameManagerTransferred(address indexed previousGameManager, address indexed newGameManager);

    event ItemTypeMaxQuantity(uint256[] _itemIds, uint32[] _maxQuanities);

    function gameManager() external view returns (address);

    function setDao(address _newDao) external;

    function updateCollateralModifiers(address _collateralType, uint256 _modifiers) external;

    function createHaunt(
        uint24 _hauntMaxSize,
        uint96 _portalPrice,
        bytes3 _bodyColor
    ) external returns (uint256 hauntId_);

    function mintItems(
        address _to,
        uint256[] calldata _itemIds,
        uint256[] calldata _quantities
    ) external;

    function grantExperience(uint256[] calldata _tokenIds, uint32[] calldata _xpValues) external;

    function setGameManager(address _gameManager) external;

    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    // ItemsFacet
    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////

    event TransferToParent(address indexed _toContract, uint256 indexed _toTokenId, uint256 indexed _tokenTypeId, uint256 _value);
    event TransferFromParent(address indexed _fromContract, uint256 indexed _fromTokenId, uint256 indexed _tokenTypeId, uint256 _value);
    event EquipWearables(uint256 indexed _tokenId, uint256 _oldWearables, uint256 _newWearables);

    event UseConsumables(uint256 indexed _tokenId, uint256[] _itemIds, uint256[] _quantities);

    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);

    event URI(string _value, uint256 indexed _id);

    function itemBalances(address _account) external view returns (uint256[] memory bals_);

    function balanceOf(address _owner, uint256 _id) external view returns (uint256 bal_);

    function balanceOfToken(
        address _tokenContract,
        uint256 _tokenId,
        uint256 _id
    ) external view returns (uint256 value);

    // returns the balances for all items for a token
    function itemBalancesOfToken(address _tokenContract, uint256 _tokenId) external view returns (uint256[] memory bals_);

    struct ItemBalanceWithSlotsIO {
        uint256 itemId;
        uint256 balance;
        uint256[] slotPositions;
    }

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory bals);

    function equippedWearables(uint256 _tokenId) external view returns (uint256[16] memory wearableIds_);

    function getWearableSet(uint256 _index) external view returns (WearableSetIO memory wearableSet_);

    function totalWearableSets() external view returns (uint256);

    function getItemType(uint256 _itemId) external view returns (ItemType memory itemType_);

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _value,
        bytes calldata _data
    ) external;

    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) external;

    function transferToParent(
        address _from,
        address _toContract,
        uint256 _toTokenId,
        uint256 _id,
        uint256 _value
    ) external;

    function transferFromParent(
        address _fromContract,
        uint256 _fromTokenId,
        address _to,
        uint256 _id,
        uint256 _value
    ) external;

    function transferAsChild(
        address _fromContract,
        uint256 _fromTokenId,
        address _toContract,
        uint256 _toTokenId,
        uint256 _id,
        uint256 _value
    ) external;

    function equipWearables(uint256 _tokenId, uint256 _equippedWearables) external;

    struct WearableSetIO {
        string name;
        uint256[16] wearableIds;
        int256[5] traitsBonuses;
    }

    function useConsumables(
        uint256 _tokenId,
        uint256[] calldata _itemIds,
        uint256[] calldata _quantities
    ) external;

    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    // ShopFacet
    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////

    event BuyPortals(
        address indexed _from,
        address indexed _to,
        uint256 indexed _batchId,
        uint256 _tokenId,
        uint256 _numN3rdsToPurchase,
        uint256 _totalPrice
    );

    event PurchaseItemsWithN3rdy(address indexed _from, address indexed _to, uint256[] _itemIds, uint256[] _quantities, uint256 _totalPrice);

    event PurchaseItemsWithVouchers(address indexed _from, address indexed _to, uint256[] _itemIds, uint256[] _quantities);

    function buyPortals(
        address _to,
        uint256 _n3rdy,
        bool _setBatchId
    ) external;

    function purchaseItemsWithN3rdy(
        address _to,
        uint256[] calldata _itemIds,
        uint256[] calldata _quantities
    ) external;

    function purchaseItemsWithVouchers(
        address _to,
        uint256[] calldata _voucherIds,
        uint256[] calldata _quantities
    ) external;

    function onERC1155BatchReceived(
        address _operator,
        address _from,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) external view returns (bytes4);

    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    // SvgFacet
    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////

    /* event StoreSvg(LibSvg.SvgTypeAndSizes[] _typesAndSizes);*/
    struct SvgLayerDetails {
        string primaryColor;
        string secondaryColor;
        string cheekColor;
        bytes background;
        bytes collateral;
        int256 trait;
        int256[18] eyeShapeTraitRange;
        bytes eyeShape;
        string eyeColor;
        int256[8] eyeColorTraitRanges;
        string[7] eyeColors;
    }

    // Given an n3rd token id, return the combined SVG of its layers and its wearables
    function getN3rdSvg(uint256 _tokenId) external view returns (string memory ag_);

    function portalN3rdsSvg(uint256 _tokenId) external view returns (string[10] memory svg_);

    /* function storeSvg(string calldata _svg, LibSvg.SvgTypeAndSizes[] calldata _typesAndSizes) external;*/

    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    // VrfFacet
    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////

    event VrfBatchRandomNumber(uint256 indexed batchId, uint256 randomNumber, uint256 _vrfTimeSet);

    function vrfInfo()
        external
        view
        returns (
            uint256 nextBatchId_,
            uint256 nextVrfCallTime_,
            bool vrfPending_,
            uint256 batchCount_
        );

    function linkBalance() external view returns (uint256 linkBalance_);

    function drawRandomNumber() external;

    function rawFulfillRandomness(bytes32 _requestId, uint256 _randomNumber) external;

    function changeVRFFee(uint256 _newFee, bytes32 _keyHash) external;

    function removeLinkTokens(address _to, uint256 _value) external;
}
