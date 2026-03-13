class AppConfig {
  // Backend API - Updated for physical device
  static const String apiBaseUrl = 'http://192.168.0.108:3000/api';
  
  // Blockchain
  static const String contractAddress = '0xaf15ff299F4795224E23D1b6Fd36805Fc32f114e';
  static const String rpcUrl = 'https://rpc-amoy.polygon.technology';
  static const String networkName = 'Polygon Amoy Testnet';
  static const int chainId = 80002;
  
  // Token Addresses (Polygon Amoy)
  static const String usdcAddress = '0x41E94Eb019C0762f9Bfcf9Fb1E58725BfB0e7582';
  static const String usdtAddress = '0x...'; // Add if needed
  
  // Features
  static const bool enableSmsMonitoring = true;
  static const bool enableAutoPayment = true;
  static const double minConfidenceThreshold = 0.9;
  
  // For production, use environment variables or build flavors
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  
  static String get effectiveApiUrl {
    if (isProduction) {
      return 'https://your-production-api.com/api';
    }
    return apiBaseUrl;
  }
}
