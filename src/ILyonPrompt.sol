// SPDX-License-Identifier: MIT
// Creator: Lyon House

pragma solidity ^0.8.16;

/**
 * @dev Interface of Prompt.
 */
interface ILyonPrompt {
    // =============================================================
    //                            ERRORS
    // =============================================================

    /**
     * Cannot query the balance for the zero address.
     */
    error BalanceQueryForZeroAddress();

    /**
     * The token does not exist.
     */
    error OwnerQueryForNonexistentToken(uint256 templateId, uint256 id);

    /**
     * The token does not exist.
     */
    error URIQueryForNonexistentToken();

    /**
     * SafeMint failed due to network error.
     */
    error SafeMintCheckFailed(uint256 templateId, uint256 id);

    // =============================================================
    //                            EVENTS
    // =============================================================

    event RepliedToPrompt(
        uint256 indexed templateId,
        uint256 indexed id,
        address indexed promptOwner,
        string question,
        address replierAddr,
        string replierName,
        string replyDetail,
        string comment,
        bytes32 signature,
        uint256 creationTime
    );

    event PromptMinted(
        uint256 indexed templateId,
        uint256 indexed id,
        address indexed to
    );

    // =============================================================
    //                            STRUCTS
    // =============================================================

    struct Prompt {
        // The ID of the template. 第几个问题template
        uint256 templateId;
        // The ID of current prompt. 第几个用这个template问问题的
        uint256 id;
    }

    struct PromptInfo {
        // The address of the owner.
        address promptOwner;
        // The SBT_question
        string question;
        // The context of the prompt.
        string context;
        // Keys of replies
        address[] keys;
        // The address of the approved operator.
        mapping(address => ReplyInfo) replies;
        // The creation time of this Prompt.
        uint256 createTime;
        // Prompt URI
        string SBTURI;
    }

    struct ReplyInfo {
        // The alias of replier
        string replierName;
        // The reply detail.
        string replyDetail;
        // Addtional comment
        string comment;
        // The hash of the commitment/signature
        bytes32 signature;
        // The creation time of this reply.
        uint256 createTime;
    }

    // =============================================================
    //                         TOKEN COUNTERS
    // =============================================================

    /**
     * @dev Returns the total number of tokens in existence.
     * Burned tokens will reduce the count.
     * To get the total number of tokens minted, please see {_totalMinted}.
     */
    function totalSupply(uint256 templateId) external view returns (uint256);

    // =============================================================
    //                            IERC165
    // =============================================================

    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    // =============================================================
    //                            IERC721
    // =============================================================

    /**
     * @dev Returns the number of tokens in `owner`'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(Prompt calldata tokenId)
        external
        view
        returns (address owner);

    // /**
    //  * @dev Safely transfers `tokenId` token from `from` to `to`,
    //  * checking first that contract recipients are aware of the ERC721 protocol
    //  * to prevent tokens from being forever locked.
    //  *
    //  * Requirements:
    //  *
    //  * - `from` cannot be the zero address.
    //  * - `to` cannot be the zero address.
    //  * - `tokenId` token must exist and be owned by `from`.
    //  * - If the caller is not `from`, it must be have been allowed to move
    //  * this token by either {approve} or {setApprovalForAll}.
    //  * - If `to` refers to a smart contract, it must implement
    //  * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
    //  *
    //  * Emits a {Transfer} event.
    //  */
    // function safeTransferFrom(
    //     address from,
    //     address to,
    //     uint256 tokenId,
    //     bytes calldata data
    // ) external payable;

    // /**
    //  * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
    //  */
    // function safeTransferFrom(
    //     address from,
    //     address to,
    //     uint256 tokenId
    // ) external payable;

    // /**
    //  * @dev Transfers `tokenId` from `from` to `to`.
    //  *
    //  * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
    //  * whenever possible.
    //  *
    //  * Requirements:
    //  *
    //  * - `from` cannot be the zero address.
    //  * - `to` cannot be the zero address.
    //  * - `tokenId` token must be owned by `from`.
    //  * - If the caller is not `from`, it must be approved to move this token
    //  * by either {approve} or {setApprovalForAll}.
    //  *
    //  * Emits a {Transfer} event.
    //  */
    // function transferFrom(
    //     address from,
    //     address to,
    //     uint256 tokenId
    // ) external payable;

    // /**
    //  * @dev Gives permission to `to` to transfer `tokenId` token to another account.
    //  * The approval is cleared when the token is transferred.
    //  *
    //  * Only a single account can be approved at a time, so approving the
    //  * zero address clears previous approvals.
    //  *
    //  * Requirements:
    //  *
    //  * - The caller must own the token or be an approved operator.
    //  * - `tokenId` must exist.
    //  *
    //  * Emits an {Approval} event.
    //  */
    // function approve(address to, uint256 tokenId) external payable;

    // /**
    //  * @dev Approve or remove `operator` as an operator for the caller.
    //  * Operators can call {transferFrom} or {safeTransferFrom}
    //  * for any token owned by the caller.
    //  *
    //  * Requirements:
    //  *
    //  * - The `operator` cannot be the caller.
    //  *
    //  * Emits an {ApprovalForAll} event.
    //  */
    // function setApprovalForAll(address operator, bool _approved) external;

    // /**
    //  * @dev Returns the account approved for `tokenId` token.
    //  *
    //  * Requirements:
    //  *
    //  * - `tokenId` must exist.
    //  */
    // function getApproved(uint256 tokenId) external view returns (address operator);

    // /**
    //  * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
    //  *
    //  * See {setApprovalForAll}.
    //  */
    // function isApprovedForAll(address owner, address operator) external view returns (bool);

    // =============================================================
    //                        IERC721Metadata
    // =============================================================

    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(Prompt calldata tokenId)
        external
        view
        returns (string memory);

    // /**
    //  * @dev Requests 'to' to endorse 'from'.
    //  */
    // function requestEndorse(address from, address to, uint interval) external;

    // /**
    //  * @dev ‘to’ approves Prompt to 'from'.
    //  */
    // function approveEndorse(address from, address to) external;
}
