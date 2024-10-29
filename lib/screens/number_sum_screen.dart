import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NumberSumScreen extends StatefulWidget {
  const NumberSumScreen({Key? key}) : super(key: key);

  @override
  _NumberSumScreenState createState() => _NumberSumScreenState();
}

class _NumberSumScreenState extends State<NumberSumScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  bool _resultStatus = false;

  Future<void> _sendNumber(int number) async {
    try {
      final response = await http.post(
      Uri.parse('http://localhost:8080'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'number': number}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        if (number == 0) {
          _result = 'Suma total: ${data['sum']}';
        } else {
          _result = data['message'];
        }
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingrese un número',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final number = int.tryParse(_controller.text);
                if (number != null) {
                  _sendNumber(number);
                }
              },
              child: const Text('Enviar Número'),
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