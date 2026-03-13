import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/bill/bill_bloc.dart';
import '../blocs/bill/bill_state.dart';
import '../models/bill.dart';

class StandingOrdersScreen extends StatelessWidget {
  const StandingOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Standing Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddStandingOrderDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<BillBloc, BillState>(
        builder: (context, state) {
          if (state is BillLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is BillLoaded) {
            final recurringBills = state.bills.where((b) => b.isRecurring).toList();
            
            if (recurringBills.isEmpty) {
              return _buildEmptyState(isDark);
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recurringBills.length,
              itemBuilder: (context, index) {
                return _buildStandingOrderCard(
                  context,
                  recurringBills[index],
                  isDark,
                );
              },
            );
          }
          
          return _buildEmptyState(isDark);
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.repeat_rounded,
            size: 80,
            color: isDark ? Colors.white24 : Colors.black12,
          ),
          const SizedBox(height: 16),
          Text(
            'No Standing Orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set up recurring bills for automatic payments',
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandingOrderCard(BuildContext context, Bill bill, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getIconForBillType(bill.billType),
            color: const Color(0xFF6366F1),
          ),
        ),
        title: Text(
          bill.payee,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${bill.currency} ${bill.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.repeat_rounded,
                  size: 14,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
                const SizedBox(width: 4),
                Text(
                  _getFrequencyText(bill.recurringFrequency),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Switch(
          value: true,
          onChanged: (value) {
            // TODO: Toggle standing order
          },
        ),
      ),
    );
  }

  IconData _getIconForBillType(String? type) {
    switch (type?.toLowerCase()) {
      case 'electricity':
        return Icons.bolt_rounded;
      case 'water':
        return Icons.water_drop_rounded;
      case 'internet':
      case 'wifi':
        return Icons.wifi_rounded;
      case 'phone':
        return Icons.phone_rounded;
      case 'rent':
        return Icons.home_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }

  String _getFrequencyText(String? frequency) {
    switch (frequency) {
      case 'weekly':
        return 'Every week';
      case 'monthly':
        return 'Every month';
      case 'quarterly':
        return 'Every 3 months';
      case 'yearly':
        return 'Every year';
      default:
        return 'Recurring';
    }
  }

  void _showAddStandingOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Standing Order'),
        content: const Text('Standing order creation coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
