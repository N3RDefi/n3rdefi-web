// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;
import "../libraries/LibERC20.sol";
import "../libraries/LibDiamond.sol";
import "../libraries/LibVrf.sol";
import "../libraries/LibMeta.sol";
//import "../interfaces/IERC20.sol";
// import "hardhat/console.sol";

struct N3rd {
    // This 256 bit value is broken up into 16 16-bit slots for storing wearableIds
    // See helper function that converts this value into a uint16[16] memory equipedWearables
    uint256 equippedWearables; //The currently equipped wearables of the N3rd
    string name;
    uint256 randomNumber;
    // [Experience, Rarity Score, Kinship, Eye Color, Eye Shape, Brain Size, Spookiness, Aggressiveness, Energy]
    uint256 temporaryTraitBoosts;
    uint40 lastTemporaryBoost;
    uint256 numericTraits; // Sixteen 16 bit ints.  [Eye Color, Eye Shape, Brain Size, Spookiness, Aggressiveness, Energy]
    address owner;
    // uint32 batchId;
    uint16 hauntId;
    uint8 status; // 0 == portal, 1 = open portal, 2 = N3rd
    uint32 experience; //How much XP this N3rd has accrued. Begins at 0.
    address collateralType;
    uint88 minimumStake; //The minimum amount of collateral that must be staked. Set upon creation.
    uint16 usedSkillPoints; //The number of skill points this n3rd has already used
    uint40 claimTime; //The block timestamp when this N3rd was claimed
    uint40 lastInteracted; //The last time this N3rd was interacted with
    uint16 interactionCount; //How many times the owner of this N3rd has interacted with it. Gets reset when the N3rd is transferred to a new owner.
    address escrow; //The escrow address this N3rd manages.
    uint256 unlockTime;
}

struct ItemType {
    string description;
    string author;
    // treated as int8s array
    // [Experience, Rarity Score, Kinship, Eye Color, Eye Shape, Brain Size, Spookiness, Aggressiveness, Energy]
    uint256 traitModifiers; //[WEARABLE ONLY] How much the wearable modifies each trait. Should not be more than +-5 total
    // this is an array of uint indexes into the collateralTypes array
    uint8[] allowedCollaterals; //[WEARABLE ONLY] The collaterals this wearable can be equipped to. An empty array is "any"
    string name; //The name of the item
    uint96 n3rdyPrice; //How much N3RDy this item costs
    uint32 svgId; //The svgId of the item
    uint32 maxQuantity; //Total number that can be minted of this item.
    uint8 rarityScoreModifier; //Number from 1-50.
    // Each bit is a slot position. 1 is true, 0 is false
    uint16 slotPositions; //[WEARABLE ONLY] The slots that this wearable can be added to.
    bool canPurchaseWithN3rdy;
    uint32 totalQuantity; //The total quantity of this item minted so far
    uint8 minLevel; //The minimum N3rd level required to use this item. Default is 1.
    bool canBeTransferred;
    uint8 category; // 0 is wearable, 1 is badge, 2 is consumable
    int8 kinshipBonus; //[CONSUMABLE ONLY] How much this consumable boosts (or reduces) kinship score
    uint32 experienceBonus; //[CONSUMABLE ONLY]
    // SVG x,y,width,height
    uint32 dimensions;
}

struct WearableSet {
    string name;
    uint8[] allowedCollaterals;
    uint256 wearableIds; // The tokenIdS of each piece of the set
    uint256 traitsBonuses;
}

struct Haunt {
    uint24 hauntMaxSize; //The max size of the Haunt
    uint96 portalPrice;
    bytes3 bodyColor;
    uint24 totalCount;
}

struct SvgLayer {
    address svgLayersContract;
    uint16 offset;
    uint16 size;
}

struct N3rdCollateralTypeInfo {
    // treated as an arary of int8
    uint256 modifiers; //Trait modifiers for each collateral. Can be 2, 1, -1, or -2
    bytes3 primaryColor;
    bytes3 secondaryColor;
    bytes3 cheekColor;
    uint8 svgId;
    uint8 eyeShapeSvgId;
    uint16 conversionRate; //Current conversionRate for the price of this collateral in relation to 1 USD. Can be updated by the DAO
    bool delisted;
}

struct ERC1155Listing {
    bytes32 listingId;
    address seller;
    address erc1155TokenAddress;
    uint256 erc1155TypeId;
    uint256 category;
    uint256 quantity;
    uint256 priceInWei;
    uint256 expires;
    uint256 timeCreated;
    uint256 timeLastPurchased;
}

struct AppStorage {
    mapping(address => N3rdCollateralTypeInfo) collateralTypeInfo;
    mapping(address => uint256) collateralTypeIndexes;
    mapping(bytes32 => SvgLayer[]) svgLayers;
    mapping(address => mapping(uint256 => mapping(uint256 => uint256))) nftBalances;
    mapping(address => uint256) n3rdBalance;
    ItemType[] itemTypes;
    WearableSet[] wearableSets;
    mapping(uint256 => Haunt) haunts;
    mapping(address => mapping(uint256 => uint256)) items;
    mapping(uint256 => uint256) tokenIdToRandomNumber;
    mapping(uint256 => N3rd) n3rds;
    mapping(address => mapping(address => bool)) operators;
    mapping(uint256 => address) approved;
    mapping(string => bool) n3rdNamesUsed;
    mapping(address => uint256) metaNonces;
    bytes32[1000] emptySlots;
    uint32 totalSupply;
    uint16 currentHauntId;
    //Addresses
    address[] collateralTypes;
    address n3rdContract;
    address gameManager;
    address dao;
    address daoTreasury;
    address pixelCraft;
    address rarityFarming;
    string itemsBaseUri;
    bytes32 domainSeperator;
    // Marketplace
    // erc1155 category => erc1155Order
    //ERC1155Order[] erc1155MarketOrders;
    mapping(bytes32 => ERC1155Listing) erc1155MarketListings;
    // category => ("listing" or "sold" => listingIds)
    mapping(uint256 => mapping(string => bytes32[])) erc1155MarketListingIds;
    uint256 ownerCutPerMillion;
    uint256 listingFeeInWei;
    // erc1155Token => (erc1155TypeId => category)
    mapping(address => mapping(uint256 => uint256)) erc1155Categories;
    // userAddress => order[]
    mapping(address => bytes32[]) userListingIds;
}

library LibAppStorage {
    uint256 internal constant NUMERIC_TRAITS_NUM = 6;

    uint8 internal constant STATUS_CLOSED_PORTAL = 0;
    uint8 internal constant STATUS_VRF_PENDING = 1;
    uint8 internal constant STATUS_OPEN_PORTAL = 2;
    uint8 internal constant STATUS_AAVEGOTCHI = 3;

    //Wearables
    uint8 internal constant WEARABLE_SLOT_BODY = 0;
    uint8 internal constant WEARABLE_SLOT_FACE = 1;
    uint8 internal constant WEARABLE_SLOT_EYES = 2;
    uint8 internal constant WEARABLE_SLOT_HEAD = 3;
    uint8 internal constant WEARABLE_SLOT_HAND_LEFT = 4;
    uint8 internal constant WEARABLE_SLOT_HAND_RIGHT = 5;
    uint8 internal constant WEARABLE_SLOT_PET = 6;
    uint8 internal constant WEARABLE_SLOT_BG = 7;

    uint256 internal constant ITEM_CATEGORY_WEARABLE = 0;
    uint256 internal constant ITEM_CATEGORY_BADGE = 1;
    uint256 internal constant ITEM_CATEGORY_CONSUMABLE = 2;

    uint8 internal constant WEARABLE_SLOTS_TOTAL = 11;

    event N3rdInteract(uint256 indexed _tokenId, uint256 kinship);

    modifier onlyN3rdOwner(uint256 _tokenId) {
        require(LibMeta.msgSender() == diamondStorage().n3rds[_tokenId].owner, "N3rdFacet: Only n3rd owner can increase stake");
        _;
    }

    function diamondStorage() internal pure returns (AppStorage storage ds) {
        assembly {
            ds.slot := 0
        }
    }

    // Need to ensure there is no overflow of _n3rdy
    function purchase(uint256 _n3rdy) internal {
        AppStorage storage s = diamondStorage();
        //33% to burn address
        uint256 burnShare = (_n3rdy * 33) / 100;

        //17% to Pixelcraft wallet
        uint256 companyShare = (_n3rdy * 17) / 100;

        //40% to rarity farming rewards
        uint256 rarityFarmShare = (_n3rdy * 2) / 5;

        //10% to DAO
        uint256 daoShare = (_n3rdy - burnShare - companyShare - rarityFarmShare);

        // Using 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF as burn address.
        // N3RDy token contract does not allow transferring to address(0) address: https://etherscan.io/address/0x3F382DbD960E3a9bbCeaE22651E88158d2791550#code
        LibERC20.transferFrom(s.n3rdContract, LibMeta.msgSender(), address(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF), burnShare);
        LibERC20.transferFrom(s.n3rdContract, LibMeta.msgSender(), s.pixelCraft, companyShare);
        LibERC20.transferFrom(s.n3rdContract, LibMeta.msgSender(), s.rarityFarming, rarityFarmShare);
        LibERC20.transferFrom(s.n3rdContract, LibMeta.msgSender(), s.dao, daoShare);
    }

    struct LevelInfo {
        uint8 levelBoost;
        uint16 levelAmount;
        uint32 low;
        uint32 high;
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

    function n3rdLevel(uint32 _experience) internal pure returns (uint256 level_) {
        if (_experience > 490050) {
            return 99;
        }

        level_ = (sqrt(2 * _experience) / 10);
        return level_ + 1;
    }

    function uintToSixteenBitArray(uint256 _data) internal pure returns (uint256[16] memory array_) {
        for (uint256 i; i < 16; i++) {
            uint256 item = uint16(_data >> (16 * i));
            array_[i] = item;
        }
    }

    function interact(uint256 _tokenId) internal {
        AppStorage storage s = diamondStorage();
        uint256 lastInteracted = s.n3rds[_tokenId].lastInteracted;
        // if interacted less than 12 hours ago
        if (block.timestamp < lastInteracted + 12 hours) {
            return;
        }

        uint256 interactionCount = s.n3rds[_tokenId].interactionCount;
        uint256 interval = block.timestamp - lastInteracted;
        uint256 daysSinceInteraction = interval / 86400;
        uint256 kinship;
        if (interactionCount > daysSinceInteraction) {
            kinship = interactionCount - daysSinceInteraction;
        }

        uint256 hateBonus;

        if (kinship < 40) {
            hateBonus = 2;
        }
        kinship += 1 + hateBonus;
        s.n3rds[_tokenId].interactionCount = uint16(kinship);

        s.n3rds[_tokenId].lastInteracted = uint40(block.timestamp);
        emit N3rdInteract(_tokenId, kinship);
    }
}

contract LibAppStorageModifiers {
    AppStorage internal s;
    modifier onlyN3rdOwner(uint256 _tokenId) {
        require(LibMeta.msgSender() == s.n3rds[_tokenId].owner, "LibAppStorage: Only n3rd owner can call this function");
        _;
    }
    modifier onlyUnlocked(uint256 _tokenId) {
        require(s.n3rds[_tokenId].unlockTime < block.timestamp, "LibAppStorage: Only callable on unlocked N3rds");
        _;
    }
    // modifier onlyLocked(uint256 _tokenId) {
    //     require(s.n3rds[_tokenId].unlockTime > block.timestamp, "Only callable on unlocked N3rds");
    //     _;
    // }

    modifier onlyOwner {
        require(LibMeta.msgSender() == LibDiamond.contractOwner(), "Only owner can call this function");
        _;
    }

    modifier onlyDao {
        require(LibMeta.msgSender() == s.dao || LibMeta.msgSender() == address(this), "Only DAO can call this function");
        _;
    }

    modifier onlyDaoOrOwner {
        require(
            LibMeta.msgSender() == s.dao || LibMeta.msgSender() == LibDiamond.contractOwner() || LibMeta.msgSender() == address(this),
            "LibAppStorage: Do not have access"
        );
        _;
    }

    modifier onlyOwnerOrDaoOrGameManager {
        require(
            LibMeta.msgSender() == s.dao ||
                LibMeta.msgSender() == LibDiamond.contractOwner() ||
                LibMeta.msgSender() == address(this) ||
                LibMeta.msgSender() == s.gameManager,
            "LibAppStorage: Do not have access"
        );
        _;
    }
}
