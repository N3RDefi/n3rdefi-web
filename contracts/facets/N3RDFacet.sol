// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

import "../libraries/LibAppStorage.sol";
import "../interfaces/IERC20.sol";
import "../libraries/LibStrings.sol";
import "../libraries/LibSVG.sol";
import "../libraries/LibDiamond.sol";
import "../libraries/LibERC20.sol";
import "./VRFFacet.sol";
// import "hardhat/console.sol";
import "../CollateralEscrow.sol";
import "../libraries/LibVrf.sol";
import "../libraries/LibMeta.sol";

/// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
interface ERC721TokenReceiver {
    /// @notice Handle the receipt of an NFT
    /// @dev The ERC721 smart contract calls this function on the recipient
    ///  after a `transfer`. This function MAY throw to revert and reject the
    ///  transfer. Return of other than the magic value MUST result in the
    ///  transaction being reverted.
    ///  Note: the contract address is always the message sender.
    /// @param _operator The address which called `safeTransferFrom` function
    /// @param _from The address which previously owned the token
    /// @param _tokenId The NFT identifier which is being transferred
    /// @param _data Additional data with no specified format
    /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    ///  unless throwing
    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes calldata _data
    ) external returns (bytes4);
}

contract N3rdFacet is LibAppStorageModifiers {
    bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
    uint256 internal constant EQUIPPED_WEARABLE_SLOTS = 16;
    uint256 internal constant PORTAL_N3RD_NUM = 10;

    /***********************************|
   |             Events                |
   |__________________________________*/

    // event N3rdBatched(uint256 indexed _batchId, uint256[] tokenIds);
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);

    /// @dev This emits when the approved address for an NFT is changed or
    ///  reaffirmed. The zero address indicates there is no approved address.
    ///  When a Transfer event emits, this also indicates that the approved
    ///  address for that NFT (if any) is reset to none.
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    /// @dev This emits when an operator is enabled or disabled for an owner.
    ///  The operator can manage all NFTs of the owner.
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    event OpenPortals(uint256[] _tokenIds);

    event ClaimN3rd(uint256 indexed _tokenId);

    event SetN3rdName(uint256 indexed _tokenId, string _oldName, string _newName);

    event SetBatchId(uint256 indexed _batchId, uint256[] tokenIds);

    event SpendSkillpoints(uint256 indexed _tokenId, int8[4] _values);

    event LockN3rd(uint256 indexed _tokenId, uint256 _lockDuration);

    /***********************************|
   |             Read Functions         |
   |__________________________________*/

    function totalSupply() external view returns (uint256 totalSupply_) {
        totalSupply_ = s.totalSupply;
    }

    function n3rdNameAvailable(string memory _name) external view returns (bool available_) {
        available_ = s.n3rdNamesUsed[_name];
    }

    function currentHaunt() public view returns (uint16 hauntId_, Haunt memory haunt_) {
        hauntId_ = s.currentHauntId;
        haunt_ = s.haunts[hauntId_];
    }

    struct RevenueSharesIO {
        address burnAddress;
        address daoAddress;
        address rarityFarming;
        address pixelCraft;
    }

    function revenueShares() external view returns (RevenueSharesIO memory) {
        return RevenueSharesIO(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF, s.daoTreasury, s.rarityFarming, s.pixelCraft);
    }

    struct InternalPortalN3rdTraitsIO {
        uint256 randomNumber;
        uint256 numericTraits;
        address collateralType;
        uint256 minimumStake;
    }

    function toNumericTraits(uint256 _randomNumber, uint256 _modifiers) internal pure returns (uint256 numericTraits_) {
        for (uint256 i; i < LibAppStorage.NUMERIC_TRAITS_NUM; i++) {
            uint256 value = uint8(_randomNumber >> (i * 8));
            if (value > 99) {
                value /= 2;
                if (value > 99) {
                    value = uint256(keccak256(abi.encodePacked(_randomNumber, i))) % 100;
                }
            }
            int256 mod = int8(_modifiers >> (i * 8));
            // set slot
            numericTraits_ |= uint256((int256(value) + mod) & 0xffff) << (16 * i);
        }
    }

    function singlePortalN3rdTraits(uint256 _randomNumber, uint256 _option)
        internal
        view
        returns (InternalPortalN3rdTraitsIO memory singlePortalN3rdTraits_)
    {
        uint256 randomNumberN = uint256(keccak256(abi.encodePacked(_randomNumber, _option)));
        singlePortalN3rdTraits_.randomNumber = randomNumberN;
        address collateralType = s.collateralTypes[randomNumberN % s.collateralTypes.length];
        singlePortalN3rdTraits_.numericTraits = toNumericTraits(randomNumberN, s.collateralTypeInfo[collateralType].modifiers);
        singlePortalN3rdTraits_.collateralType = collateralType;

        N3rdCollateralTypeInfo memory collateralInfo = s.collateralTypeInfo[collateralType];
        uint16 conversionRate = collateralInfo.conversionRate;

        //Get rarity multiplier
        uint256 multiplier = rarityMultiplier(singlePortalN3rdTraits_.numericTraits);

        //First we get the base price of our collateral in terms of DAI
        uint256 collateralDAIPrice = ((10**IERC20(collateralType).decimals()) / conversionRate);

        //Then multiply by the rarity multiplier
        singlePortalN3rdTraits_.minimumStake = collateralDAIPrice * multiplier;
    }

    struct PortalN3rdTraitsIO {
        uint256 randomNumber;
        int256[] numericTraits;
        uint256 numericTraitsUint;
        address collateralType;
        uint256 minimumStake;
    }

    function portalN3rdTraits(uint256 _tokenId)
        external
        view
        returns (PortalN3rdTraitsIO[PORTAL_N3RD_NUM] memory portalN3rdTraits_)
    {
        require(s.n3rds[_tokenId].status == LibAppStorage.STATUS_OPEN_PORTAL, "N3rdFacet: Portal not open");

        uint256 randomNumber = s.tokenIdToRandomNumber[_tokenId];

        for (uint256 i; i < portalN3rdTraits_.length; i++) {
            InternalPortalN3rdTraitsIO memory single = singlePortalN3rdTraits(randomNumber, i);
            portalN3rdTraits_[i].randomNumber = single.randomNumber;
            portalN3rdTraits_[i].collateralType = single.collateralType;
            portalN3rdTraits_[i].minimumStake = single.minimumStake;
            portalN3rdTraits_[i].numericTraitsUint = single.numericTraits;
            portalN3rdTraits_[i].numericTraits = new int256[](LibAppStorage.NUMERIC_TRAITS_NUM);
            for (uint256 j; j < LibAppStorage.NUMERIC_TRAITS_NUM; j++) {
                portalN3rdTraits_[i].numericTraits[j] = int16(single.numericTraits >> (j * 16));
            }
        }
    }

    function n3rdyAddress() external view returns (address contract_) {
        contract_ = s.n3rdContract;
    }

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this.
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return balance_ The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) external view returns (uint256 balance_) {
        balance_ = s.n3rdBalance[_owner];
    }

    struct N3rdInfo {
        uint256 tokenId;
        string name;
        address owner;
        uint256 randomNumber;
        uint256 status;
        int256[] numericTraits;
        int256[] modifiedNumericTraits;
        uint256[EQUIPPED_WEARABLE_SLOTS] equippedWearables;
        address collateral;
        address escrow;
        uint256 stakedAmount;
        uint256 minimumStake;
        //New
        uint256 kinship; //The kinship value of this N3rd. Default is 50.
        uint256 lastInteracted;
        uint256 experience; //How much XP this N3rd has accrued. Begins at 0.
        uint256 toNextLevel;
        uint256 usedSkillPoints; //number of skill points used
        uint256 level; //the current n3rd level
        uint256 hauntId;
        uint256 baseRarityScore;
        uint256 modifiedRarityScore;
        bool locked;
        uint256 unlockTime;
    }

    function getNumericTraits(uint256 _tokenId) public view returns (uint256 numericTraits_) {
        //Check if trait boosts from consumables are still valid
        int256 boostDecay = int256((block.timestamp - s.n3rds[_tokenId].lastTemporaryBoost) / 24 hours);
        uint256 temporaryTraitBoosts = s.n3rds[_tokenId].temporaryTraitBoosts;
        uint256 numericTraits = s.n3rds[_tokenId].numericTraits;
        for (uint256 i; i < LibAppStorage.NUMERIC_TRAITS_NUM; i++) {
            int256 number = int16(numericTraits >> (i * 16));
            int256 boost = int8(temporaryTraitBoosts >> (i * 8));

            if (boost > 0) {
                if (boost > boostDecay) {
                    number += boost - boostDecay;
                }
            } else {
                if ((boost * -1) > boostDecay) {
                    number += boost + boostDecay;
                }
            }
            numericTraits_ |= uint256(number & 0xffff) << (i * 16);
        }
    }

    function getN3rd(uint256 _tokenId) public view returns (N3rdInfo memory n3rdInfo_) {
        n3rdInfo_.tokenId = _tokenId;
        n3rdInfo_.owner = s.n3rds[_tokenId].owner;
        n3rdInfo_.randomNumber = s.n3rds[_tokenId].randomNumber;
        n3rdInfo_.status = s.n3rds[_tokenId].status;
        n3rdInfo_.hauntId = s.n3rds[_tokenId].hauntId;
        if (n3rdInfo_.status == LibAppStorage.STATUS_AAVEGOTCHI) {
            n3rdInfo_.name = s.n3rds[_tokenId].name;
            uint256 l_equippedWearables = s.n3rds[_tokenId].equippedWearables;
            for (uint16 i; i < EQUIPPED_WEARABLE_SLOTS; i++) {
                n3rdInfo_.equippedWearables[i] = uint16(l_equippedWearables >> (i * 16));
            }
            n3rdInfo_.collateral = s.n3rds[_tokenId].collateralType;
            n3rdInfo_.escrow = s.n3rds[_tokenId].escrow;
            n3rdInfo_.stakedAmount = IERC20(n3rdInfo_.collateral).balanceOf(n3rdInfo_.escrow);
            n3rdInfo_.minimumStake = s.n3rds[_tokenId].minimumStake;
            n3rdInfo_.kinship = kinship(_tokenId);
            n3rdInfo_.lastInteracted = s.n3rds[_tokenId].lastInteracted;
            n3rdInfo_.experience = s.n3rds[_tokenId].experience;
            n3rdInfo_.toNextLevel = xpUntilNextLevel(s.n3rds[_tokenId].experience);
            n3rdInfo_.level = LibAppStorage.n3rdLevel(s.n3rds[_tokenId].experience);
            n3rdInfo_.usedSkillPoints = s.n3rds[_tokenId].usedSkillPoints;
            uint256 numericTraits = s.n3rds[_tokenId].numericTraits;
            n3rdInfo_.numericTraits = new int256[](LibAppStorage.NUMERIC_TRAITS_NUM);
            for (uint256 i; i < LibAppStorage.NUMERIC_TRAITS_NUM; i++) {
                n3rdInfo_.numericTraits[i] = int16(numericTraits >> (i * 16));
            }
            n3rdInfo_.baseRarityScore = baseRarityScore(numericTraits);
            (n3rdInfo_.modifiedNumericTraits, n3rdInfo_.modifiedRarityScore) = modifiedTraitsAndRarityScore(_tokenId);
            n3rdInfo_.locked = s.n3rds[_tokenId].unlockTime >= block.timestamp;
            if (n3rdInfo_.locked) {
                n3rdInfo_.unlockTime = s.n3rds[_tokenId].unlockTime;
            }
        }
        return n3rdInfo_;
    }

    function availableSkillPoints(uint256 _tokenId) public view returns (uint256) {
        uint256 level = LibAppStorage.n3rdLevel(s.n3rds[_tokenId].experience);
        uint256 skillPoints = (level / 3);
        uint256 usedSkillPoints = s.n3rds[_tokenId].usedSkillPoints;
        require(skillPoints >= usedSkillPoints, "N3rdFacet: Used skill points is greater than skill points");
        return skillPoints - usedSkillPoints;
    }

    function abs(int8 x) private pure returns (uint256) {
        require(x != -128, "N3rdFacet: x can't be -128");
        return uint256(x >= 0 ? x : -x);
    }

    function n3rdLevel(uint32 _experience) public pure returns (uint256 level_) {
        level_ = LibAppStorage.n3rdLevel(_experience);
    }

    function xpUntilNextLevel(uint32 _experience) public pure returns (uint256 requiredXp_) {
        uint256 currentLevel = n3rdLevel(_experience);
        requiredXp_ = (((currentLevel)**2) * 50) - _experience;
    }

    function rarityMultiplier(uint256 _numericTraits) public pure returns (uint256 multiplier) {
        uint256 rarityScore = baseRarityScore(_numericTraits);
        if (rarityScore < 300) return 10;
        else if (rarityScore >= 300 && rarityScore < 450) return 10;
        else if (rarityScore >= 450 && rarityScore <= 525) return 25;
        else if (rarityScore >= 526 && rarityScore <= 580) return 100;
        else if (rarityScore >= 581) return 1000;
    }

    //Calculates the base rarity score, including collateral modifier
    function baseRarityScore(uint256 _numericTraits) public pure returns (uint256 _rarityScore) {
        for (uint256 i; i < LibAppStorage.NUMERIC_TRAITS_NUM; i++) {
            int256 number = int16(_numericTraits >> (i * 16));
            if (number >= 50) {
                _rarityScore += uint256(number);
            } else {
                _rarityScore += uint256(int256(100) - number);
            }
        }
    }

    //Only valid for claimed N3rds
    function modifiedTraitsAndRarityScore(uint256 _tokenId) public view returns (int256[] memory numericTraits_, uint256 rarityScore_) {
        require(s.n3rds[_tokenId].status == LibAppStorage.STATUS_AAVEGOTCHI, "N3rdFacet: Must be claimed");
        numericTraits_ = new int256[](LibAppStorage.NUMERIC_TRAITS_NUM);
        N3rd storage n3rd = s.n3rds[_tokenId];
        uint256 equippedWearables = n3rd.equippedWearables;
        uint256 numericTraitsUint = getNumericTraits(_tokenId);
        uint256 wearableBonus;
        for (uint256 slot; slot < EQUIPPED_WEARABLE_SLOTS; slot++) {
            uint256 wearableId = uint16(equippedWearables >> (16 * slot));
            if (wearableId == 0) {
                continue;
            }
            ItemType storage itemType = s.itemTypes[wearableId];
            //Add on trait modifiers
            uint256 traitModifiers = itemType.traitModifiers;
            uint256 newNumericTraits;
            for (uint256 j; j < LibAppStorage.NUMERIC_TRAITS_NUM; j++) {
                int256 number = int16(numericTraitsUint >> (j * 16));
                int256 traitModifier = int8(traitModifiers >> (j * 8));
                number += traitModifier;
                // clear bits first then assign
                newNumericTraits |= (uint256(number) & 0xffff) << (j * 16);
            }

            numericTraitsUint = newNumericTraits;
            wearableBonus += itemType.rarityScoreModifier;
        }
        uint256 baseRarity = baseRarityScore(numericTraitsUint);
        rarityScore_ = baseRarity + wearableBonus;
        for (uint256 i; i < LibAppStorage.NUMERIC_TRAITS_NUM; i++) {
            int256 number = int16(numericTraitsUint >> (i * 16));
            numericTraits_[i] = number;
        }
    }

    function kinship(uint256 _tokenId) public view returns (uint256 score_) {
        N3rd storage n3rd = s.n3rds[_tokenId];
        uint256 lastInteracted = n3rd.lastInteracted;
        uint256 interactionCount = n3rd.interactionCount;
        uint256 interval = block.timestamp - lastInteracted;

        uint256 daysSinceInteraction = interval / 24 hours;

        if (interactionCount > daysSinceInteraction) {
            score_ = interactionCount - daysSinceInteraction;
        }
    }

    function allN3rdIdsOfOwner(address _owner) external view returns (uint256[] memory tokenIds_) {
        tokenIds_ = new uint256[](s.n3rdBalance[_owner]);
        uint256 l_totalSupply = s.totalSupply;
        uint256 ownerIndex;
        for (uint256 tokenId; tokenId < l_totalSupply; tokenId++) {
            if (_owner == s.n3rds[tokenId].owner) {
                tokenIds_[ownerIndex] = tokenId;
                ownerIndex++;
            }
        }
    }

    function allN3rdsOfOwner(address _owner) external view returns (N3rdInfo[] memory n3rdInfos_) {
        n3rdInfos_ = new N3rdInfo[](s.n3rdBalance[_owner]);
        uint256 l_totalSupply = s.totalSupply;
        uint256 ownerIndex;
        for (uint256 tokenId; tokenId < l_totalSupply; tokenId++) {
            if (_owner == s.n3rds[tokenId].owner) {
                n3rdInfos_[ownerIndex] = getN3rd(tokenId);
                ownerIndex++;
            }
        }
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return owner_ The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address owner_) {
        owner_ = s.n3rds[_tokenId].owner;
    }

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    /// @param _tokenId The NFT to find the approved address for
    /// @return approved_ The approved address for this NFT, or the zero address if there is none
    function getApproved(uint256 _tokenId) external view returns (address approved_) {
        require(_tokenId < s.totalSupply, "ERC721: tokenId is invalid");
        approved_ = s.approved[_tokenId];
    }

    /// @notice Query if an address is an authorized operator for another address
    /// @param _owner The address that owns the NFTs
    /// @param _operator The address that acts on behalf of the owner
    /// @return approved_ True if `_operator` is an approved operator for `_owner`, false otherwise
    function isApprovedForAll(address _owner, address _operator) external view returns (bool approved_) {
        approved_ = s.operators[_owner][_operator];
    }

    /***********************************|
   |             Write Functions        |
   |__________________________________*/

    function openPortals(uint256[] calldata _tokenIds) external {
        for (uint256 i; i < _tokenIds.length; i++) {
            uint256 tokenId = _tokenIds[i];
            require(s.n3rds[tokenId].status == LibAppStorage.STATUS_CLOSED_PORTAL, "N3rdFacet: Portal is not closed");
            require(LibMeta.msgSender() == s.n3rds[tokenId].owner, "N3rdFacet: Only n3rd owner can open a portal");

            VrfFacet(address(this)).drawRandomNumber(tokenId);
            s.n3rds[tokenId].status = LibAppStorage.STATUS_VRF_PENDING;
        }
        emit OpenPortals(_tokenIds);
    }

    function claimN3rd(
        uint256 _tokenId,
        uint256 _option,
        uint256 _stakeAmount
    ) external onlyN3rdOwner(_tokenId) {
        N3rd storage n3rd = s.n3rds[_tokenId];
        require(n3rd.status == LibAppStorage.STATUS_OPEN_PORTAL, "N3rdFacet: Portal not open");
        require(_option < PORTAL_N3RD_NUM, "N3rdFacet: Only 10 n3rd options available");

        uint256 randomNumber = s.tokenIdToRandomNumber[_tokenId];

        InternalPortalN3rdTraitsIO memory option = singlePortalN3rdTraits(randomNumber, _option);
        n3rd.randomNumber = option.randomNumber;
        n3rd.numericTraits = option.numericTraits;
        n3rd.collateralType = option.collateralType;
        n3rd.minimumStake = uint88(option.minimumStake);
        n3rd.lastInteracted = uint40(block.timestamp - 12 hours);
        n3rd.interactionCount = 50;
        n3rd.claimTime = uint40(block.timestamp);

        require(_stakeAmount >= option.minimumStake, "N3rdFacet: _stakeAmount less than minimum stake");

        n3rd.status = LibAppStorage.STATUS_AAVEGOTCHI;
        emit ClaimN3rd(_tokenId);

        address escrow = address(new CollateralEscrow(option.collateralType));
        n3rd.escrow = escrow;
        LibERC20.transferFrom(option.collateralType, LibMeta.msgSender(), escrow, _stakeAmount);
    }

    function setN3rdName(uint256 _tokenId, string memory _name) external onlyUnlocked(_tokenId) onlyN3rdOwner(_tokenId) {
        require(bytes(_name).length > 0, "N3rdFacet: _name can't be empty");
        require(s.n3rds[_tokenId].status == LibAppStorage.STATUS_AAVEGOTCHI, "N3rdFacet: Must choose N3rd before setting name");
        require(bytes(_name).length < 26, "N3rdFacet: _name can't be greater than 25 characters");
        require(s.n3rdNamesUsed[_name] == false, "N3rdFacet: N3rd name used already");
        string memory existingName = s.n3rds[_tokenId].name;
        if (bytes(existingName).length > 0) {
            delete s.n3rdNamesUsed[existingName];
        }
        s.n3rdNamesUsed[_name] = true;
        s.n3rds[_tokenId].name = _name;
        emit SetN3rdName(_tokenId, existingName, _name);
    }

    function interact(uint256[] calldata _tokenIds) external {
        for (uint256 i; i < _tokenIds.length; i++) {
            uint256 tokenId = _tokenIds[i];
            address owner = s.n3rds[tokenId].owner;
            require(owner != address(0), "N3rdFacet: Invalid tokenId, is not owned or doesn't exist");
            require(
                LibMeta.msgSender() == owner || s.operators[owner][LibMeta.msgSender()] || s.approved[tokenId] == LibMeta.msgSender(),
                "N3rdFacet: Not owner of token or approved"
            );
            LibAppStorage.interact(tokenId);
        }
    }

    function spendSkillPoints(uint256 _tokenId, int8[4] calldata _values) external onlyUnlocked(_tokenId) onlyN3rdOwner(_tokenId) {
        uint256 numericTraits = s.n3rds[_tokenId].numericTraits;
        //To test (Dan): Prevent underflow (is this ok?), see require below
        uint256 totalUsed = 0;
        for (uint8 index = 0; index < _values.length; index++) {
            totalUsed += abs(_values[index]);

            uint256 position = index * 16;
            // get trait
            int256 trait = int16(numericTraits >> position);
            trait += _values[index];
            // clear trait value
            numericTraits &= ~(uint256(0xffff) << position);
            // set trait value
            numericTraits |= uint256(trait & 0xffff) << position;
        }
        // handles underflow
        require(availableSkillPoints(_tokenId) >= totalUsed, "N3rdFacet: Not enough skill points");
        s.n3rds[_tokenId].numericTraits = numericTraits;
        //Increment used skill points
        s.n3rds[_tokenId].usedSkillPoints += uint16(totalUsed);
        emit SpendSkillpoints(_tokenId, _values);
    }

    /**@notice Prevnts assets and items from being moved from N3rd during lock period, except by gameManager. */
    function lockN3rd(uint256 _tokenId, uint256 _lockDuration) external onlyUnlocked(_tokenId) {
        require(s.n3rds[_tokenId].status == LibAppStorage.STATUS_AAVEGOTCHI, "N3rdFacet: Must be claimed");
        require(LibMeta.msgSender() == s.n3rds[_tokenId].owner, "N3rdFacet: Only owner can lock n3rd");
        s.n3rds[_tokenId].unlockTime = block.timestamp + _lockDuration;
        emit LockN3rd(_tokenId, _lockDuration);
    }

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `LibMeta.msgSender()` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    /// @param _data Additional data with no specified format, sent in call to `_to`
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata _data
    ) external {
        internalTransferFrom(_from, _to, _tokenId);
        uint256 size;
        assembly {
            size := extcodesize(_to)
        }
        if (size > 0) {
            require(
                ERC721_RECEIVED == ERC721TokenReceiver(_to).onERC721Received(LibMeta.msgSender(), _from, _tokenId, _data),
                "ERC721: Transfer rejected/failed by _to"
            );
        }
    }

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external {
        internalTransferFrom(_from, _to, _tokenId);
        uint256 size;
        assembly {
            size := extcodesize(_to)
        }
        if (size > 0) {
            require(
                ERC721_RECEIVED == ERC721TokenReceiver(_to).onERC721Received(LibMeta.msgSender(), _from, _tokenId, ""),
                "ERC721: Transfer rejected/failed by _to"
            );
        }
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `LibMeta.msgSender()` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external {
        internalTransferFrom(_from, _to, _tokenId);
    }

    // This function is used by transfer functions
    function internalTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(_to != address(0), "ER721: Can't transfer to 0 address");
        address owner = s.n3rds[_tokenId].owner;
        require(owner != address(0), "ERC721: Invalid tokenId or can't be transferred");
        require(
            LibMeta.msgSender() == owner || s.operators[owner][LibMeta.msgSender()] || s.approved[_tokenId] == LibMeta.msgSender(),
            "N3rdFacet: Not owner or approved to transfer"
        );
        require(_from == owner, "ERC721: _from is not owner, transfer failed");
        s.n3rds[_tokenId].owner = _to;
        s.n3rdBalance[_from]--;
        s.n3rdBalance[_to]++;
        if (s.approved[_tokenId] != address(0)) {
            delete s.approved[_tokenId];
            emit Approval(owner, address(0), _tokenId);
        }
        // unlock if locked
        if (s.n3rds[_tokenId].unlockTime >= block.timestamp) {
            s.n3rds[_tokenId].unlockTime = block.timestamp - 1;
        }
        emit Transfer(_from, _to, _tokenId);
    }

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `LibMeta.msgSender()` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
    function approve(address _approved, uint256 _tokenId) external {
        address owner = s.n3rds[_tokenId].owner;
        require(owner == LibMeta.msgSender() || s.operators[owner][LibMeta.msgSender()], "ERC721: Not owner or operator of token.");
        s.approved[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `LibMeta.msgSender()`'s assets
    /// @dev Emits the ApprovalForAll event. The contract MUST allow
    ///  multiple operators per owner.
    /// @param _operator Address to add to the set of authorized operators
    /// @param _approved True if the operator is approved, false to revoke approval
    function setApprovalForAll(address _operator, bool _approved) external {
        s.operators[LibMeta.msgSender()][_operator] = _approved;
        emit ApprovalForAll(LibMeta.msgSender(), _operator, _approved);
    }

    function name() external pure returns (string memory) {
        return "N3rd";
    }

    /// @notice An abbreviated name for NFTs in this contract
    function symbol() external pure returns (string memory) {
        return "GOTCHI";
    }

    /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
    /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
    ///  3986. The URI may point to a JSON file that conforms to the "ERC721
    ///  Metadata JSON Schema".
    function tokenURI(uint256 _tokenId) external pure returns (string memory) {
        string memory uid = LibStrings.uintStr(_tokenId);
        return string(abi.encodePacked("https://n3rd.com/metadata/n3rds/", uid)); //Here is your URL!
    }
}
