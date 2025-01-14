```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchData() async {
  try {
    final response = await http.get(Uri.parse('https://api.example.com/data'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw HttpException('HTTP request failed', response.statusCode, response.reasonPhrase);
    }
  } on SocketException catch (e) {
    throw NetworkException('No internet connection', e);
  } on FormatException catch (e) {
    throw DataFormatException('Invalid JSON response', e);
  } on Exception catch (e) {
    throw UnexpectedException('An unexpected error occurred', e);
  }
}

class HttpException implements Exception {
  final String message;
  final int statusCode;
  final String? reasonPhrase;

  HttpException(this.message, this.statusCode, this.reasonPhrase);

  @override
  String toString() => 'HttpException: $message (status code: $statusCode${reasonPhrase != null ? ', reason: $reasonPhrase' : ''})';
}

class NetworkException implements Exception {
  final String message;
  final Exception originalException;

  NetworkException(this.message, this.originalException);

  @override
  String toString() => 'NetworkException: $message. Original Exception: $originalException';
}

class DataFormatException implements Exception {
  final String message;
  final Exception originalException;

  DataFormatException(this.message, this.originalException);

  @override
  String toString() => 'DataFormatException: $message. Original Exception: $originalException';
}

class UnexpectedException implements Exception{
  final String message;
  final Exception originalException;
  UnexpectedException(this.message, this.originalException);
  @override
  String toString() => 'UnexpectedException: $message. Original Exception: $originalException';
}
```