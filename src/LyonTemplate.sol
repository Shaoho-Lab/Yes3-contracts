// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";

contract template is ERC721("Lyon Protocol","LYN"){
    error Unauthorized();

    uint templateId = 0;
    mapping(address => templateMetaData[]) public ownershipRecord;
    // #of sbt minted
    mapping(uint256 => uint256) public promptCount;

    struct templateMetaData{
        uint templateId;
        uint timeStamp;
        string templateURI; //Question recorded at Mint
    }

    function mintTemplate(address recipient, string memory _templateURI) external {
        _safeMint(recipient, templateId);
        ownershipRecord[recipient].push(templateMetaData(templateId, block.timestamp, _templateURI));
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
