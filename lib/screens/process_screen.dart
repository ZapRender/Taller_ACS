import 'package:flutter/material.dart';
import 'package:taller_acs/services/process_service.dart';

class ProcessScreen extends StatefulWidget {
  const ProcessScreen({super.key});

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  List<Map<String, String>> _processes = [];
  final ProcessService _processService = ProcessService();
  final TextEditingController _searchController = TextEditingController();
  int? _hoveredIndex;
  @override
  void initState() {
    super.initState();
    _loadProcesses();
    _searchController.addListener(_filterProcesses);
  }

  Future<void> _loadProcesses() async {
    final processList = await _processService.getProcesses();
    setState(() {
      _processes = processList;
    });
  }

  Future<void> _killProcess(String pid) async {
    await _processService.killProcess(pid);
    _loadProcesses();
  }

  void _filterProcesses() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _processes = _processes.where((process) {
        return process['name']!.toLowerCase().contains(query) ||
            process['pid']!.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Buscar',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                      onPressed: () => _loadProcesses(),
                      backgroundColor: const Color(0xFF191919),
                      elevation: 0,
                      mini: true,
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      15), // Esquina superior izquierda redondeada
                  bottomLeft: Radius.circular(
                      15), // Esquina inferior izquierda redondeada
                ),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 5,
                    blurRadius: 0,
                    color: Color(0xFF191919),
                  ),
                ],
              ),
              margin:
                  const EdgeInsets.all(10), // Margen alrededor del Container
              padding: const EdgeInsets.all(10), // Padding dentro del Container
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  const TableRow(
                    children: [
                      Text('Nombre',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('PID',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(),
                    ],
                  ),
                  const TableRow(
                    children: [
                      SizedBox(height: 15),
                      SizedBox(height: 15),
                      SizedBox(height: 15),
                    ],
                  ),
                  ..._processes.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, String> process = entry.value;
                    return TableRow(
                      children: [
                        MouseRegion(
                          onEnter: (_) => setState(() => _hoveredIndex = index),
                          onExit: (_) => setState(() => _hoveredIndex = null),
                          child: Container(
                            color: _hoveredIndex == index
                                ? const Color(0xFF272727)
                                : Colors.transparent,
                            child: Text(process['name']!),
                          ),
                        ),
                        MouseRegion(
                          onEnter: (_) => setState(() => _hoveredIndex = index),
                          onExit: (_) => setState(() => _hoveredIndex = null),
                          child: Container(
                            color: _hoveredIndex == index
                                ? const Color(0xFF272727)
                                : Colors.transparent,
                            child: Text(process['pid']!),
                          ),
                        ),
                        MouseRegion(
                          onEnter: (_) => setState(() => _hoveredIndex = index),
                          onExit: (_) => setState(() => _hoveredIndex = null),
                          child: Container(
                            color: _hoveredIndex == index
                                ? const Color(0xFF272727)
                                : Colors.transparent,
                            child: Align(
                              alignment: Alignment.center,
                              child: OutlinedButton(
                                onPressed: () {
                                  _killProcess(process['pid']!);
                                },
                                child: const Text("Finish Task"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
