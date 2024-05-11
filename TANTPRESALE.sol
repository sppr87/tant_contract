// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20 ^0.8.23;

// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// lib/openzeppelin-contracts/contracts/utils/Context.sol

// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// lib/openzeppelin-contracts/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// src/TantPresale.sol

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

    constructor() Ownable(msg.sender) {
        // Stage Token Max Amount
        setDetaultStageAmount();
        // Phase Price
        setStagePrice();
    }

    /*//////////////////////////////////////////////////////////////
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier priceNotZero(uint256 price) {
        if (price == 0) {
            revert TANTPRESALE_PRICE_NOT_ZERO();
        }

        _;
    }

    modifier tokenNotSet() {
        if (address(tantToken) == address(0)) {
            revert TANTPRESALE_TOKEN_NOT_SET();
        }
        _;
    }

    modifier checkLimit(uint256 amount) {
        if (getStageTokenMinted() + amount > getStageTokenLimit()) {
            revert TANTPRESALE_LIMIT_REACHED();
        }
        _;
    }

    modifier SaleNotActive() {
        if (state == PresaleState.Pause) {
            revert TANTPRESALE_NOT_ACTIVE();
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                            GET FUNCTION
    //////////////////////////////////////////////////////////////*/

    function getPresaleState() external view returns (PresaleState) {
        return state;
    }

    function getTotalTokenSold() external view returns (uint256) {
        return tokenSold;
    }

    function getStageTokenMinted() public view returns (uint256) {
        return stageTokenMinted[state];
    }

    function getStageTokenLimit() public view returns (uint256) {
        return stageTokenAmount[state];
    }

    function getStagePrice() public view returns (uint256) {
        return stagePricePerToken[state];
    }

    function getTantToken() external view returns (IERC20) {
        return tantToken;
    }

    function getETHRaised() external view returns (uint256) {
        return ethRaised;
    }

    function getUserBalance(address _user) external view returns (UserBalance memory) {
        return balance[_user];
    }

    /*//////////////////////////////////////////////////////////////
                            SET FUNCTION
    //////////////////////////////////////////////////////////////*/

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

    function setPresaleState(PresaleState _state) external onlyOwner {
        state = _state;
    }

    function setStageAmount(PresaleState _state, uint256 _amount) external onlyOwner priceNotZero(_amount) {
        stageTokenAmount[_state] = _amount;
    }

    function setTantToken(address _tantToken) external onlyOwner {
        tantToken = IERC20(_tantToken);
    }

    function setStageTokenPrice(PresaleState _state, uint256 _price) external onlyOwner priceNotZero(_price) {
        stagePricePerToken[_state] = _price;
    }

    function setStageMintedBalance(uint256 amount) internal {
        stageTokenMinted[state] += amount;
    }

    /*//////////////////////////////////////////////////////////////
                              OTHER FUNCTION
    //////////////////////////////////////////////////////////////*/

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

    function withdrawFunds() external onlyOwner {
        if (address(this).balance <= 0) {
            revert TANTPRESALE_NO_BALANCE_TO_WITHDRAW();
        }

        (bool success,) = payable(owner()).call{value: address(this).balance}("");

        if (!success) {
            revert TANTPRESALE_WITHDRAW_FAILED();
        }
    }

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

    receive() external payable {}
}
