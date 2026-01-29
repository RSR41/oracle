class ApiEndpoints {
  // TODO: Replace with real production URL when available
  static const String productionBaseUrl = 'https://api.ef.rsr41.com';

  // Android Emulator uses 10.0.2.2 to access host localhost
  static const String devAndroidBaseUrl = 'http://10.0.2.2:8080';

  // iOS Simulator uses localhost
  static const String devIosBaseUrl = 'http://localhost:8080';

  static String getBaseUrl({bool isDev = true, bool isAndroid = true}) {
    if (!isDev) return productionBaseUrl;
    return isAndroid ? devAndroidBaseUrl : devIosBaseUrl;
  }

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Profile
  static const String profile = '/me';

  // Fortune
  static const String fortuneSummary = '/fortune/summary';

  // Tags
  static const String tagClaim = '/tags/claim';
  static const String tagTransferCreate = '/tags/transfer/create';
  static const String tagTransferAccept = '/tags/transfer/accept';
}
