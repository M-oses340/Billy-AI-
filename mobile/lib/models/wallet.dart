import 'package:equatable/equatable.dart';

class WalletBalance extends Equatable {
  final String token;
  final String tokenSymbol;
  final double balance;
  final double usdValue;

  const WalletBalance({
    required this.token,
    required this.tokenSymbol,
    required this.balance,
    required this.usdValue,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    return WalletBalance(
      token: json['token'],
      tokenSymbol: json['tokenSymbol'],
      balance: json['balance'].toDouble(),
      usdValue: json['usdValue'].toDouble(),
    );
  }

  @override
  List<Object?> get props => [token, tokenSymbol, balance, usdValue];
}
