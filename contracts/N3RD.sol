// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

/******************************************************************************\
* Authors: Craig Moss
*
* Implementation of a Diamond 1 by Nick Mudge (mudgen)
/******************************************************************************/

import "./facets/OwnershipFacet.sol";
import "./libraries/LibAppStorage.sol";
import "./facets/DiamondCutFacet.sol";
import "./facets/DiamondLoupeFacet.sol";
import "./interfaces/IERC165.sol";
import "./interfaces/IDiamondCut.sol";
import "./interfaces/IDiamondLoupe.sol";
import "./facets/N3RDFacet.sol";
import "./facets/SvgFacet.sol";
import "./facets/ItemsFacet.sol";
import "./libraries/LibDiamond.sol";
import "./libraries/LibVrf.sol";
import "./libraries/LibMeta.sol";

contract N3RDDiamond {
    using LibAppStorage for AppStorage;
    AppStorage internal s;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    struct ConstructorArgs {
        address contractOwner;
        address dao;
        address daoTreasury;
        address pixelCraft;
        address rarityFarming;
        address n3rdContract;
        bytes32 chainlinkKeyHash;
        uint256 chainlinkFee;
        uint24 initialHauntSize;
    }

    constructor(IDiamondCut.FacetCut[] memory _diamondCut, ConstructorArgs memory _args) {
        LibDiamond.diamondCut(_diamondCut, address(0), new bytes(0));
        LibDiamond.setContractOwner(_args.contractOwner);
        s.dao = _args.dao;
        s.daoTreasury = _args.daoTreasury;
        s.rarityFarming = _args.rarityFarming;
        s.pixelCraft = _args.pixelCraft;
        s.itemsBaseUri = "https://aavegotchi.com/metadata/items/";

        s.domainSeperator = LibMeta.domainSeparator("N3RDDiamond", "V1");

        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();

        // adding ERC165 data
        ds.supportedInterfaces[type(IERC165).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;
        ds.supportedInterfaces[type(IERC173).interfaceId] = true;

        s.n3rdContract = _args.n3rdContract;
        LibVrf.Storage storage vrf_ds = LibVrf.diamondStorage();
        vrf_ds.keyHash = _args.chainlinkKeyHash;
        vrf_ds.fee = uint144(_args.chainlinkFee);

        uint256 currentHauntId = s.currentHauntId;
        s.haunts[currentHauntId].hauntMaxSize = _args.initialHauntSize; //10_000;
        s.haunts[currentHauntId].portalPrice = 100e18;
        s.listingFeeInWei = 1e17;
    }

    // Find facet for function that is called and execute the
    // function if a facet is found and return any value.
    fallback() external payable {
        LibDiamond.DiamondStorage storage ds;
        bytes32 position = LibDiamond.DIAMOND_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
        address facet = ds.selectorToFacetAndPosition[msg.sig].facetAddress;
        require(facet != address(0), "Diamond: Function does not exist");
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
                case 0 {
                    revert(0, returndatasize())
                }
                default {
                    return(0, returndatasize())
                }
        }
    }

    receive() external payable {}
}
