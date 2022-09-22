// SPDX-License-Identifier: MIT
// Creator: Lyon Protocol

pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract LyonTemplate is ERC721("Lyon Template","LYNT"){
    error Unauthorized();

    uint templateId = 1;
    mapping(uint256 => templateMetaData) public ownershipRecord;
    mapping(uint256 => uint256) public promptCount;

    struct templateMetaData{
        uint256 templateId;
        address owner;
        string question;
        string context;
        uint256 timeStamp;
        string templateURI; //Question recorded at Mint
    }

    function mintTemplate(string memory question, string memory context, string memory _templateURI) external {
        _safeMint(msg.sender, templateId);
        ownershipRecord[templateId] = templateMetaData(templateId, msg.sender, question, context, block.timestamp, _templateURI);
        unchecked{
            ++templateId;
        }
    }

    function newPrompMinted(uint256 promptId) external {
        unchecked{
            ++promptCount[promptId]; 
        }
    }

    function queryAllTemplates() external view returns (templateMetaData[] memory){
        templateMetaData[] memory allTemplates = new templateMetaData[](templateId);
        for(uint i = 1; i < templateId + 1; i++){
            allTemplates[i - 1] = ownershipRecord[i];
        }
        return allTemplates;
    }
}
