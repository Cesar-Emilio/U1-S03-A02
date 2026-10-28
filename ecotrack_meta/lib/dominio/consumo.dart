const laboratoriosUtez = ['Lab Química', 'Lab Redes', 'Lab Física'];

const litrosMaximos = 10000;

class Consumo {
  const Consumo({required this.laboratorio, required this.litros});
  final String laboratorio;
  final double litros;
}

String? validarLitros(double? litros) {
  if (litros == null) {
    return 'Escribe los litros con número';
  } else if (litros <= 0) {
    return 'Los litros deben ser mayores que cero';
  } else if (litros > litrosMaximos) {
    return 'Los litros superan el tope de $litrosMaximos';
  }

  return null;
}
