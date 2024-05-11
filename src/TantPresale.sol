// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TantPresale
 * @dev TantPresale contract for managing the presale of Tant tokens.
 * Allows users to purchase Tant tokens with Ether at various stages, claim purchased tokens,
 * and withdraw remaining funds or tokens after the presale.
 */
contract TantPresale is Ownable {
    /*//////////////////////////////////////////////////////////////
                           ERRORS
    //////////////////////////////////////////////////////////////*/

    error TANTPRESALE_PRICE_NOT_ZERO();
    error TANTPRESALE_NOT_ENOUGH_ETH();
    error TANTPRESALE_TOKEN_NOT_SET();
    error TANTPRESALE_NOT_ACTIVE();
    error TANTPRESALE_TOKEN_TRANSFER_FAILED();
    error TANTPRESALE_NOT_ENOUGH_TANT_TOKEN();
    error TANTPRESALE_NO_BALANCE_TO_WITHDRAW();
    error TANTPRESALE_WITHDRAW_FAILED();
    error TANTPRESALE_LIMIT_REACHED();

    /*//////////////////////////////////////////////////////////////
                           STRUCTS AND ENUMS
    //////////////////////////////////////////////////////////////*/

    enum PresaleState {
        Pause,
        Stage1,
        Stage2,
        Stage3,
        Stage4,
        Stage5,
        Stage6,
        Stage7,
        Stage8,
        Stage9,
        Stage10
    }

    struct UserBalance {
        uint256 amount;
        uint256 time;
        bool claimed;
    }

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    PresaleState private state = PresaleState.Pause;
    IERC20 private tantToken;
    uint256 private tokenSold;
    // Each Phase token amount
    mapping(PresaleState => uint256) private stageTokenAmount;
    // Token Minted Each Phase
    mapping(PresaleState => uint256) private stageTokenMinted;
    // ETh Raised Amount
    uint256 private ethRaised = 0;
    // Price per token
    mapping(PresaleState => uint256) private stagePricePerToken;
    // user balance
    mapping(address => UserBalance) private balance;

    /*//////////////////////////////////////////////////////////////
                              EVENTS
    //////////////////////////////////////////////////////////////*/

    event PurchasedToken(address indexed buyer, uint256 amount, uint256 price);
    event TokenClaimed(address indexed claimer, uint256 amount, uint256 timestamp);

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    /**
     * @dev Constructor function to initialize the TantPresale contract.
     * Sets the default stage token amounts and prices.
     */
    constructor() Ownable(msg.sender) {
        // Stage Token Max Amount
        setDetaultStageAmount();
        // Phase Price
        setStagePrice();
    }

    /*//////////////////////////////////////////////////////////////
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/
    /**
     * @dev Modifier to check if the price per token is not zero.
     */
    modifier priceNotZero(uint256 price) {
        if (price == 0) {
            revert TANTPRESALE_PRICE_NOT_ZERO();
        }

        _;
    }

    /**
     * @dev Modifier to check if the TANT token address is set.
     */
    modifier tokenNotSet() {
        if (address(tantToken) == address(0)) {
            revert TANTPRESALE_TOKEN_NOT_SET();
        }
        _;
    }

    /**
     * @dev Modifier to check if the purchase amount exceeds the limit for the current stage.
     */
    modifier checkLimit(uint256 amount) {
        if (getStageTokenMinted() + amount > getStageTokenLimit()) {
            revert TANTPRESALE_LIMIT_REACHED();
        }
        _;
    }

    /**
     * @dev Modifier to check if the presale is not active.
     */
    modifier SaleNotActive() {
        if (state == PresaleState.Pause) {
            revert TANTPRESALE_NOT_ACTIVE();
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                            GET FUNCTION
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Getter function to retrieve the current presale state.
     */
    function getPresaleState() external view returns (PresaleState) {
        return state;
    }

    /**
     * @dev Getter function to retrieve the total amount of tokens sold.
     */
    function getTotalTokenSold() external view returns (uint256) {
        return tokenSold;
    }

    /**
     * @dev Getter function to retrieve the token minted in the current stage.
     */
    function getStageTokenMinted() public view returns (uint256) {
        return stageTokenMinted[state];
    }

    /**
     * @dev Getter function to retrieve the token limit for the current stage.
     */
    function getStageTokenLimit() public view returns (uint256) {
        return stageTokenAmount[state];
    }

    /**
     * @dev Getter function to retrieve the price per token for the current stage.
     */
    function getStagePrice() public view returns (uint256) {
        return stagePricePerToken[state];
    }

    /**
     * @dev Getter function to retrieve the TANT token contract address.
     */
    function getTantToken() external view returns (IERC20) {
        return tantToken;
    }

    /**
     * @dev Getter function to retrieve the total Ether raised during the presale.
     */
    function getETHRaised() external view returns (uint256) {
        return ethRaised;
    }

    /**
     * @dev Getter function to retrieve the balance of a user in the presale.
     */
    function getUserBalance(address _user) external view returns (UserBalance memory) {
        return balance[_user];
    }

    /*//////////////////////////////////////////////////////////////
                            SET FUNCTION
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Internal function to set the default stage token amounts.
     */
    function setDetaultStageAmount() internal {
        stageTokenAmount[PresaleState.Stage1] = 22_000_000;
        stageTokenAmount[PresaleState.Stage2] = 35_000_000;
        stageTokenAmount[PresaleState.Stage3] = 55_000_000;
        stageTokenAmount[PresaleState.Stage4] = 60_000_000;
        stageTokenAmount[PresaleState.Stage5] = 60_000_000;
        stageTokenAmount[PresaleState.Stage6] = 60_000_000;
        stageTokenAmount[PresaleState.Stage7] = 45_000_000;
        stageTokenAmount[PresaleState.Stage8] = 45_000_000;
        stageTokenAmount[PresaleState.Stage9] = 60_000_000;
        stageTokenAmount[PresaleState.Stage10] = 60_000_000;
    }

    /**
     * @dev Internal function to set the stage prices for each stage.
     */
    function setStagePrice() internal {
        stagePricePerToken[PresaleState.Stage1] = 0.0000075 ether;
        stagePricePerToken[PresaleState.Stage2] = 0.000011 ether;
        stagePricePerToken[PresaleState.Stage3] = 0.000014 ether;
        stagePricePerToken[PresaleState.Stage4] = 0.000017 ether;
        stagePricePerToken[PresaleState.Stage5] = 0.000021 ether;
        stagePricePerToken[PresaleState.Stage6] = 0.000024 ether;
        stagePricePerToken[PresaleState.Stage7] = 0.000027 ether;
        stagePricePerToken[PresaleState.Stage8] = 0.000031 ether;
        stagePricePerToken[PresaleState.Stage9] = 0.000034 ether;
        stagePricePerToken[PresaleState.Stage10] = 0.000037 ether;
    }

    /**
     * @dev Setter function to set the presale state.
     */
    function setPresaleState(PresaleState _state) external onlyOwner {
        state = _state;
    }

    /**
     * @dev Setter function to set the token amount for a specific stage.
     */
    function setStageAmount(PresaleState _state, uint256 _amount) external onlyOwner priceNotZero(_amount) {
        stageTokenAmount[_state] = _amount;
    }

    /**
     * @dev Setter function to set the TANT token contract address.
     */
    function setTantToken(address _tantToken) external onlyOwner {
        tantToken = IERC20(_tantToken);
    }

    /**
     * @dev Setter function to set the price per token for a specific stage.
     */
    function setStageTokenPrice(PresaleState _state, uint256 _price) external onlyOwner priceNotZero(_price) {
        stagePricePerToken[_state] = _price;
    }

    /**
     * @dev Internal function to update the token minted balance for the current stage.
     */
    function setStageMintedBalance(uint256 amount) internal {
        stageTokenMinted[state] += amount;
    }

    /*//////////////////////////////////////////////////////////////
                              OTHER FUNCTION
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev External function to purchase tokens during the presale.
     */
    function purchaseToken(uint256 _amount) external payable SaleNotActive tokenNotSet checkLimit(_amount) {
        uint256 tokenAmount = _amount * 1e18;
        if (tantToken.balanceOf(address(this)) < tokenAmount) {
            revert TANTPRESALE_NOT_ENOUGH_TANT_TOKEN();
        }
        uint256 requiredETH = getStagePrice() * _amount;

        if (msg.value < requiredETH) {
            revert TANTPRESALE_NOT_ENOUGH_ETH();
        }

        tokenSold += tokenAmount;
        setStageMintedBalance(_amount);
        ethRaised += msg.value;
        if (balance[msg.sender].amount == 0) {
            balance[msg.sender] = UserBalance({amount: tokenAmount, time: block.timestamp, claimed: false});
        } else {
            balance[msg.sender].amount += tokenAmount;
            balance[msg.sender].time = block.timestamp;
        }

        emit PurchasedToken(msg.sender, tokenAmount, requiredETH);
    }

    /**
     * @dev External function to claim purchased tokens.
     */
    function claimToken() external {
        uint256 tokenAmount = balance[msg.sender].amount;

        if (tantToken.balanceOf(address(this)) < tokenAmount) {
            revert TANTPRESALE_NOT_ENOUGH_TANT_TOKEN();
        }

        tantToken.approve(address(this), tokenAmount);

        balance[msg.sender].amount = 0;
        balance[msg.sender].claimed = true;

        bool success = tantToken.transferFrom(address(this), msg.sender, tokenAmount);
        if (!success) {
            revert TANTPRESALE_TOKEN_TRANSFER_FAILED();
        }

        emit TokenClaimed(msg.sender, tokenAmount, block.timestamp);
    }

    /**
     * @dev External function to withdraw remaining Ether funds from the contract.
     */
    function withdrawFunds() external onlyOwner {
        if (address(this).balance <= 0) {
            revert TANTPRESALE_NO_BALANCE_TO_WITHDRAW();
        }

        (bool success,) = payable(owner()).call{value: address(this).balance}("");

        if (!success) {
            revert TANTPRESALE_WITHDRAW_FAILED();
        }
    }

    /**
     * @dev External function to withdraw remaining TANT tokens from the contract.
     */
    function withdrawRemainingTokens() external onlyOwner {
        uint256 tokenBalance = tantToken.balanceOf(address(this));
        if (tokenBalance <= 0) {
            revert TANTPRESALE_NO_BALANCE_TO_WITHDRAW();
        }

        tantToken.approve(address(this), tokenBalance);

        bool success = tantToken.transferFrom(address(this), owner(), tokenBalance);

        if (!success) {
            revert TANTPRESALE_WITHDRAW_FAILED();
        }
    }

    /**
     * @dev Fallback function to receive Ether payments.
     */
    receive() external payable {}
}
