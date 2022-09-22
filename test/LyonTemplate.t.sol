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
        // console.logInt(int 3);
        // console.log(tmpl.returnOwnershipRecord(1).templateId);
        // console.log(tmpl.returnOwnershipRecord(1).owner);
        // console.log(tmpl.returnOwnershipRecord(1).question);
        // console.log(tmpl.returnOwnershipRecord(1).context);
        // console.log(tmpl.returnOwnershipRecord(1).timeStamp);
        // console.log(tmpl.returnOwnershipRecord(1).templateURI);
        // console.log();

        // console.log(tmpl.returnOwnershipRecord(2).templateId);
        // console.log(tmpl.returnOwnershipRecord(2).owner);
        // console.log(tmpl.returnOwnershipRecord(2).question);
        // console.log(tmpl.returnOwnershipRecord(2).context);
        // console.log(tmpl.returnOwnershipRecord(2).timeStamp);
        // console.log(tmpl.returnOwnershipRecord(2).templateURI);
        // console.log();

        // console.log(tmpl.returnOwnershipRecord(3).templateId);
        // console.log(tmpl.returnOwnershipRecord(3).owner);
        // console.log(tmpl.returnOwnershipRecord(3).question);
        // console.log(tmpl.returnOwnershipRecord(3).context);
        // console.log(tmpl.returnOwnershipRecord(3).timeStamp);
        // console.log(tmpl.returnOwnershipRecord(3).templateURI);
        assertEq(tmpl.queryAllTemplates()[0].templateId, 1);
        assertEq(tmpl.queryAllTemplates()[0].owner, templateMinter1);
        assertEq(tmpl.queryAllTemplates()[0].question, "q");
        assertEq(tmpl.queryAllTemplates()[0].context, "c");
        assertEq(tmpl.queryAllTemplates()[0].timeStamp, 1);
        assertEq(tmpl.queryAllTemplates()[0].templateURI, "template 1 URI");

        assertEq(tmpl.queryAllTemplates()[1].templateId, 2);
        assertEq(tmpl.queryAllTemplates()[1].owner, templateMinter2);
        assertEq(tmpl.queryAllTemplates()[1].question, "q");
        assertEq(tmpl.queryAllTemplates()[1].context, "c");
        assertEq(tmpl.queryAllTemplates()[1].timeStamp, 1);
        assertEq(tmpl.queryAllTemplates()[1].templateURI, "template 2 URI");

        assertEq(tmpl.queryAllTemplates()[2].templateId, 3);
        assertEq(tmpl.queryAllTemplates()[2].owner, templateMinter2);
        assertEq(tmpl.queryAllTemplates()[2].question, "q");
        assertEq(tmpl.queryAllTemplates()[2].context, "c");
        assertEq(tmpl.queryAllTemplates()[2].timeStamp, 1);
        assertEq(tmpl.queryAllTemplates()[2].templateURI, "template 2 URI");
        // assertEq(
        //     tmpl.queryAllTemplates(),
        //     [
        //         LyonTemplate.templateMetaData(
        //             1,
        //             templateMinter1,
        //             "q",
        //             "c",
        //             1,
        //             "template 1 URI"
        //         ),
        //         LyonTemplate.templateMetaData(
        //             2,
        //             templateMinter2,
        //             "q",
        //             "c",
        //             1,
        //             "template 2 URI"
        //         )
        //     ]
        // );
    }

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
        bytes32 signature
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
