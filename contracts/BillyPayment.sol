// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BillyPayment is Ownable {
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
    mapping(address => mapping(address => uint256)) public walletBalances;

    event BillCreated(uint256 indexed billId, address indexed payer, address indexed payee, uint256 amount);
    event BillPaid(uint256 indexed billId, address indexed payer, uint256 amount);
    event Deposited(address indexed user, address indexed token, uint256 amount);
    event Withdrawn(address indexed user, address indexed token, uint256 amount);

    constructor() Ownable(msg.sender) {}

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

    function payBill(uint256 _billId) external {
        Bill storage bill = bills[_billId];
        require(!bill.paid, "Bill already paid");
        require(msg.sender == bill.payer, "Not the payer");
        require(block.timestamp <= bill.dueDate, "Bill overdue");

        IERC20 token = IERC20(bill.token);
        require(token.transferFrom(msg.sender, bill.payee, bill.amount), "Transfer failed");

        bill.paid = true;
        emit BillPaid(_billId, msg.sender, bill.amount);
    }
}

    function deposit(address _token, uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        
        IERC20 token = IERC20(_token);
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        
        walletBalances[msg.sender][_token] += _amount;
        emit Deposited(msg.sender, _token, _amount);
    }

    function withdraw(address _token, uint256 _amount) external {
        require(walletBalances[msg.sender][_token] >= _amount, "Insufficient balance");
        
        walletBalances[msg.sender][_token] -= _amount;
        
        IERC20 token = IERC20(_token);
        require(token.transfer(msg.sender, _amount), "Transfer failed");
        
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
        
        IERC20 token = IERC20(bill.token);
        require(token.transfer(bill.payee, bill.amount), "Transfer failed");

        bill.paid = true;
        emit BillPaid(_billId, msg.sender, bill.amount);
    }
