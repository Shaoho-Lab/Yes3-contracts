pragma solidity 0.8.16;

// import "forge-std/Test.sol";

// contract ContractBTest is Test {
//     uint256 testNumber;

//     function setUp() public {
//         testNumber = 42;
//     }

//     function testNumberIs42() public {
//         assertEq(testNumber, 42);
//     }

//     function testFailSubtract43() public {
//         testNumber -= 43;
//     }
// }

// error Unauthorized();

// contract OwnerUpOnly {
//     address public immutable owner;
//     uint256 public count;

//     constructor() {
//         owner = msg.sender;
//     }

//     function increment() external {
//         if (msg.sender != owner) {
//             revert Unauthorized();
//         }
//         count++;
//     }
// }

// contract OwnerUpOnlyTest is Test {
//     OwnerUpOnly upOnly;

//     function setUp() public {
//         upOnly = new OwnerUpOnly();
//     }

//     function testIncrementAsOwner() public {
//         assertEq(upOnly.count(), 0);
//         upOnly.increment();
//         assertEq(upOnly.count(), 1);
//     }

//     function testFailIncrementAsNotOwner() public {
//         vm.prank(address(0));
//         upOnly.increment();
//     }

//     function testIncrementAsNotOwner() public {
//         vm.expectRevert(Unauthorized.selector);
//         vm.prank(address(0));
//         upOnly.increment();
//     }
// }

// // =============================================================
// //                            ExpectEvent test
// // =============================================================

// contract ExpectEmit {
//     event Transfer(address indexed from, address indexed to, uint256 amount);

//     function t() public {
//         emit Transfer(msg.sender, address(1337), 1337);
//     }
// }

// contract EmitContractTest is Test {
//     event Transfer(address indexed from, address indexed to, uint256 amount);

//     function testExpectEmit() public {
//         ExpectEmit emitter = new ExpectEmit();
//         // Check that topic 1, topic 2, and data are the same as the following emitted event.
//         // Checking topic 3 here doesn't matter, because `Transfer` only has 2 indexed topics.
//         vm.expectEmit(true, true, false, true);
//         // The event we expect
//         emit Transfer(address(this), address(1337), 1337);
//         // The event we get
//         emitter.t();
//     }

//     function testExpectEmitDoNotCheckData() public {
//         ExpectEmit emitter = new ExpectEmit();
//         // Check topic 1 and topic 2, but do not check data
//         vm.expectEmit(true, true, false, false);
//         // The event we expect
//         emit Transfer(address(this), address(1337), 1338);
//         // The event we get
//         emitter.t();
//     }
// }
