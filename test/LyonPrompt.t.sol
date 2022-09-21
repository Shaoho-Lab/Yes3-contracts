pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "../src/LyonTemplate.sol";
import "../src/LyonPrompt.sol";
import "../src/ILyonPrompt.sol";

contract LyonPromptTest is Test {
    LyonTemplate tmpl;
    LyonPrompt prmt;

    // mapping(address => templateMetaData[]) public ownershipRecord;
    // mapping(uint256 => uint256) public promptCount;
    // struct templateMetaData {
    //     uint256 templateId;
    //     uint256 timeStamp;
    //     string templateURI; //Question recorded at Mint
    // }

    address public deployer = address(0);
    address public templateMinter1 = address(1);
    address public templateMinter2 = address(2);
    address public promptMinter1_1 = address(3);
    address public promptMinter1_2 = address(4);
    address public promptMinter2_1 = address(5);
    address public promptMinter2_2 = address(4);
    address public replier1 = address(2342);

    address public promptADMIN = 0xb0de1700900114c7eeA69a0BEE41d1CA9B7d0412;

    // the base setup for all functions (independent tests) later
    function setUp() public {
        tmpl = new LyonTemplate();
        vm.prank(templateMinter1);
        tmpl.mintTemplate("q", "c", "template 1 URI"); // templateId = 1

        vm.prank(templateMinter2);
        tmpl.mintTemplate("q", "c", "template 2 URI"); // templateId = 2
        vm.prank(templateMinter2);
        tmpl.mintTemplate("q", "c", "template 2 URI"); // templateId = 3

        vm.prank(promptADMIN);
        prmt = new LyonPrompt();

        // testing prompts
        vm.prank(promptMinter1_1);
        prmt.safeMint(
            1,
            "question 1-1",
            "context1-1",
            promptMinter1_1,
            "SBTURI 1-1"
        ); // 1
        vm.prank(promptMinter1_1);
        prmt.safeMint(
            2,
            "question 2-1",
            "context1-1",
            promptMinter1_1,
            "SBTURI 1-1"
        ); //
        vm.prank(promptMinter1_2);
        prmt.safeMint(
            1,
            "question 1-1",
            "context1-2",
            promptMinter1_2,
            "SBTURI 1-2"
        );
        vm.prank(promptMinter2_1);
        prmt.safeMint(
            2,
            "question 2-1",
            "context2-1",
            promptMinter2_1,
            "SBTURI 2-1"
        );
        vm.prank(promptMinter2_2);
        prmt.safeMint(
            2,
            "question 2-2",
            "context2-2",
            promptMinter2_2,
            "SBTURI 2-2"
        );
    }

    function testPromptMintEvent() public {
        // test PromptMinted event
        vm.expectEmit(true, true, true, true);
        emit PromptMinted(
            1, // templateId
            3, // id
            promptMinter1_1 // to
        );
        prmt.safeMint(
            1, // templateId
            "test question1", // question
            "context2-2", // context
            promptMinter1_1, // to
            "SBTURI 2-2" // SBTURI
        );
    }

    function testPromptReplyEvent() public {
        // test RepliedToPrompt
        vm.expectEmit(true, true, true, true);
        emit RepliedToPrompt(
            1, // templateId
            1, // id
            promptMinter1_1, // promptOwner
            "question 1-1", // question
            address(3245), // replierAddr
            "replier1", // replierName
            "replydetail1", // replyDetail
            "comment1", //comment
            "0xaaa" // signature
        );
        vm.prank(promptADMIN);
        prmt.replyPrompt(
            ILyonPrompt.Prompt(1, 1), // promptId
            address(3245), // replierAddr
            "replier1", // replierName
            "replydetail1", // replyDetail,
            "comment1", //comment
            "0xaaa" // signature
        );
    }

    function testFailPromptAnyoneReply() public {
        vm.prank(address(3245));
        prmt.replyPrompt(
            ILyonPrompt.Prompt(1, 1), // promptId
            address(3245), // replierAddr
            "replier1", // replierName
            "replydetail1", // replyDetail,
            "comment1", //comment
            "0xaaa" // signature
        );
    }

    function testqueryAllPromptByAddr() public {
        // prmt.queryAllPromptByAddr(owner);
        assertEq(prmt.queryAllPromptByAddr(promptMinter1_1)[0].templateId, 1);
        assertEq(prmt.queryAllPromptByAddr(promptMinter1_1)[0].id, 1);
        assertEq(prmt.queryAllPromptByAddr(promptMinter1_1)[1].templateId, 1);
        assertEq(prmt.queryAllPromptByAddr(promptMinter1_1)[1].id, 2);
    }

    // check the template testing is correct
    function testMintTemplate() public {
        assertEq(tmpl.balanceOf(templateMinter1), 1);
        assertEq(tmpl.balanceOf(templateMinter2), 2);
        assertEq(tmpl.ownerOf(1), (templateMinter1));
        assertEq(tmpl.ownerOf(2), (templateMinter2));
        assertEq(tmpl.ownerOf(3), (templateMinter2));
    }

    // check Prompt minting logic
    function testPromptTotalSupply() public {
        assertEq(prmt.totalSupply(1), 2);
        assertEq(prmt.totalSupply(2), 3);
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
