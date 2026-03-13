const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BillyPayment", function () {
  let billyPayment;
  let owner, user1, user2;

  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();
    
    const BillyPayment = await ethers.getContractFactory("BillyPayment");
    billyPayment = await BillyPayment.deploy();
    await billyPayment.waitForDeployment();
  });

  describe("Native Currency Deposits", function () {
    it("Should deposit native ETH/MATIC via depositNative", async function () {
      const depositAmount = ethers.parseEther("1");
      
      await billyPayment.connect(user1).depositNative({ value: depositAmount });
      
      const balance = await billyPayment.walletBalances(user1.address, ethers.ZeroAddress);
      expect(balance).to.equal(depositAmount);
    });

    it("Should deposit native ETH/MATIC via receive function", async function () {
      const depositAmount = ethers.parseEther("0.5");
      
      await user1.sendTransaction({
        to: await billyPayment.getAddress(),
        value: depositAmount
      });
      
      const balance = await billyPayment.walletBalances(user1.address, ethers.ZeroAddress);
      expect(balance).to.equal(depositAmount);
    });

    it("Should emit Deposited event", async function () {
      const depositAmount = ethers.parseEther("1");
      
      await expect(billyPayment.connect(user1).depositNative({ value: depositAmount }))
        .to.emit(billyPayment, "Deposited")
        .withArgs(user1.address, ethers.ZeroAddress, depositAmount);
    });
  });

  describe("Native Currency Withdrawals", function () {
    it("Should withdraw native ETH/MATIC", async function () {
      const depositAmount = ethers.parseEther("1");
      const withdrawAmount = ethers.parseEther("0.5");
      
      await billyPayment.connect(user1).depositNative({ value: depositAmount });
      
      const balanceBefore = await ethers.provider.getBalance(user1.address);
      const tx = await billyPayment.connect(user1).withdraw(ethers.ZeroAddress, withdrawAmount);
      const receipt = await tx.wait();
      const gasUsed = receipt.gasUsed * receipt.gasPrice;
      const balanceAfter = await ethers.provider.getBalance(user1.address);
      
      expect(balanceAfter).to.equal(balanceBefore + withdrawAmount - gasUsed);
    });

    it("Should fail withdrawal with insufficient balance", async function () {
      const withdrawAmount = ethers.parseEther("1");
      
      await expect(
        billyPayment.connect(user1).withdraw(ethers.ZeroAddress, withdrawAmount)
      ).to.be.revertedWith("Insufficient balance");
    });
  });

  describe("Bill Creation and Payment", function () {
    it("Should create bill with native currency", async function () {
      const amount = ethers.parseEther("0.1");
      const dueDate = Math.floor(Date.now() / 1000) + 86400; // 1 day from now
      
      await billyPayment.connect(user1).createBill(
        user2.address,
        amount,
        ethers.ZeroAddress,
        dueDate
      );
      
      const bill = await billyPayment.bills(1);
      expect(bill.payer).to.equal(user1.address);
      expect(bill.payee).to.equal(user2.address);
      expect(bill.amount).to.equal(amount);
      expect(bill.token).to.equal(ethers.ZeroAddress);
    });

    it("Should pay bill from wallet with native currency", async function () {
      const amount = ethers.parseEther("0.1");
      const dueDate = Math.floor(Date.now() / 1000) + 86400;
      
      // Deposit funds
      await billyPayment.connect(user1).depositNative({ value: amount });
      
      // Create bill
      await billyPayment.connect(user1).createBill(
        user2.address,
        amount,
        ethers.ZeroAddress,
        dueDate
      );
      
      // Pay bill
      const balanceBefore = await ethers.provider.getBalance(user2.address);
      await billyPayment.connect(user1).payBillFromWallet(1);
      const balanceAfter = await ethers.provider.getBalance(user2.address);
      
      expect(balanceAfter).to.equal(balanceBefore + amount);
      
      const bill = await billyPayment.bills(1);
      expect(bill.paid).to.be.true;
    });
  });
});
