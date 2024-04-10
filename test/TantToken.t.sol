// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Tant} from "../src/TantToken.sol";
import {Test} from "forge-std/Test.sol";

contract TantTokenTest is Test {
    Tant public token;
    address public owner = makeAddr("owner");
    address public presale = makeAddr("presale");
    address public lp = makeAddr("lp");
    address public eco = makeAddr("eco");
    address public cashback = makeAddr("cashback");
    address public marketing = makeAddr("marketing");
    address public team = makeAddr("team");
    address public partners = makeAddr("partners");
    address public incentive = makeAddr("incentive");

    function setUp() public {
        vm.startPrank(owner);
        token = new Tant(presale, lp, eco, cashback, marketing, team, partners, incentive);
        vm.stopPrank();
    }

    function test_shouldBeCorrectOwner() public {
        assertEq(token.owner(), owner);
    }

    function test_shouldHaveCorrectSupplies() public {
        assertEq(token.totalSupply(), 1_255_000_000 * 10e18);
    }

    function test_shouldHaveCorrectPresaleSupply() public {
        assertEq(token.balanceOf(presale), (1_255_000_000 * 10e18) * 40 / 100);
    }

    function test_shouldHaveCorrectLPSupply() public {
        assertEq(token.balanceOf(lp), (1_255_000_000 * 10e18) * 15 / 100);
    }

    function test_shouldHaveCorrectEcoSupply() public {
        assertEq(token.balanceOf(eco), (1_255_000_000 * 10e18) * 20 / 100);
    }

    function test_shouldHaveCorrectCashbackSupply() public {
        assertEq(token.balanceOf(cashback), (1_255_000_000 * 10e18) * 5 / 100);
    }

    function test_shouldHaveCorrectMarketingSupply() public {
        assertEq(token.balanceOf(marketing), (1_255_000_000 * 10e18) * 10 / 100);
    }

    function test_shouldHaveCorrectTeamSupply() public {
        assertEq(token.balanceOf(team), (1_255_000_000 * 10e18) * 5 / 100);
    }

    function test_shouldHaveCorrectPartnersSupply() public {
        assertEq(token.balanceOf(partners), (1_255_000_000 * 10e18) * 2 / 100);
    }

    function test_shouldHaveCorrectIncentiveSupply() public {
        assertEq(token.balanceOf(incentive), (1_255_000_000 * 10e18) * 3 / 100);
    }
}
