import 'dart:isolate';

class CalculateArea {

double calcularAreaRectangulo(Map<String, double> data) {
  double ancho = data['ancho']!;
  double alto = data['alto']!;
  return ancho * alto;
}

double calcularAreaTriangulo(Map<String, double> data) {
  double base = data['base']!;
  double altura = data['altura']!;
  return (base * altura) / 2;
}

// Función auxiliar para ejecutar código en un Isolate
Future<double> runInIsolate(Function function, Map<String, double> data) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_isolateEntry, [function, receivePort.sendPort, data]);
  return await receivePort.first as double;
}

void _isolateEntry(List<dynamic> args) {
  final Function function = args[0];
  final SendPort sendPort = args[1];
  final Map<String, double> data = args[2];

  final result = function(data);
  sendPort.send(result);
}

Future<double> calcularAreaTotal() async {
  // Dimensiones
  Map<String, double> rectanguloData1 = {'ancho': 12, 'alto': 8};
  Map<String, double> rectanguloData2 = {'ancho': 6, 'alto': 5};
  Map<String, double> trianguloData1 = {'base': 10, 'altura': 12};  
  Map<String, double> trianguloData2 = {'base': 5, 'altura': 2};

  // Ejecutar los cálculos en Isolates
  //Future<double> areaTrapecio = runInIsolate(calcularAreaTrapecio, trapecioData);
  Future<double> areaRectangulo1 = runInIsolate(calcularAreaRectangulo, rectanguloData1);
  Future<double> areaTriangulo1 = runInIsolate(calcularAreaTriangulo, trianguloData1);
  Future<double> areaRectangulo2 = runInIsolate(calcularAreaRectangulo, rectanguloData2);
  Future<double> areaTriangulo2 = runInIsolate(calcularAreaTriangulo, trianguloData2);
  // Esperar a que terminen todos los cálculos
  List<double> areas = await Future.wait([areaRectangulo1, areaTriangulo1, areaRectangulo2, areaTriangulo2]);

  // Sumar todas las áreas
  double areaTotal = areas.reduce((a, b) => a + b);

  return areaTotal;
}
}