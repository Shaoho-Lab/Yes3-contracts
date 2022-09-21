// SPDX-License-Identifier: MIT
// Creator: Lyon House

pragma solidity ^0.8.16;

import "./ILyonPrompt.sol";
import "./Base64.sol";

/**
 * @dev Implementation of Lyon Project.
 */
contract LyonPrompt is ILyonPrompt {
    // Token name
    string private _name;
    // Token symbol
    string private _symbol;

    // Admin address, only admin can mint and update now
    address private constant ADMIN = 0xb0de1700900114c7eeA69a0BEE41d1CA9B7d0412;

    // Mapping from token ID to prompt details
    // Example:
    // _prompt[templateId][id] = PromptInfo
    mapping(uint256 => mapping(uint256 => PromptInfo)) private _prompt;

    // Mapping from template ID to prompt count
    mapping(uint256 => uint256) private _currentIndex;

    // Mapping from address to all prompts it has
    mapping(address => Prompt[]) private _promptByOwner;

    // Mapping from address to all prompts it replied
    mapping(address => Prompt[]) private _promptByReplier;

    constructor() {
        _name = "Lyon Prompt";
        _symbol = "LYNP";
    }

    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of prompt in `owner`'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance) {
        if (owner == address(0)) {
            revert BalanceQueryForZeroAddress();
        }
        return _promptByOwner[owner].length;
    }

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `promptId` prompt.
     */
    function tokenURI(Prompt calldata promptId)
        external
        view
        returns (string memory)
    {
        string memory output = _prompt[promptId.templateId][promptId.id].SBTURI;
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

    /**
     * @dev Returns the owner of the `promptId` prompt.
     *
     * Requirements:
     *
     * - `promptId` must exist.
     */
    function ownerOf(Prompt calldata promptId)
        external
        view
        returns (address owner)
    {
        address promptOwner = _prompt[promptId.templateId][promptId.id]
            .promptOwner;
        if (owner == address(0)) {
            revert OwnerQueryForNonexistentToken({
                templateId: promptId.templateId,
                id: promptId.id
            });
        }
        return promptOwner;
    }

    function safeMint(
        uint256 templateId,
        string calldata question,
        string calldata context,
        address to,
        string calldata SBTURI
    ) external {
        require(to != address(0), "Cannot mint to the zero address");
        uint256 count = _currentIndex[templateId] + 1;
        _mint(templateId, question, context, to, SBTURI);
        unchecked {
            if (_currentIndex[templateId] != count) {
                revert SafeMintCheckFailed({templateId: templateId, id: count});
            }
        }
    }

    /**
     * @dev Mints prompt and transfers them to `to`.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `prompt` not exists.
     *
     * Emits a {PromptMinted} event for each mint.
     */
    function _mint(
        uint256 templateId,
        string calldata question,
        string calldata context,
        address to,
        string calldata SBTURI
    ) internal {
        uint256 id = ++_currentIndex[templateId];
        _prompt[templateId][id].promptOwner = to;
        _prompt[templateId][id].question = question;
        _prompt[templateId][id].context = context;
        _prompt[templateId][id].SBTURI = SBTURI;

        _promptByOwner[to].push(Prompt(templateId, id));

        emit PromptMinted(templateId, id, to);
    }

    /**
     * @dev Updates `promptId` prompt with data from frontend.
     */
    function replyPrompt(
        Prompt calldata promptId,
        address replierAddr,
        string calldata replierName,
        string calldata replyDetail,
        string calldata comment,
        bytes32 signature
    ) external {
        require(msg.sender == ADMIN, "Only admin can update prompt");
        ReplyInfo memory replyInfo = ReplyInfo(
            replierName,
            replyDetail,
            comment,
            signature,
            block.timestamp
        );
        PromptInfo storage promptInfo = _prompt[promptId.templateId][
            promptId.id
        ];
        promptInfo.replies[replierAddr] = replyInfo;
        promptInfo.keys.push(replierAddr);

        emit RepliedToPrompt(
            promptId.templateId,
            promptId.id,
            promptInfo.promptOwner,
            promptInfo.question,
            replierAddr,
            replierName,
            replyDetail,
            comment,
            signature
        );
    }

    /**
     * @dev Returns the id of prompts owned by `owner`.
     */
    function queryAllPromptByAddr(address owner)
        external
        view
        returns (Prompt[] memory)
    {
        return _promptByOwner[owner];
    }

    /**
     * @dev Returns the id of prompts replied by `owner`.
     */
    function queryAllRepliesByAddr(address owner)
        external
        view
        returns (Prompt[] memory)
    {
        return _promptByReplier[owner];
    }

    /**
     * @dev Returns the replies in `promptId` prompt.
     */
    function queryAllRepliesByPrompt(Prompt calldata promptId)
        external
        view
        returns (ReplyInfo[] memory)
    {
        PromptInfo storage promptInfo = _prompt[promptId.templateId][
            promptId.id
        ];
        ReplyInfo[] memory replies = new ReplyInfo[](promptInfo.keys.length);
        for (uint256 i = 0; i < promptInfo.keys.length; i++) {
            replies[i] = promptInfo.replies[promptInfo.keys[i]];
        }
        return replies;
    }

    /**
     * @dev Returns the details in `promptId` prompt.
     */
    function queryPromptInfoById(Prompt calldata promptId)
        external
        view
        returns (
            address promptOwner,
            string memory question,
            string memory context,
            string memory SBTURI,
            uint64 createTime
        )
    {
        PromptInfo storage promptInfo = _prompt[promptId.templateId][
            promptId.id
        ];
        return (
            promptInfo.promptOwner,
            promptInfo.question,
            promptInfo.context,
            promptInfo.SBTURI,
            promptInfo.createTime
        );
    }

    /**
     * @dev Burns `promptId` prompt's reply given replier.
     */
    function burnReplies(Prompt calldata promptId, address replier) external {
        PromptInfo storage promptInfo = _prompt[promptId.templateId][
            promptId.id
        ];
        delete promptInfo.replies[replier];
        for (uint256 i = 0; i < promptInfo.keys.length; i++) {
            if (promptInfo.keys[i] == replier) {
                promptInfo.keys[i] = promptInfo.keys[
                    promptInfo.keys.length - 1
                ];
                promptInfo.keys.pop();
                break;
            }
        }
        for (uint256 j = 0; j < _promptByReplier[replier].length; j++) {
            if (
                _promptByReplier[replier][j].templateId ==
                promptId.templateId &&
                _promptByReplier[replier][j].id == promptId.id
            ) {
                _promptByReplier[replier][j] = _promptByReplier[replier][
                    _promptByReplier[replier].length - 1
                ];
                _promptByReplier[replier].pop();
                break;
            }
        }
    }

    /**
     * @dev Burns `promptId` prompt.
     */
    function burnPrompt(Prompt calldata promptId) external {
        PromptInfo storage promptInfo = _prompt[promptId.templateId][
            promptId.id
        ];
        delete _prompt[promptId.templateId][promptId.id];
        for (
            uint256 i = 0;
            i < _promptByOwner[promptInfo.promptOwner].length;
            i++
        ) {
            if (_promptByOwner[promptInfo.promptOwner][i].id == promptId.id) {
                _promptByOwner[promptInfo.promptOwner][i] = _promptByOwner[
                    promptInfo.promptOwner
                ][_promptByOwner[promptInfo.promptOwner].length - 1];
                _promptByOwner[promptInfo.promptOwner].pop();
                break;
            }
        }
        for (
            uint256 j = 0;
            j < _promptByOwner[promptInfo.promptOwner].length;
            j++
        ) {
            if (_promptByOwner[promptInfo.promptOwner][j].id == promptId.id) {
                _promptByOwner[promptInfo.promptOwner][j] = _promptByOwner[
                    promptInfo.promptOwner
                ][_promptByOwner[promptInfo.promptOwner].length - 1];
                _promptByOwner[promptInfo.promptOwner].pop();
                break;
            }
        }
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
