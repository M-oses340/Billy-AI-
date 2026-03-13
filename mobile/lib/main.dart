import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'blocs/bill/bill_bloc.dart';
import 'blocs/payment/payment_bloc.dart';
import 'blocs/wallet/wallet_bloc.dart';
import 'repositories/bill_repository.dart';
import 'repositories/payment_repository.dart';
import 'repositories/wallet_repository.dart';
import 'services/api_service.dart';
import 'services/web3_service.dart';
import 'screens/home_screen.dart';
import 'screens/wallet_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  runApp(const BillyApp());
}

class BillyApp extends StatelessWidget {
  const BillyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final web3Service = Web3Service();
    
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => BillRepository(apiService)),
        RepositoryProvider(create: (_) => PaymentRepository(apiService, web3Service)),
        RepositoryProvider(create: (_) => WalletRepository(web3Service)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BillBloc(context.read<BillRepository>())),
          BlocProvider(create: (context) => PaymentBloc(context.read<PaymentRepository>())),
          BlocProvider(create: (context) => WalletBloc(context.read<WalletRepository>())),
        ],
        child: MaterialApp(
          title: 'Billy',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
          routes: {
            '/wallet': (context) => const WalletScreen(),
          },
        ),
      ),
    );
  }
}
