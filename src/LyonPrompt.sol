// SPDX-License-Identifier: MIT
// Creator: Lyon House

pragma solidity ^0.8.17;

import "./ILyonPrompt.sol";
import "./Base64.sol";

/**
 * @dev Implementation of Lyon Project.
 */
contract LyonPrompt is ILyonPrompt {
    string private _name;
    string private _symbol;

    address private constant ADMIN = 0xb0de1700900114c7eeA69a0BEE41d1CA9B7d0412;

    mapping(uint256 => mapping(uint256 => PromptInfo)) private _prompt;
    mapping(uint256 => uint256) private _currentIndex;

    mapping(address => Prompt[]) private _requested;
    mapping(address => Prompt[]) private _replied;

    constructor() {
        _name = "Lyon Prompt";
        _symbol = "LYN";
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function tokenURI(Prompt calldata promptId)
        external
        view
        returns (string memory)
    {
        PromptInfo storage promptInfo = _prompt[promptId.templateId][promptId.id];
        require(promptInfo.promptOwner != address(0), "URIQueryForNonexistentToken");

        string[] memory parts;
        parts[
            0
        ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
        parts[1] = promptInfo.question;
        parts[2] = '</text><text x="10" y="40" class="base">';
        for (uint256 i = 0; i < promptInfo.keys.length; i++) {
            uint256 index = i * 6 + 3;
            //parts[index] = abi.encodePacked(promptInfo.keys[i]);
            parts[index + 1] = ": ";
            parts[index + 2] = promptInfo.replies[promptInfo.keys[i]].replyDetail;
            if (i == promptInfo.keys.length - 1) {
                parts[index + 3] = "</text></svg>";
            } else {
                parts[index + 3] = '</text><text x="10" y="';
                parts[index + 4] = toString(60 + i * 20);
                parts[index + 5] = '" class="base">';
            }
        }
        string memory output;
        for (uint256 i = 0; i < parts.length; i++) {
            output = string(abi.encodePacked(output, parts[i]));
        }
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"Template": ',
                        toString(promptId.templateId),
                        ',"Index": ',
                        toString(promptId.templateId),
                        '", "Question": "TBD", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(output)),
                        '"}'
                    )
                )
            )
        );

        output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }

    function totalSupply(uint256 templateId) public view returns (uint256) {
        return _currentIndex[templateId];
    }

    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30000 gas.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override
        returns (bool)
    {
        // The interface IDs are constants representing the first 4 bytes
        // of the XOR of all function selectors in the interface.
        // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
        // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
        return
            interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
            interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
            interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
    }

    function balanceOf(address owner) external view returns (uint256 balance) {
        return _requested[owner].length;
    }

    function ownerOf(Prompt calldata promptId)
        external
        view
        returns (address owner)
    {
        return _prompt[promptId.templateId][promptId.id].promptOwner;
    }

    function _mint(Prompt calldata promptId, address to) internal {
        require(to != address(0), "Cannot mint to the zero address");
        require(
            _prompt[promptId.templateId][promptId.id].promptOwner == address(0),
            "Token already minted"
        );

        _prompt[promptId.templateId][promptId.id].promptOwner = to;
        _requested[to].push(promptId);
        emit SBTMinted(promptId.templateId, promptId.id, to);
    }

    /**
     * @dev The function that frontend operator calls when someone replies to a certain Prompt
     * TODO: specify the format of `answers`: 
     * hqt suggestion: 
     *     answerUpdate(Prompt calldata promptId, ReplyInfo calldata replyinfo_input, )
     */
    function answerUpdate(Prompt calldata promptId, string calldata question, string calldata context, 
    address replierAddr, string calldata replierName, string calldata replyDetail, string calldata comment,
    bytes32 signature) external 
    {
        require(msg.sender == ADMIN, "Only admin can update for now");
        PromptInfo storage promptInfo = _prompt[promptId.templateId][promptId.id];
        ReplyInfo memory replyInfo = ReplyInfo(replierName, replyDetail, comment, signature, block.timestamp);

        promptInfo.replies[replierAddr] = replyInfo;
        promptInfo.keys.push(replierAddr);

        emit AnswerUpdated(promptId.templateId, promptId.id, promptInfo.promptOwner, promptInfo.question, replierName, replyDetail);
    }

    function queryAllRequested(address owner)
        external
        view
        returns (Prompt[] memory)
    {
        return _requested[owner];
    }

    function queryAllEndorsed(address owner)
        external
        view
        returns (Prompt[] memory)
    {
        return _replied[owner];
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
