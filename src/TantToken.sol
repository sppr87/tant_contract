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
    // Error for when the TANT claim is not active
    error TANT_CLAIM_NOT_ACTIVE();
    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    // Constants for initial token supply and reserves
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
    // Addresses for reserves
    address public immutable PRESALE_ADDRESS;
    address public immutable LP_ADDRESS;
    address public immutable ECOSYSTEM_ADDRESS;
    address public immutable CASHBACK_ADDRESS;
    address public immutable MARKETING_ADDRESS;
    address public immutable TEAM_ADDRESS;
    address public immutable PARTNERS_ADDRESS;
    address public immutable INCENTIVE_ADDRESS;
    // Flag to indicate if the TANT presale claim is active
    bool private claimedLocked;

    /*//////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Constructor that mints initial reserves to specified addresses
     * @param _presale Address for the presale reserve
     * @param _lp Address for the liquidity reserve
     * @param _ecosystem Address for the ecosystem reserve
     * @param _cashback Address for the cashback reserve
     * @param _marketing Address for the marketing reserve
     * @param _team Address for the team reserve
     * @param _partners Address for the partners reserve
     * @param _incentive Address for the incentive reserve
     */
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

    /*//////////////////////////////////////////////////////////////
                            GETTERS
    //////////////////////////////////////////////////////////////*/
    /**
     * @dev Returns the number of decimals used to get its user representation.
     */
    function decimals() public pure override returns (uint8) {
        return 18;
    }

    /**
     * @dev Checks if the TANT claim is currently active.
     * @return true if the TANT claim is active, false otherwise
     */
    function isClaimActive() external view returns (bool) {
        return claimedLocked;
    }

    /**
     * @dev Returns the address of the presale reserve.
     * @return Address of the presale reserve
     */
    function getPresaleAddress() external view returns (address) {
        return PRESALE_ADDRESS;
    }

    /**
     * @dev Returns the address of the liquidity reserve.
     * @return Address of the liquidity reserve
     */
    function getLiquidityAddress() external view returns (address) {
        return LP_ADDRESS;
    }

    /*//////////////////////////////////////////////////////////////
                            SETTERS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Sets the status of the TANT claim.
     * @param _claimedLocked New status of the TANT claim
     */
    function setClaimedLocked(bool _claimedLocked) external onlyOwner {
        claimedLocked = _claimedLocked;
    }

    /**
     * @dev Internal function to update token balances with additional checks for the TANT claim.
     * @param from Address transferring tokens
     * @param to Address receiving tokens
     * @param value Amount of tokens being transferred
     */
    function _update(address from, address to, uint256 value) internal virtual override {
        // Check if claim is active and address is not presale address
        if (from == PRESALE_ADDRESS && !claimedLocked) {
            revert TANT_CLAIM_NOT_ACTIVE();
        }

        // Continue with the normal logic
        super._update(from, to, value);
    }
}
