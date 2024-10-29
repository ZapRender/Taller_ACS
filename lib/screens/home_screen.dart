import 'package:flutter/material.dart';
import 'package:taller_acs/screens/calculate_figure_screen.dart';
import 'package:taller_acs/screens/number_sum_screen.dart';
import 'package:taller_acs/screens/random_nums_screen.dart';
import 'package:taller_acs/screens/vowel_server_screen.dart';
import 'process_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentScreenText = "ACS";
  int _selectedIndex = 0;

  Widget _currentScreen = const Center(
    child: Text(
      'Seleccione una opción del menú',
      style: TextStyle(fontSize: 24),
    ),
  );

  void _navigateTo(Widget screen, String screenText) {
    setState(() {
      _currentScreen = screen;
      currentScreenText = screenText;
    });
  }

  void _onItemTapped(int index, Widget screen, String screenText) {
    setState(() {
      _selectedIndex = index;
    });
    _navigateTo(screen, screenText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentScreenText),
        backgroundColor: const Color(0xFF202020),
        shadowColor: Colors.transparent,
      ),
      body: Row(
        children: [
          Container(
            width: 250,
            color: const Color(0xFF202020),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  selected: _selectedIndex == 1,
                  leading: const Icon(Icons.list),
                  title: const Text('Procesos'),
                  onTap: () {
                    _onItemTapped(1, const ProcessScreen(), 'Procesos');
                  },
                  
                ),
                ListTile(
                  selected: _selectedIndex == 2,
                  leading: const Icon(Icons.calculate),
                  title: const Text('Calcular Área'),
                  onTap: () {
                    _onItemTapped(2, const CalculateFigureScreen(), 'Calcular Área');
                  },
                ),
                ListTile(
                  selected: _selectedIndex == 3,
                  leading: const Icon(Icons.gesture),
                  title: const Text('Hilos'),
                  onTap: () {
                    _onItemTapped(3, const RandomNums(), 'Hilos');
                  },
                ),
                ListTile(
                  selected: _selectedIndex == 4,
                  leading: const Icon(Icons.abc),
                  title: const Text('Servidor de Vocales'),
                  onTap: () {
                    _onItemTapped(4, const VowelServerScreen(), 'Servidor de Vocales');
                  },
                ),
                ListTile(
                  selected: _selectedIndex == 5,
                  leading: const Icon(Icons.add),
                  title: const Text('Servidor de Suma'),
                  onTap: () {
                    _onItemTapped(5, const NumberSumScreen(), 'Servidor de Suma');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentScreen,
          ),
        ],
      ),
    );
  }
}