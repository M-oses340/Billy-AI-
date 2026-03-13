import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/wallet/wallet_bloc.dart';
import '../blocs/wallet/wallet_event.dart';
import '../blocs/wallet/wallet_state.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billy Wallet'),
      ),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletTransactionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is WalletDisconnected) {
            return Center(
              child: ElevatedButton(
                onPressed: () => context.read<WalletBloc>().add(ConnectWallet()),
                child: const Text('Connect Wallet'),
              ),
            );
          }

          if (state is WalletConnecting || state is WalletTransactionProcessing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WalletConnected) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<WalletBloc>().add(LoadWalletBalance());
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Wallet Address', style: TextStyle(fontSize: 12)),
                          Text(state.address, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Balances', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...state.balances.map((balance) => Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(balance.tokenSymbol[0])),
                      title: Text(balance.tokenSymbol),
                      subtitle: Text('\$${balance.usdValue.toStringAsFixed(2)}'),
                      trailing: Text('${balance.balance.toStringAsFixed(4)}'),
                      onTap: () => _showDepositDialog(context, balance.token, balance.tokenSymbol),
                    ),
                  )),
                ],
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDepositDialog(context, '0x...', 'USDC'),
        icon: const Icon(Icons.add),
        label: const Text('Add Funds'),
      ),
    );
  }

  void _showDepositDialog(BuildContext context, String token, String symbol) {
    final amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Add $symbol to Billy Wallet'),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount',
            suffixText: symbol,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                context.read<WalletBloc>().add(
                  DepositToWallet(token: token, amount: amount),
                );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Deposit'),
          ),
        ],
      ),
    );
  }
}
