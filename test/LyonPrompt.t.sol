pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "../src/LyonTemplate.sol";
import "../src/LyonPrompt.sol";

contract LyonPromptTest is Test {
    template tmpl;
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
        tmpl = new template();
        vm.prank(templateMinter1);
        tmpl.mintTemplate("template 1 URI"); // templateId = 0

        vm.prank(templateMinter2);
        tmpl.mintTemplate("template 2 URI"); // templateId = 1
        vm.prank(templateMinter2);
        tmpl.mintTemplate("template 2 URI"); // templateId = 2

        vm.prank(promptADMIN);
        prmt = new LyonPrompt();

        vm.prank(promptMinter1_1);
        prmt._mint(0, "question 1-1", "context1-1", replier1, "SBTURI 1-1");
        vm.prank(promptMinter1_2);
        prmt._mint(0, "question 1-1", "context1-2", replier1, "SBTURI 1-2");
        // vm.prank(promptMinter2_1);
        // prmt._mint(0, "question 2-1", "context2-1", replier1, "SBTURI 2-1");
        // vm.prank(promptMinter2_2);
        // prmt._mint(0, "question 2-2", "context2-2", replier1, "SBTURI 2-2");
    }

    // check the template testing is correct
    function testMintTemplate() public {
        assertEq(tmpl.balanceOf(templateMinter1), 1);
        assertEq(tmpl.balanceOf(templateMinter2), 2);
        assertEq(tmpl.ownerOf(0), (templateMinter1));
        assertEq(tmpl.ownerOf(1), (templateMinter2));
        assertEq(tmpl.ownerOf(2), (templateMinter2));
    }

    // check Prompt info
    function testMintPrompt() public {}
}
struct templateMetaData {
    uint256 templateId;
    uint256 timeStamp;
    string templateURI; //Question recorded at Mint
}
