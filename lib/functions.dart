import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:shelf/shelf.dart';

@CloudFunction()
Future<Response> function(Request request) async {
  // Get the JWT token from the request headers
  final headers = request.headers;
  final token = headers['authorization'];

  if (token == null || !token.startsWith('Bearer ')) {
    return Response(401, body: 'Invalid token');
  }

  // Remove the 'Bearer ' prefix from the token
  final tokenWithoutPrefix = token.replaceFirst('Bearer ', '');
  final secretKey = '12345';
  try {
    final decodedToken = JWT.verify(tokenWithoutPrefix, SecretKey(secretKey));

    // Perform additional tasks when the token is valid
    final userId = decodedToken.payload.toString();
    final username = decodedToken.payload['role'];

    // Your custom logic here...
    // Perform tasks based on the token data

    return Response.ok('Token is valid for user $username ($userId)');
  } on JWTException catch (e) {
    return Response(401, body: 'Invalid token: ${e.message}');
  }
}
