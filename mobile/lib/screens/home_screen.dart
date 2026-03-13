import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/bill/bill_bloc.dart';
import '../blocs/bill/bill_event.dart';
import '../blocs/bill/bill_state.dart';
import '../blocs/wallet/wallet_bloc.dart';
import '../blocs/wallet/wallet_state.dart';
import 'wallet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BillBloc>().add(LoadBills());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billy'),
        actions: [
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              if (state is WalletConnected) {
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WalletScreen()),
                  ),
                  child: Chip(
                    label: Text('${state.address.substring(0, 6)}...'),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<BillBloc, BillState>(
        builder: (context, state) {
          if (state is BillLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BillLoaded) {
            return ListView.builder(
              itemCount: state.bills.length,
              itemBuilder: (context, index) {
                final bill = state.bills[index];
                return ListTile(
                  title: Text(bill.payee),
                  subtitle: Text('Due: ${bill.dueDate}'),
                  trailing: Text('\$${bill.amount}'),
                );
              },
            );
          }
          return const Center(child: Text('No bills'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
