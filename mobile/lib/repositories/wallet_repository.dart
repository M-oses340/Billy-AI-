import '../models/wallet.dart';
import '../services/web3_service.dart';

class WalletRepository {
  final Web3Service web3Service;

  WalletRepository(this.web3Service);

  Future<String> connectWallet() async {
    return await web3Service.connectWallet();
  }

  Future<void> disconnectWallet() async {
    await web3Service.disconnectWallet();
  }

  Future<List<WalletBalance>> getBalances(String address) async {
    return await web3Service.getWalletBalances(address);
  }

  Future<void> deposit(String token, double amount) async {
    await web3Service.depositToWallet(token, amount);
  }

  Future<void> withdraw(String token, double amount) async {
    await web3Service.withdrawFromWallet(token, amount);
  }
}
