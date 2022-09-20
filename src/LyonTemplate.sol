// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract template is ERC721("Lyon Template","LYNT"){
    error Unauthorized();

    uint templateId = 1;
    mapping(uint => templateMetaData[]) public ownershipRecord;
    mapping(uint256 => uint256) public promptCount;

    struct templateMetaData{
        uint256 templateId;
        uint256 timeStamp;
        string templateURI; //Question recorded at Mint
    }

    function mintTemplate(string memory _templateURI) external {
        _safeMint(msg.sender, templateId);
        ownershipRecord[templateId].push(templateMetaData(templateId, block.timestamp, _templateURI));
        unchecked{
            ++templateId;
        }
    }

    function newPrompMinted(uint256 promptId) external {
        unchecked{
            ++promptCount[promptId]; 
        }
    }
}
