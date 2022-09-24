pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "../src/LyonTemplate.sol";

contract LyonTemplateTest is Test {
    LyonTemplate tmpl;

    address public deployer = address(0);
    address public templateMinter1 = address(1);
    address public templateMinter2 = address(2);

    address public promptADMIN = 0xb0de1700900114c7eeA69a0BEE41d1CA9B7d0412;

    // the base setup for all functions (independent tests) later
    function setUp() public {
        vm.warp(1); // set block.timestamp
        tmpl = new LyonTemplate();
        vm.prank(templateMinter1);
        tmpl.mintTemplate("q", "c", "template 1 URI"); // templateId = 1

        vm.prank(templateMinter2);
        tmpl.mintTemplate("q", "c", "template 2 URI"); // templateId = 2
        vm.prank(templateMinter2);
        tmpl.mintTemplate("q", "c", "template 2 URI"); // templateId = 3
    }

    // check the template testing is correct
    function testMintTemplate() public {
        assertEq(tmpl.balanceOf(templateMinter1), 1);
        assertEq(tmpl.balanceOf(templateMinter2), 2);
        assertEq(tmpl.ownerOf(1), (templateMinter1));
        assertEq(tmpl.ownerOf(2), (templateMinter2));
        assertEq(tmpl.ownerOf(3), (templateMinter2));
    }

    function testqueryAllTemplates() public {
        assertEq(tmpl.queryAllTemplatesByAddress(templateMinter1)[0], 1);
        assertEq(tmpl.queryAllTemplatesByAddress(templateMinter2)[0], 2);
        assertEq(tmpl.queryAllTemplatesByAddress(templateMinter2)[1], 3);
    }

    // =============================================================
    //                            EVENTS
    // =============================================================

    event RepliedToPrompt(
        uint256 indexed templateId,
        uint256 indexed id,
        address indexed promptOwner,
        string question,
        address replierAddress,
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

    // struct Prompt {
    //     // The ID of the template. 第几个问题template
    //     uint256 templateId;
    //     // The ID of current prompt. 第几个用这个template问问题的
    //     uint256 id;
    // }

    // struct PromptInfo {
    //     // The address of the owner.
    //     address promptOwner;
    //     // The SBT_question
    //     string question;
    //     // The context of the prompt.
    //     string context;
    //     // Keys of replies
    //     address[] keys;
    //     // The address of the approved operator.
    //     mapping(address => ReplyInfo) replies;
    //     // The creation time of this Prompt.
    //     uint64 createTime;
    //     // Prompt URI
    //     string SBTURI;
    // }

    // struct ReplyInfo {
    //     // The alias of replier
    //     string replierName;
    //     // The reply detail.
    //     string replyDetail;
    //     // Addtional comment
    //     string comment;
    //     // The hash of the commitment/signature
    //     bytes32 signature;
    //     // The creation time of this reply.
    //     uint256 createTime;
    // }
}
