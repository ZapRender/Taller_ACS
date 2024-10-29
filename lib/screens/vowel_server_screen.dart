
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VowelServerScreen extends StatefulWidget {
  const VowelServerScreen({Key? key}) : super(key: key);

  @override
  _VowelServerScreenState createState() => _VowelServerScreenState();
}

class _VowelServerScreenState extends State<VowelServerScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  bool _resultStatus = false;

  Future<void> _getVowelCount(String input) async {
    try{

      final response = await http.post(
      Uri.parse('http://localhost:8080'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'input': input}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _result = 'Número de vocales: ${data['vowelCount']}';
        _resultStatus = false;
      });
    } else {
      setState(() {
        _result = 'Error al conectar con el servidor';
        _resultStatus = true;
      });
    }


    } catch (e) {
      setState(() {
        _result = 'Error: No se pudo conectar con el servidor';
        _resultStatus = true;
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Ingrese una cadena',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _getVowelCount(_controller.text),
              child: const Text('Contar Vocales'),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: _resultStatus ? const TextStyle(color: Colors.red) : null,
            ),
          ],
        ),
      ),
    );
  }
}