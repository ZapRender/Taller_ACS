import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

// Function to count vowels in a string
int countVowels(String input) {
  final vowels = RegExp(r'[aeiouAEIOU]');
  return vowels.allMatches(input).length;
}

// Handler to process requests
Future<Response> handleRequest(Request request) async {
  if (request.method == 'POST') {
    final payload = await request.readAsString();
    final data = jsonDecode(payload) as Map<String, dynamic>;
    final inputString = data['input'] as String;
    final vowelCount = countVowels(inputString);
    return Response.ok(jsonEncode({'vowelCount': vowelCount}),
        headers: {'Content-Type': 'application/json'});
  } else {
    return Response.notFound('Not Found');
  }
}

void main() async {
  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(handleRequest);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Server listening on http://${server.address.host}:${server.port}');
}