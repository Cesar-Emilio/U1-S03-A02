const metaInicial = 100.0;
const pasoMeta = 10.0;
const metaMinima = 10.0;

const valorActual = 0;

double ajustarMeta(double actual, double cambio) {
  const metaTemp = actual + cambio;
  if (metaTemp < metaMinima) {
    return 0;
  }


}

double avanceDeMeta({required double total, required double meta}) {

}