const laboratoriosUtez = ['Lab Química', 'Lab Redes', 'Lab Física'];

class Consumo {
  const Consumo({required this.laboratorio, required this.litros});
  final String laboratorio;
  final double litros;
}

String? validarLitros(double? litros) {
  const litrosMaximos = 10000;

  if (litros == null) {
    return "Los litros no pueden ser nulos";
  } else if (litros <= 0) {
    return "Los litros no pueden ser igual o menor a 0";
  } else if (litros > litrosMaximos) {
    return "Los litros no pueden ser mayor a ${litrosMaximos}";
  }

  return null;
}
