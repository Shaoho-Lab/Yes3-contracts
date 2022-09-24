pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "../src/LyonTemplate.sol";
import "../src/LyonPrompt.sol";

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
        tmpl.mintTemplate("q1", "c1","template 1 URI"); // templateId = 0

        vm.prank(templateMinter2);
        tmpl.mintTemplate("q2", "c2","template 2 URI"); // templateId = 1
        vm.prank(templateMinter2);
        tmpl.mintTemplate("q3", "c3","template 3 URI"); // templateId = 2

        vm.prank(promptADMIN);
        prmt = new LyonPrompt();

        // testing prompts
        vm.prank(promptMinter1_1);
        prmt.safeMint(0, "question 1-1", "context1-1", replier1, "SBTURI 1-1"); // 0
        vm.prank(promptMinter1_1);
        prmt.safeMint(1, "question 2-1", "context1-1", replier1, "SBTURI 1-1"); //
        vm.prank(promptMinter1_2);
        prmt.safeMint(0, "question 1-1", "context1-2", replier1, "SBTURI 1-2");
        vm.prank(promptMinter2_1);
        prmt.safeMint(1, "question 2-1", "context2-1", replier1, "SBTURI 2-1");
        vm.prank(promptMinter2_2);
        prmt.safeMint(1, "question 2-2", "context2-2", replier1, "SBTURI 2-2");
    }

    // check Prompt minting logic
    function testPromptTotalSupply() public {
        assertEq(prmt.totalSupply(0), 2);
        assertEq(prmt.totalSupply(1), 3);
    }
}

struct templateMetaData {
    uint256 templateId;
    uint256 timeStamp;
    string templateURI; //Question recorded at Mint
}

// struct Prompt {
//     // The ID of the template. 第几个问题template
//     uint256 templateId;
//     // The ID of current prompt. 第几个用这个template问问题的
//     uint256 id;
// }

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
    uint64 createTime;
    string SBTURI;
}

struct ReplyInfo {
    // The reply detail.
    string replyDetail;
    // Addtional comment
    string comment;
    // The hash of the commitment/signature
    bytes32 signature;
    // The creation time of this reply.
    uint256 createTime;
}
