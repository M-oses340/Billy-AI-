// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IUniswapV2Router {
    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);
    
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    
    function WETH() external pure returns (address);
}

contract BillyPayment is Ownable {
    IUniswapV2Router public uniswapRouter;
    address public stablecoin; // USDC address
    bool public autoConvertEnabled;
    
    struct Bill {
        address payer;
        address payee;
        uint256 amount;
        address token;
        uint256 dueDate;
        bool paid;
    }

    mapping(uint256 => Bill) public bills;
    uint256 public billCounter;
    
    // Billy wallet balances: user => token => balance
    // Use address(0) for native ETH/MATIC
    mapping(address => mapping(address => uint256)) public walletBalances;

    event BillCreated(uint256 indexed billId, address indexed payer, address indexed payee, uint256 amount);
    event BillPaid(uint256 indexed billId, address indexed payer, uint256 amount);
    event Deposited(address indexed user, address indexed token, uint256 amount);
    event Withdrawn(address indexed user, address indexed token, uint256 amount);
    event AutoConverted(address indexed user, address indexed fromToken, uint256 amountIn, uint256 amountOut);

    constructor(address _uniswapRouter, address _stablecoin) Ownable(msg.sender) {
        uniswapRouter = IUniswapV2Router(_uniswapRouter);
        stablecoin = _stablecoin;
        autoConvertEnabled = true;
    }

    function setAutoConvert(bool _enabled) external onlyOwner {
        autoConvertEnabled = _enabled;
    }

    function setStablecoin(address _stablecoin) external onlyOwner {
        stablecoin = _stablecoin;
    }

    // Receive native ETH/MATIC and auto-convert to stablecoin
    receive() external payable {
        if (autoConvertEnabled && msg.value > 0) {
            _convertToStablecoin(msg.sender, msg.value);
        } else {
            walletBalances[msg.sender][address(0)] += msg.value;
            emit Deposited(msg.sender, address(0), msg.value);
        }
    }

    function createBill(address _payee, uint256 _amount, address _token, uint256 _dueDate) external returns (uint256) {
        billCounter++;
        bills[billCounter] = Bill({
            payer: msg.sender,
            payee: _payee,
            amount: _amount,
            token: _token,
            dueDate: _dueDate,
            paid: false
        });

        emit BillCreated(billCounter, msg.sender, _payee, _amount);
        return billCounter;
    }

    // Deposit native ETH/MATIC with optional auto-convert
    function depositNative(bool convertToStable) external payable {
        require(msg.value > 0, "Amount must be greater than 0");
        
        if (convertToStable && autoConvertEnabled) {
            _convertToStablecoin(msg.sender, msg.value);
        } else {
            walletBalances[msg.sender][address(0)] += msg.value;
            emit Deposited(msg.sender, address(0), msg.value);
        }
    }

    // Deposit ERC20 tokens with optional auto-convert
    function deposit(address _token, uint256 _amount, bool convertToStable) external {
        require(_token != address(0), "Use depositNative for native currency");
        require(_amount > 0, "Amount must be greater than 0");
        
        IERC20 token = IERC20(_token);
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        
        if (convertToStable && autoConvertEnabled && _token != stablecoin) {
            _convertTokenToStablecoin(msg.sender, _token, _amount);
        } else {
            walletBalances[msg.sender][_token] += _amount;
            emit Deposited(msg.sender, _token, _amount);
        }
    }

    function withdraw(address _token, uint256 _amount) external {
        require(walletBalances[msg.sender][_token] >= _amount, "Insufficient balance");
        
        walletBalances[msg.sender][_token] -= _amount;
        
        if (_token == address(0)) {
            // Withdraw native ETH/MATIC
            (bool success, ) = payable(msg.sender).call{value: _amount}("");
            require(success, "Native transfer failed");
        } else {
            // Withdraw ERC20 token
            IERC20 token = IERC20(_token);
            require(token.transfer(msg.sender, _amount), "Transfer failed");
        }
        
        emit Withdrawn(msg.sender, _token, _amount);
    }

    function getWalletBalance(address _user, address _token) external view returns (uint256) {
        return walletBalances[_user][_token];
    }

    function payBillFromWallet(uint256 _billId) external {
        Bill storage bill = bills[_billId];
        require(!bill.paid, "Bill already paid");
        require(msg.sender == bill.payer, "Not the payer");
        require(block.timestamp <= bill.dueDate, "Bill overdue");
        require(walletBalances[msg.sender][bill.token] >= bill.amount, "Insufficient wallet balance");

        walletBalances[msg.sender][bill.token] -= bill.amount;
        
        if (bill.token == address(0)) {
            // Pay with native ETH/MATIC
            (bool success, ) = payable(bill.payee).call{value: bill.amount}("");
            require(success, "Native transfer failed");
        } else {
            // Pay with ERC20 token
            IERC20 token = IERC20(bill.token);
            require(token.transfer(bill.payee, bill.amount), "Transfer failed");
        }

        bill.paid = true;
        emit BillPaid(_billId, msg.sender, bill.amount);
    }

    // Internal function to convert native ETH/MATIC to stablecoin
    function _convertToStablecoin(address user, uint256 amount) internal {
        address[] memory path = new address[](2);
        path[0] = uniswapRouter.WETH(); // WETH or WMATIC
        path[1] = stablecoin; // USDC
        
        uint256[] memory amounts = uniswapRouter.swapExactETHForTokens{value: amount}(
            0, // Accept any amount of stablecoin (in production, set slippage tolerance)
            path,
            address(this),
            block.timestamp + 300 // 5 minute deadline
        );
        
        uint256 stablecoinAmount = amounts[1];
        walletBalances[user][stablecoin] += stablecoinAmount;
        
        emit AutoConverted(user, address(0), amount, stablecoinAmount);
        emit Deposited(user, stablecoin, stablecoinAmount);
    }
    
    // Internal function to convert ERC20 token to stablecoin
    function _convertTokenToStablecoin(address user, address token, uint256 amount) internal {
        IERC20(token).approve(address(uniswapRouter), amount);
        
        address[] memory path = new address[](3);
        path[0] = token;
        path[1] = uniswapRouter.WETH(); // Route through WETH/WMATIC
        path[2] = stablecoin;
        
        uint256[] memory amounts = uniswapRouter.swapExactTokensForTokens(
            amount,
            0, // Accept any amount of stablecoin (in production, set slippage tolerance)
            path,
            address(this),
            block.timestamp + 300
        );
        
        uint256 stablecoinAmount = amounts[2];
        walletBalances[user][stablecoin] += stablecoinAmount;
        
        emit AutoConverted(user, token, amount, stablecoinAmount);
        emit Deposited(user, stablecoin, stablecoinAmount);
    }
    
    // Manual conversion function for existing balances
    function convertToStablecoin(address _token, uint256 _amount) external {
        require(walletBalances[msg.sender][_token] >= _amount, "Insufficient balance");
        require(_token != stablecoin, "Already stablecoin");
        
        walletBalances[msg.sender][_token] -= _amount;
        
        if (_token == address(0)) {
            _convertToStablecoin(msg.sender, _amount);
        } else {
            _convertTokenToStablecoin(msg.sender, _token, _amount);
        }
    }
}
