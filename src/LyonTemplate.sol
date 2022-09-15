// SPDX-License-Identifier: MIT
// Creator: Lyon House

pragma solidity ^0.8.4;

import "./ILyonTemplate.sol";

/**
 * @dev Implementation of Lyon Project.
 */
contract LyonTemplate is ILyonTemplate {
    string private name;

    constructor() {
        name = "Lyon";
    }
    // test
}
