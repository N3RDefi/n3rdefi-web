//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

import {AppStorage, SvgLayer} from "../libraries/LibAppStorage.sol";
import "../libraries/LibDiamond.sol";
import "../libraries/LibSVG.sol";
import "../libraries/LibStrings.sol";
import "./N3RDFacet.sol";

// This contract was added as a facet to the diamond
contract SvgFacet is LibAppStorageModifiers {
    uint256 internal constant EQUIPPED_WEARABLE_SLOTS = 16;
    uint256 internal constant PORTAL_N3RD_NUM = 10;

    event StoreSvg(LibSvg.SvgTypeAndSizes[] _typesAndSizes);

    /***********************************|
   |             Read Functions         |
   |__________________________________*/

    function bytes3ToColorString(bytes3 _color) internal pure returns (string memory) {
        bytes memory numbers = "0123456789ABCDEF";
        bytes memory toString = new bytes(6);
        uint256 pos = 0;
        for (uint256 i; i < 3; i++) {
            toString[pos] = numbers[uint8(_color[i] >> 4)];
            pos++;
            toString[pos] = numbers[uint8(_color[i] & 0x0f)];
            pos++;
        }
        return string(toString);
    }

    // Given an N3RD token id, return the combined SVG of its layers and its wearables
    function getN3RDSvg(uint256 _tokenId) public view returns (string memory ag_) {
        require(s.n3rds[_tokenId].owner != address(0), "SvgFacet: _tokenId does not exist");

        bytes memory svg;
        uint8 status = s.n3rds[_tokenId].status;
        if (status == LibAppStorage.STATUS_CLOSED_PORTAL) {
            // sealed closed portal
            svg = LibSvg.getSvg("n3rd", 0);
        } else if (status == LibAppStorage.STATUS_OPEN_PORTAL) {
            // open portal
            svg = LibSvg.getSvg("n3rd", 1);
        } else if (status == LibAppStorage.STATUS_AAVEGOTCHI) {
            address collateralType = s.n3rds[_tokenId].collateralType;
            uint256 numericTraits = s.n3rds[_tokenId].numericTraits;
            svg = getN3RDSvgLayers(collateralType, numericTraits, _tokenId);
        }
        ag_ = string(abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">', svg, "</svg>"));
    }

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

    function getN3RDSvgLayers(
        address _collateralType,
        uint256 _numericTraits,
        uint256 _tokenId
    ) internal view returns (bytes memory svg_) {
        SvgLayerDetails memory details;
        details.primaryColor = bytes3ToColorString(s.collateralTypeInfo[_collateralType].primaryColor);
        details.secondaryColor = bytes3ToColorString(s.collateralTypeInfo[_collateralType].secondaryColor);
        details.cheekColor = bytes3ToColorString(s.collateralTypeInfo[_collateralType].cheekColor);

        // aavagotchi body
        svg_ = LibSvg.getSvg("n3rd", 2);
        details.background = LibSvg.getSvg("n3rd", 4);
        details.collateral = LibSvg.getSvg("collaterals", s.collateralTypeInfo[_collateralType].svgId);

        details.trait = uint16(_numericTraits >> (4 * 16));
        if (details.trait < 0) {
            details.eyeShape = LibSvg.getSvg("eyeShapes", 0);
        } else if (details.trait > 97) {
            details.eyeShape = LibSvg.getSvg("eyeShapes", s.collateralTypeInfo[_collateralType].eyeShapeSvgId);
        } else {
            details.eyeShapeTraitRange = [int256(0), 1, 2, 5, 7, 10, 15, 20, 25, 42, 58, 75, 80, 85, 90, 93, 95, 98];
            for (uint256 i; i < details.eyeShapeTraitRange.length - 1; i++) {
                if (details.trait >= details.eyeShapeTraitRange[i] && details.trait < details.eyeShapeTraitRange[i + 1]) {
                    details.eyeShape = LibSvg.getSvg("eyeShapes", i);
                    break;
                }
            }
        }

        details.trait = uint16(_numericTraits >> (5 * 16));
        details.eyeColorTraitRanges = [int256(0), 2, 10, 25, 75, 90, 98, 100];
        details.eyeColors = [
            "FF00FF", // mythical_low
            "0064FF", // rare_low
            "5D24BF", // uncommon_low
            details.primaryColor, // common
            "36818E", // uncommon_high
            "EA8C27", // rare_high
            "51FFA8" // mythical_high
        ];
        if (details.trait < 0) {
            details.eyeColor = "FF00FF";
        } else if (details.trait > 99) {
            details.eyeColor = "51FFA8";
        } else {
            for (uint256 i; i < details.eyeColorTraitRanges.length - 1; i++) {
                if (details.trait >= details.eyeColorTraitRanges[i] && details.trait < details.eyeColorTraitRanges[i + 1]) {
                    details.eyeColor = details.eyeColors[i];
                    break;
                }
            }
        }

        uint256 MAX_INT = 2**256 - 1;

        //Add wearables if tokenId isn't MAX_INT
        if (_tokenId == MAX_INT) {
            svg_ = abi.encodePacked(applyStyles(details, _tokenId), details.background, svg_, details.collateral, details.eyeShape);
        } else {
            svg_ = abi.encodePacked(applyStyles(details, _tokenId), addBodyAndWearableSvgLayers(svg_, details, _tokenId));
        }
    }

    //Apply styles based on the traits and wearables
    function applyStyles(SvgLayerDetails memory _details, uint256 _tokenId) internal view returns (bytes memory) {
        uint256 equippedWearables = s.n3rds[_tokenId].equippedWearables;

        if (
            _tokenId != 2**256 - 1 &&
            (uint16(equippedWearables) != 0 || uint16(equippedWearables >> (4 * 16)) != 0 || uint16(equippedWearables >> (5 * 16)) != 0)
        ) {
            //Open-hands n3rd
            return
                abi.encodePacked(
                    "<style>.gotchi-primary{fill:#",
                    _details.primaryColor,
                    ";}.gotchi-secondary{fill:#",
                    _details.secondaryColor,
                    ";}.gotchi-cheek{fill:#",
                    _details.cheekColor,
                    ";}.gotchi-eyeColor{fill:#",
                    _details.eyeColor,
                    ";}.gotchi-sleeves-up{display:none;}",
                    ".gotchi-handsUp{display:none;}",
                    ".gotchi-handsDownOpen{display:block;}",
                    ".gotchi-handsDownClosed{display:none;}",
                    "</style>"
                );
        } else {
            //Normal N3RD, closed hands
            return
                abi.encodePacked(
                    "<style>.gotchi-primary{fill:#",
                    _details.primaryColor,
                    ";}.gotchi-secondary{fill:#",
                    _details.secondaryColor,
                    ";}.gotchi-cheek{fill:#",
                    _details.cheekColor,
                    ";}.gotchi-eyeColor{fill:#",
                    _details.eyeColor,
                    ";}.gotchi-sleeves-up{display:none;}",
                    ".gotchi-handsUp{display:none;}",
                    ".gotchi-handsDownOpen{display:none;}",
                    ".gotchi-handsDownClosed{display:block}",
                    "</style>"
                );
        }
    }

    function getWearableClass(uint256 _slotPosition) internal pure returns (string memory className_) {
        //Wearables
        /*
    uint8 internal constant WEARABLE_SLOT_BODY = 0;
    uint8 internal constant WEARABLE_SLOT_FACE = 1;
    uint8 internal constant WEARABLE_SLOT_EYES = 2;
    uint8 internal constant WEARABLE_SLOT_HEAD = 3;
    uint8 internal constant WEARABLE_SLOT_HAND_LEFT = 4;
    uint8 internal constant WEARABLE_SLOT_HAND_RIGHT = 5;
    uint8 internal constant WEARABLE_SLOT_PET = 6;
    uint8 internal constant WEARABLE_SLOT_BG = 7;
    */

        if (_slotPosition == 0) className_ = "wearable-body";
        if (_slotPosition == 1) className_ = "wearable-face";
        if (_slotPosition == 2) className_ = "wearable-eyes";
        if (_slotPosition == 3) className_ = "wearable-head";
        if (_slotPosition == 4) className_ = "wearable-hand wearable-hand-left";
        if (_slotPosition == 5) className_ = "wearable-hand wearable-hand-right";
        if (_slotPosition == 6) className_ = "wearable-pet";
        if (_slotPosition == 7) className_ = "wearable-bg";
    }

    function getWearable(uint256 _wearableId, uint256 _slotPosition) internal view returns (bytes memory svg_) {
        ItemType storage wearableType = s.itemTypes[_wearableId];
        uint256 dimensions = wearableType.dimensions;

        string memory wearableClass = getWearableClass(_slotPosition);

        svg_ = abi.encodePacked(
            '<g class="gotchi-wearable ',
            wearableClass,
            '"><svg x="',
            // x
            LibStrings.uintStr(uint8(dimensions)),
            '" y="',
            // y
            LibStrings.uintStr(uint8(dimensions >> 8)),
            '">'
        );
        if (_slotPosition == 5) {
            svg_ = abi.encodePacked(
                svg_,
                '<g transform="scale(-1, 1) translate(-',
                LibStrings.uintStr(64 - (uint8(dimensions) * 2)),
                ', 0)">',
                LibSvg.getSvg("wearables", wearableType.svgId),
                "</g></svg></g>"
            );
        } else {
            svg_ = abi.encodePacked(svg_, LibSvg.getSvg("wearables", wearableType.svgId), "</svg></g>");
        }
    }

    function addBodyAndWearableSvgLayers(
        bytes memory _body,
        SvgLayerDetails memory details,
        uint256 _tokenId
    ) internal view returns (bytes memory svg_) {
        //Wearables
        uint256 equippedWearables = s.n3rds[_tokenId].equippedWearables;

        // If background is equipped
        uint256 wearableId = uint16(equippedWearables >> (8 * 16));
        if (wearableId != 0) {
            svg_ = abi.encodePacked(getWearable(wearableId, 7), _body, details.eyeShape, details.collateral);
        } else {
            //background, body, eyes, collateral
            svg_ = abi.encodePacked(details.background, _body, details.eyeShape, details.collateral);
        }

        // get hands
        svg_ = abi.encodePacked(svg_, LibSvg.getSvg("n3rd", 3));

        // body, face, eyes, head, left hand, right hand wearables
        for (uint256 slotPosition; slotPosition < 6; slotPosition++) {
            wearableId = uint16(equippedWearables >> (slotPosition * 16));
            if (wearableId == 0) {
                continue;
            }
            svg_ = abi.encodePacked(svg_, getWearable(wearableId, slotPosition));
        }

        // pet wearable
        wearableId = uint16(equippedWearables >> (6 * 16));
        if (wearableId != 0) {
            svg_ = abi.encodePacked(svg_, getWearable(wearableId, 6));
        }
        // 1. background wearable
        // 2. body
        // 3. hands
        // 4. body wearable
        // 5. face wearable
        // 6. eyes wearable
        // 7. head wearable
        // 8. left hand wearable
        // 9. right hand wearable
        // 10. pet wearable
    }

    function portalN3RDsSvg(uint256 _tokenId) external view returns (string[PORTAL_N3RD_NUM] memory svg_) {
        require(s.n3rds[_tokenId].status == LibAppStorage.STATUS_OPEN_PORTAL, "N3RDFacet: Portal not open");
        N3RDFacet.PortalN3rdTraitsIO[PORTAL_N3RD_NUM] memory l_portalN3rdTraits =
            N3RDFacet(address(this)).portalN3RDTraits(_tokenId);
        for (uint256 i; i < svg_.length; i++) {
            address collateralType = l_portalN3rdTraits[i].collateralType;
            uint256 numericTraits = l_portalN3rdTraits[i].numericTraitsUint;
            svg_[i] = string(
                abi.encodePacked(
                    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">',
                    getN3RDSvgLayers(collateralType, numericTraits, 2**256 - 1),
                    // get hands
                    LibSvg.getSvg("n3rd", 3),
                    "</svg>"
                )
            );
        }
    }

    function getItemSvg(uint256 _itemId) external view returns (string memory ag_) {
        require(_itemId < s.itemTypes.length, "ItemsFacet: _id not found for item");
        bytes memory svg;
        svg = LibSvg.getSvg("wearables", _itemId);
        uint256 dimensions = s.itemTypes[_itemId].dimensions;
        ag_ = string(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ',
                // width
                LibStrings.uintStr(uint8(dimensions >> (2 * 8))),
                " ",
                // height
                LibStrings.uintStr(uint8(dimensions >> (3 * 8))),
                '">',
                svg,
                "</svg>"
            )
        );
    }

    /***********************************|
   |             Write Functions        |
   |__________________________________*/

    function storeSvg(string calldata _svg, LibSvg.SvgTypeAndSizes[] calldata _typesAndSizes) public onlyDaoOrOwner {
        emit StoreSvg(_typesAndSizes);
        address svgContract = storeSvgInContract(_svg);
        uint256 offset = 0;
        for (uint256 i; i < _typesAndSizes.length; i++) {
            LibSvg.SvgTypeAndSizes calldata svgTypeAndSizes = _typesAndSizes[i];
            for (uint256 j; j < svgTypeAndSizes.sizes.length; j++) {
                uint256 size = svgTypeAndSizes.sizes[j];
                s.svgLayers[svgTypeAndSizes.svgType].push(SvgLayer(svgContract, uint16(offset), uint16(size)));
                offset += size;
            }
        }
    }

    function storeSvgInContract(string calldata _svg) internal returns (address svgContract) {
        require(bytes(_svg).length < 24576, "SvgStorage: Exceeded 24,576 bytes max contract size");
        // 61_00_00 -- PUSH2 (size)
        // 60_00 -- PUSH1 (code position)
        // 60_00 -- PUSH1 (mem position)
        // 39 CODECOPY
        // 61_00_00 PUSH2 (size)
        // 60_00 PUSH1 (mem position)
        // f3 RETURN
        bytes memory init = hex"610000_600e_6000_39_610000_6000_f3";
        bytes1 size1 = bytes1(uint8(bytes(_svg).length));
        bytes1 size2 = bytes1(uint8(bytes(_svg).length >> 8));
        init[2] = size1;
        init[1] = size2;
        init[10] = size1;
        init[9] = size2;
        bytes memory code = abi.encodePacked(init, _svg);

        assembly {
            svgContract := create(0, add(code, 32), mload(code))
        }
    }
}
