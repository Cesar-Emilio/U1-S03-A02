# Gestión de estado — EcoTrack Meta

**Equipo:** García Quiroz Gaspar Andrés · Contreras Cortés César Emilio
**Fecha:** 2026-10-27

## Tipos de estado en nuestro código

| Dato | Tipo (efímero, compartido, derivado, persistido) | Dónde vive |
|---|---|---|
| Pestaña activa | Efímero: solo le importa a la barra inferior y se cambia con `setState`. | `_pestana` en `_PantallasEcoTrackState` (`lib/presentacion/vistas.dart`). |
| Texto del campo de litros | Efímero: vive en el formulario y se limpia tras guardar. | `_litros` (`TextEditingController`) en `_FormularioRegistroState` (`lib/presentacion/vistas.dart`), liberado en `dispose()`. |
| consumos y meta | Compartido: lo leen Registro, Historial y Meta. | Campos `consumos` y `meta` de `ConsumosViewModel` (`lib/presentacion/consumos_view_model.dart`). |
| total y metaSuperada | Derivado: se calcula desde `consumos` y `meta`, nunca se guarda. | Getters `total`, `avance` y `metaSuperada` de `ConsumosViewModel`; lo comprueba la prueba "total, avance y metaSuperada se derivan…" (`test/etapa3_viewmodel_test.dart`). |
| Lo que regresa todos() | Persistido: es la fuente de verdad, el ViewModel solo guarda una copia. | `_consumos` de `MemoriaConsumoRepository` (`lib/datos/memoria_consumo_repository.dart`), expuesto con `List.unmodifiable`. |

## Criterios

| Criterio | A · ChangeNotifier puro | B · provider |
|---|---|---|
| Dato compartido | Un solo `_vm` creado en `_AppChangeNotifierState` llega a `RegistroCN`, `HistorialCN` y `MetaCN`; pasa "Dato compartido…" en `test/etapa4_change_notifier_test.dart`. | Un solo `ChangeNotifierProvider<ConsumosViewModel>` arriba de `MaterialApp` en `AppProvider`; pasa "Dato compartido…" en `test/etapa5_provider_test.dart`. |
| Capas | `a_change_notifier.dart` solo importa el contrato, el ViewModel y `vistas.dart`; pasa "Capas: el error del dominio aparece…" (etapa 4). | `b_provider.dart` importa lo mismo más `package:provider`; pasa "Capas…" en etapa 5 y `verificar_estado.sh` punto 6. |
| Encaje con el diagrama | Vista tonta → adaptador `ListenableBuilder` → `ConsumosViewModel` → `ConsumoRepository`: respeta las flechas legales. | Vista tonta → adaptador con `context.watch`/`context.read` → mismo `ConsumosViewModel` → `ConsumoRepository`: mismas flechas. |
| Constructores que reciben vm | 3: `RegistroCN`, `HistorialCN`, `MetaCN` (`required this.vm`); una subpantalla de Meta haría 4. | 0: `RegistroProvider`, `HistorialProvider` y `MetaProvider` son `const` sin parámetros; lo prueba "Los adaptadores piden el ViewModel al árbol…". |
| Quién libera el ViewModel | `_AppChangeNotifierState.dispose()` llama `_vm.dispose()`; ningún adaptador lo hace. | `ChangeNotifierProvider` lo libera al desmontarse; en `b_provider.dart` no hay `dispose()` escrito por nosotros. |
| Costo de adoptarla ahora | Cero dependencias, pero hay que pasar `vm` a mano en cada constructor (`a_change_notifier.dart`). | Una dependencia (`provider` en `pubspec.yaml`) y aprender `watch`/`read`; a cambio se borra el paso manual. |
| Sustitución de la fuente de datos | `AppChangeNotifier(repositorio: RepositorioEspia(...))` sin tocar pantallas; pasa "Sustitución…" (etapa 4). | `AppProvider(repositorio: RepositorioEspia(...))` sin tocar pantallas; pasa "Sustitución…" (etapa 5). Solo `main*.dart` importa `MemoriaConsumoRepository`. |

## Elección

Elegimos: B · provider, porque los adaptadores no reciben `vm` y el dueño (`ChangeNotifierProvider`) libera el ViewModel solo.
Se mantiene esta pieza del diagrama: `ConsumosViewModel` y las vistas de `vistas.dart`, que no cambiaron entre la etapa 4 y la 5 (`git diff` de esos archivos vacío).
Esta pieza es la que podría sustituirse después: `MemoriaConsumoRepository`, por otra implementación de `ConsumoRepository` elegida solo en `lib/main.dart`.
