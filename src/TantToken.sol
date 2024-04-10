// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Tant
 * @dev Tant token contract with initial reserves and addresses
 */
contract Tant is ERC20, ERC20Burnable, Ownable {
    uint256 public constant INITIAL_SUPPLU = 1_255_000_000;
    uint256 public constant TOTAL_SUPPLY = INITIAL_SUPPLU * 10e18;
    // Reserves in percent
    uint256 public constant PRESALE_RESERVE = TOTAL_SUPPLY * 40 / 100;
    uint256 public constant LP_RESERVE = TOTAL_SUPPLY * 15 / 100;
    uint256 public constant ECOSYSTEM_RESERVE = TOTAL_SUPPLY * 20 / 100;
    uint256 public constant CASHBACK_RESERVE = TOTAL_SUPPLY * 5 / 100;
    uint256 public constant MARKETING_RESERVE = TOTAL_SUPPLY * 10 / 100;
    uint256 public constant TEAM_RESERVE = TOTAL_SUPPLY * 5 / 100;
    uint256 public constant PARTNERS_RESERVE = TOTAL_SUPPLY * 2 / 100;
    uint256 public constant INCENTIVE_RESERVE = TOTAL_SUPPLY * 3 / 100;
    // Addresses
    address public immutable PRESALE_ADDRESS;
    address public immutable LP_ADDRESS;
    address public immutable ECOSYSTEM_ADDRESS;
    address public immutable CASHBACK_ADDRESS;
    address public immutable MARKETING_ADDRESS;
    address public immutable TEAM_ADDRESS;
    address public immutable PARTNERS_ADDRESS;
    address public immutable INCENTIVE_ADDRESS;

    constructor(
        address _presale,
        address _lp,
        address _ecosystem,
        address _cashback,
        address _marketing,
        address _team,
        address _partners,
        address _incentive
    ) ERC20("Tant Finance", "Tant") Ownable(msg.sender) {
        PRESALE_ADDRESS = _presale;
        LP_ADDRESS = _lp;
        ECOSYSTEM_ADDRESS = _ecosystem;
        CASHBACK_ADDRESS = _cashback;
        MARKETING_ADDRESS = _marketing;
        TEAM_ADDRESS = _team;
        PARTNERS_ADDRESS = _partners;
        INCENTIVE_ADDRESS = _incentive;

        _mint(PRESALE_ADDRESS, PRESALE_RESERVE);
        _mint(LP_ADDRESS, LP_RESERVE);
        _mint(ECOSYSTEM_ADDRESS, ECOSYSTEM_RESERVE);
        _mint(CASHBACK_ADDRESS, CASHBACK_RESERVE);
        _mint(MARKETING_ADDRESS, MARKETING_RESERVE);
        _mint(TEAM_ADDRESS, TEAM_RESERVE);
        _mint(PARTNERS_ADDRESS, PARTNERS_RESERVE);
        _mint(INCENTIVE_ADDRESS, INCENTIVE_RESERVE);
    }
}
