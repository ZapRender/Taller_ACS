import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

int sum = 0;

// Handler to process requests
Future<Response> handleRequest(Request request) async {
  if (request.method == 'POST') {
    final payload = await request.readAsString();
    final data = jsonDecode(payload) as Map<String, dynamic>;
    final number = data['number'] as int;

    if (number == 0) {
      final result = sum;
      sum = 0; // Reset the sum
      return Response.ok(jsonEncode({'sum': result}),
          headers: {'Content-Type': 'application/json'});
    } else {
      sum += number;
      return Response.ok(jsonEncode({'message': 'Numero agregado a la suma'}),
          headers: {'Content-Type': 'application/json'});
    }
  } else {
    return Response.notFound('Not Found');
  }
}

void main() async {
  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(handleRequest);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Server listening on http://${server.address.host}:${server.port}');
}