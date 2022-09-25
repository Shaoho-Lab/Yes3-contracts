// SPDX-License-Identifier: MIT
// Creator: Lyon Protocol

pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract LyonTemplate is ERC721("Lyon Template","LYNT"){
    error Unauthorized();

    uint templateId = 1;
    mapping(uint256 => templateMetaData) private _ownershipRecord;
    mapping(uint256 => uint256) private _promptCount;
    mapping(address => uint256[]) private _templateByAddress;

    struct templateMetaData{
        uint256 templateId;
        address ownerAddress;
        string question;
        string context;
        uint256 createTime;
        string templateURI; //Question recorded at Mint
    }

    function mintTemplate(string memory question, string memory context, string memory _templateURI) external {
        _safeMint(msg.sender, templateId);
        _ownershipRecord[templateId] = templateMetaData(templateId, msg.sender, question, context, block.timestamp, _templateURI);
        _templateByAddress[msg.sender].push(templateId);
        unchecked{
            ++templateId;
        }
    }

    function setTokenURI() external{

    }

    function queryTokenURI() external{
        
    }

    function newPrompMinted(uint256 promptId) external {
        unchecked{
            ++_promptCount[promptId]; 
        }
    }

    function queryAllTemplatesByAddress(address owner) external view returns (uint256[] memory){
        return _templateByAddress[owner];
    }
}
