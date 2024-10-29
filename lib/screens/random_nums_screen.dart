import 'package:flutter/material.dart';
import 'package:taller_acs/services/random_nums_service.dart';

class RandomNums extends StatefulWidget {
  const RandomNums({super.key});

  @override
  State<RandomNums> createState() => _RandomNumsState();
}

class _RandomNumsState extends State<RandomNums> {

List<int> _results = [];
  int _winningThread = -1;
  int _maxResult = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                List<int> results = await runIsolates();
                int maxResult = results.reduce((a, b) => a > b ? a : b);
                int winningThread = results.indexOf(maxResult);
                setState(() {
                  _results = results;
                  _maxResult = maxResult;
                  _winningThread = winningThread;
                });
              },
      
              child: const Text('Generar numeros'),
            ),
            const SizedBox(height: 20),
            if (_results.isNotEmpty)
              Column(
                children: [
                  for (int i = 0; i < _results.length; i++)
                    Text('Hilo $i: ${_results[i]}'),
                  const SizedBox(height: 20),
                  Text('El hilo ganador es el hilo $_winningThread con un total de $_maxResult'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
