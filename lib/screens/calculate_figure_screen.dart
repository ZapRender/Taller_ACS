import 'package:flutter/material.dart';
import 'package:taller_acs/services/calculate_area_service.dart';

class CalculateFigureScreen extends StatefulWidget {
  const CalculateFigureScreen({super.key});

  @override
  State<CalculateFigureScreen> createState() => _CalculateFigureScreenState();
}

class _CalculateFigureScreenState extends State<CalculateFigureScreen> {
  double _figureTotalArea = 0.0;
  final CalculateArea _calculateArea = CalculateArea();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
          Image.asset('lib/src/calcule_figure.png'),
          const Text('Presione el botón para calcular el area de la figura descrita en la imagen.'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              double area = await _calculateArea.calcularAreaTotal();
              setState(() { _figureTotalArea = area; });
            },
            child: 
              const Text('Calcular área total'),
          ),
            const SizedBox(height: 20),
            if (_figureTotalArea > 0.0)
              Text('El área total de la figura es: $_figureTotalArea'),
          
        ]),
      ),
    );
  }
}