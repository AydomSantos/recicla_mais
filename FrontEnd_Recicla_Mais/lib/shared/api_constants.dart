class ApiConstants {
  // Use 127.0.0.1 for Web and localhost development
  // Use 10.0.2.2 for Android Emulator
  // Use your LAN IP (e.g., 192.168.x.x) for physical devices
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String collectionsEndpoint = '$baseUrl/collections';
}
