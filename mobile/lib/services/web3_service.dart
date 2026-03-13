import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/wallet.dart';
import '../config/app_config.dart';

class Web3Service {
  late Web3Client _client;
  String? _connectedAddress;
  Web3App? _wcClient;
  SessionData? _session;

  // Billy contract ABI
  static const billyContractABI = [
    {
      "inputs": [
        {"internalType": "address", "name": "_user", "type": "address"},
        {"internalType": "address", "name": "_token", "type": "address"}
      ],
      "name": "getWalletBalance",
      "outputs": [
        {"internalType": "uint256", "name": "", "type": "uint256"}
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "address", "name": "_token", "type": "address"},
        {"internalType": "uint256", "name": "_amount", "type": "uint256"},
        {"internalType": "bool", "name": "convertToStable", "type": "bool"}
      ],
      "name": "deposit",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "address", "name": "_token", "type": "address"},
        {"internalType": "uint256", "name": "_amount", "type": "uint256"}
      ],
      "name": "withdraw",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ];

  // ERC20 ABI for approve
  static const erc20ABI = [
    {
      "inputs": [
        {"internalType": "address", "name": "spender", "type": "address"},
        {"internalType": "uint256", "name": "amount", "type": "uint256"}
      ],
      "name": "approve",
      "outputs": [
        {"internalType": "bool", "name": "", "type": "bool"}
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "address", "name": "account", "type": "address"}
      ],
      "name": "balanceOf",
      "outputs": [
        {"internalType": "uint256", "name": "", "type": "uint256"}
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ];

  Web3Service() {
    _client = Web3Client(AppConfig.rpcUrl, http.Client());
  }

  Future<void> initWalletConnect() async {
    _wcClient = await Web3App.createInstance(
      projectId: 'a2faf857e29f339a0b217b9ff35a88c4',
      metadata: const PairingMetadata(
        name: 'Billy',
        description: 'AI-powered crypto bill payment',
        url: 'https://billy.app',
        icons: ['https://billy.app/icon.png'],
      ),
    );
  }

  Future<String> connectWallet() async {
    if (_wcClient == null) {
      await initWalletConnect();
    }

    try {
      final ConnectResponse response = await _wcClient!.connect(
        requiredNamespaces: {
          'eip155': RequiredNamespace(
            chains: ['eip155:${AppConfig.chainId}'],
            methods: ['eth_sendTransaction', 'personal_sign'],
            events: ['chainChanged', 'accountsChanged'],
          ),
        },
      );

      final Uri? uri = response.uri;
      if (uri != null) {
        // Open wallet app
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }

      // Wait for session approval
      _session = await response.session.future;
      _connectedAddress = _session!.namespaces['eip155']!.accounts.first.split(':').last;
      
      print('✅ Wallet connected: $_connectedAddress');
      return _connectedAddress!;
    } catch (e) {
      print('❌ Wallet connection failed: $e');
      rethrow;
    }
  }

  Future<void> disconnectWallet() async {
    if (_session != null && _wcClient != null) {
      await _wcClient!.disconnectSession(
        topic: _session!.topic,
        reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
      );
      _session = null;
      _connectedAddress = null;
    }
  }

  String? get connectedAddress => _connectedAddress;
  bool get isConnected => _connectedAddress != null;

  Future<List<WalletBalance>> getWalletBalances(String address) async {
    try {
      final contract = DeployedContract(
        ContractAbi.fromJson(
          billyContractABI.toString(),
          'BillyPayment',
        ),
        EthereumAddress.fromHex(AppConfig.contractAddress),
      );

      final getBalanceFunction = contract.function('getWalletBalance');
      
      // Get USDC balance in Billy wallet
      final usdcBalance = await _client.call(
        contract: contract,
        function: getBalanceFunction,
        params: [
          EthereumAddress.fromHex(address),
          EthereumAddress.fromHex(AppConfig.usdcAddress),
        ],
      );

      final balance = (usdcBalance.first as BigInt).toDouble() / 1e6; // USDC has 6 decimals

      return [
        WalletBalance(
          token: AppConfig.usdcAddress,
          tokenSymbol: 'USDC',
          balance: balance,
          usdValue: balance, // 1 USDC = 1 USD
        ),
      ];
    } catch (e) {
      print('❌ Error getting balances: $e');
      return [
        const WalletBalance(
          token: AppConfig.usdcAddress,
          tokenSymbol: 'USDC',
          balance: 0.0,
          usdValue: 0.0,
        ),
      ];
    }
  }

  Future<String> depositToWallet(String token, double amount) async {
    if (!isConnected) throw Exception('Wallet not connected');

    try {
      // Step 1: Approve token spending
      print('📝 Approving USDC...');
      final approveHash = await _approveToken(token, amount);
      print('✅ Approved: $approveHash');

      // Wait for approval confirmation
      await Future.delayed(const Duration(seconds: 3));

      // Step 2: Deposit to Billy contract
      print('💰 Depositing to Billy wallet...');
      final depositHash = await _deposit(token, amount);
      print('✅ Deposited: $depositHash');

      return depositHash;
    } catch (e) {
      print('❌ Deposit failed: $e');
      rethrow;
    }
  }

  Future<String> _approveToken(String token, double amount) async {
    final erc20Contract = DeployedContract(
      ContractAbi.fromJson(erc20ABI.toString(), 'ERC20'),
      EthereumAddress.fromHex(token),
    );

    final approveFunction = erc20Contract.function('approve');
    final amountWei = BigInt.from(amount * 1e6); // USDC has 6 decimals

    final transaction = Transaction.callContract(
      contract: erc20Contract,
      function: approveFunction,
      parameters: [
        EthereumAddress.fromHex(AppConfig.contractAddress),
        amountWei,
      ],
    );

    return await _sendTransaction(transaction);
  }

  Future<String> _deposit(String token, double amount) async {
    final billyContract = DeployedContract(
      ContractAbi.fromJson(billyContractABI.toString(), 'BillyPayment'),
      EthereumAddress.fromHex(AppConfig.contractAddress),
    );

    final depositFunction = billyContract.function('deposit');
    final amountWei = BigInt.from(amount * 1e6);

    final transaction = Transaction.callContract(
      contract: billyContract,
      function: depositFunction,
      parameters: [
        EthereumAddress.fromHex(token),
        amountWei,
        false, // Don't auto-convert
      ],
    );

    return await _sendTransaction(transaction);
  }

  Future<String> withdrawFromWallet(String token, double amount) async {
    if (!isConnected) throw Exception('Wallet not connected');

    try {
      final billyContract = DeployedContract(
        ContractAbi.fromJson(billyContractABI.toString(), 'BillyPayment'),
        EthereumAddress.fromHex(AppConfig.contractAddress),
      );

      final withdrawFunction = billyContract.function('withdraw');
      final amountWei = BigInt.from(amount * 1e6);

      final transaction = Transaction.callContract(
        contract: billyContract,
        function: withdrawFunction,
        parameters: [
          EthereumAddress.fromHex(token),
          amountWei,
        ],
      );

      final txHash = await _sendTransaction(transaction);
      print('✅ Withdrawn: $txHash');
      return txHash;
    } catch (e) {
      print('❌ Withdrawal failed: $e');
      rethrow;
    }
  }

  Future<String> _sendTransaction(Transaction transaction) async {
    if (_wcClient == null || _session == null) {
      throw Exception('Wallet not connected');
    }

    final result = await _wcClient!.request(
      topic: _session!.topic,
      chainId: 'eip155:${AppConfig.chainId}',
      request: SessionRequestParams(
        method: 'eth_sendTransaction',
        params: [
          {
            'from': _connectedAddress,
            'to': transaction.to?.hex,
            'data': transaction.data?.toString(),
            'value': transaction.value?.getInWei.toRadixString(16),
          }
        ],
      ),
    );

    return result.toString();
  }

  Future<double> getTokenBalance(String address, String token) async {
    try {
      final erc20Contract = DeployedContract(
        ContractAbi.fromJson(erc20ABI.toString(), 'ERC20'),
        EthereumAddress.fromHex(token),
      );

      final balanceFunction = erc20Contract.function('balanceOf');
      
      final balance = await _client.call(
        contract: erc20Contract,
        function: balanceFunction,
        params: [EthereumAddress.fromHex(address)],
      );

      return (balance.first as BigInt).toDouble() / 1e6;
    } catch (e) {
      print('❌ Error getting token balance: $e');
      return 0.0;
    }
  }
}
