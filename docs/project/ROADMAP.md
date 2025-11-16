# 🗺️ Roadmap - Recordari App

**Objetivo:** App de flashcards offline funcional para entregar mañana
**Tiempo estimado:** 5-6 horas
**Stack:** Flutter + Hive + Riverpod

---

## 📋 Fase 1: Setup & Configuración (30 min)

### 1.1 Dependencias
- [ ] Agregar dependencias en `pubspec.yaml`
  - `hive: ^2.2.3`
  - `hive_flutter: ^1.1.0`
  - `flutter_riverpod: ^2.4.0`
  - `path_provider: ^2.1.1`
  - `uuid: ^4.0.0`
- [ ] Ejecutar `flutter pub get`
- [ ] Generar TypeAdapters con `build_runner` (si es necesario)

### 1.2 Estructura de Carpetas
- [ ] Crear estructura en `lib/`:
  ```
  lib/
  ├── models/
  ├── providers/
  ├── services/
  ├── screens/
  ├── widgets/
  └── utils/
  ```

---

## 📦 Fase 2: Modelos & Base de Datos (45 min)

### 2.1 Modelos
- [ ] Crear `models/card_set.dart`
  - id, nombre, color, createdAt
  - TypeAdapter para Hive
- [ ] Crear `models/flashcard.dart`
  - id, setId, pregunta, respuesta, aprendida, createdAt
  - TypeAdapter para Hive

### 2.2 Servicio de Base de Datos
- [ ] Crear `services/database_service.dart`
  - Inicializar Hive
  - Registrar adapters
  - Abrir boxes (sets, cards)
- [ ] Inicializar en `main.dart` antes de `runApp()`

---

## 🔧 Fase 3: Providers & Lógica de Negocio (1h)

### 3.1 Providers de Conjuntos
- [ ] Crear `providers/card_set_provider.dart`
  - Listar todos los conjuntos
  - Crear conjunto
  - Eliminar conjunto
  - Obtener conjunto por ID

### 3.2 Providers de Tarjetas
- [ ] Crear `providers/flashcard_provider.dart`
  - Listar tarjetas por setId
  - Crear tarjeta
  - Editar tarjeta
  - Eliminar tarjeta
  - Marcar como aprendida
  - Obtener tarjetas no aprendidas

### 3.3 Provider de Estadísticas
- [ ] Crear `providers/stats_provider.dart`
  - Calcular progreso por conjunto
  - Calcular progreso global
  - Contar tarjetas totales/aprendidas

---

## 🎨 Fase 4: UI - Pantallas Principales (2.5h)

### 4.1 HomeScreen - Lista de Conjuntos (45 min)
- [ ] Crear `screens/home_screen.dart`
- [ ] AppBar con título "Recordari" + botón Stats
- [ ] ListView de conjuntos con:
  - CircleAvatar con color y letra inicial
  - Nombre del conjunto
  - Contador de tarjetas
  - Progreso (X/Y aprendidas)
- [ ] FAB (+) para crear conjunto
- [ ] Dialog para crear conjunto (nombre)
- [ ] Navegación a CardSetScreen al tap
- [ ] Estado vacío cuando no hay conjuntos

### 4.2 CardSetScreen - Lista de Tarjetas (45 min)
- [ ] Crear `screens/card_set_screen.dart`
- [ ] AppBar con nombre del conjunto + botón "Estudiar"
- [ ] ListView de tarjetas con:
  - Pregunta (título)
  - Preview de respuesta (subtitle, 1 línea)
  - Botón eliminar
- [ ] FAB (+) para crear tarjeta
- [ ] Dialog para crear/editar tarjeta (pregunta + respuesta)
- [ ] Confirmación antes de eliminar
- [ ] Estado vacío cuando no hay tarjetas
- [ ] Navegación a StudyScreen al tap "Estudiar"

### 4.3 StudyScreen - Modo Estudio (1h)
- [ ] Crear `screens/study_screen.dart`
- [ ] AppBar con "Estudiando" + contador (X/Total)
- [ ] Card grande con flip animation:
  - Frente: Pregunta
  - Reverso: Respuesta
- [ ] Tap en card para voltear
- [ ] Botones (solo visibles después de voltear):
  - "❌ No sé" → vuelve al final de la cola
  - "✅ Lo sé" → marca como aprendida
- [ ] Toggle "🔀 Aleatorio / 📋 Ordenado"
- [ ] Lógica de cola de tarjetas:
  - Cargar solo no aprendidas
  - Shuffle si modo aleatorio
  - Re-agregar al final si "No sé"
- [ ] Pantalla de completado cuando termina
- [ ] Botón volver a HomeScreen

### 4.4 StatsScreen - Estadísticas (30 min)
- [ ] Crear `screens/stats_screen.dart`
- [ ] AppBar con "Estadísticas"
- [ ] Progreso general con barra y porcentaje
- [ ] Lista de conjuntos con:
  - Nombre
  - Barra de progreso
  - Porcentaje (X/Y tarjetas)
- [ ] Totales globales:
  - Total de tarjetas
  - Total aprendidas
  - Porcentaje global

---

## 🎯 Fase 5: Widgets Reutilizables (30 min)

- [ ] Crear `widgets/card_flip_widget.dart`
  - AnimatedSwitcher para flip
  - Frente/reverso con estilo
- [ ] Crear `widgets/progress_bar.dart`
  - Barra de progreso con color
- [ ] Crear `widgets/empty_state.dart`
  - Widget para estados vacíos
- [ ] Crear `widgets/confirmation_dialog.dart`
  - Dialog de confirmación reutilizable

---

## 🐛 Fase 6: Testing & Fixes (30 min)

- [ ] Probar flujo completo:
  - Crear conjunto
  - Agregar tarjetas
  - Estudiar (ambos modos)
  - Ver estadísticas
  - Eliminar tarjetas/conjuntos
- [ ] Verificar persistencia (cerrar y abrir app)
- [ ] Validaciones:
  - No crear conjuntos sin nombre
  - No crear tarjetas vacías
  - No estudiar conjunto sin tarjetas
- [ ] Manejo de errores básico
- [ ] Testing en dispositivo físico/emulador

---

## ✨ Fase 7: Polish Final (30 min)

- [ ] Ajustar colores y espaciados
- [ ] Agregar loading states donde sea necesario
- [ ] Mejorar UX de confirmaciones
- [ ] Probar en diferentes tamaños de pantalla
- [ ] Verificar que cumple todos los requisitos funcionales
- [ ] Limpiar código y comentarios
- [ ] Preparar para demo

---

## 📊 Checklist de Requisitos Funcionales

### Requisitos Funcionales
- [ ] **RF1:** Crear, editar y eliminar tarjetas de memoria
- [ ] **RF2:** Organizar tarjetas en categorías o conjuntos
- [ ] **RF3:** Mostrar tarjetas aleatoriamente o en orden
- [ ] **RF4:** Registrar progreso básico del usuario
- [ ] **RF5:** Funcionar completamente sin conexión a internet

### Requisitos No Funcionales
- [ ] **RNF1:** App ligera (< 50 MB)
- [ ] **RNF2:** Funciona en Android y iOS
- [ ] **RNF3:** Interfaz fluida y responsiva
- [ ] **RNF4:** Datos guardados tras cerrar app
- [ ] **RNF5:** Tiempos de carga < 3 segundos

---

## 🚀 Orden de Ejecución Recomendado

1. ✅ **Setup completo** (Fase 1)
2. ✅ **Modelos + DB** (Fase 2)
3. ✅ **Providers** (Fase 3)
4. ✅ **HomeScreen** (4.1)
5. ✅ **CardSetScreen** (4.2)
6. ✅ **Widgets reutilizables** (Fase 5 - en paralelo)
7. ✅ **StudyScreen** (4.3)
8. ✅ **StatsScreen** (4.4)
9. ✅ **Testing** (Fase 6)
10. ✅ **Polish** (Fase 7)

---

## 📝 Notas Importantes

- **Prioridad:** Funcionalidad > Estética
- **Principio:** Si funciona, avanza. Pulimos al final.
- **Persistencia:** Todo se guarda automáticamente con Hive
- **Sin backend:** 100% local, sin APIs externas
- **Simplicidad:** Dialogs simples, ListTiles básicos

---

**Última actualización:** 16 Nov 2025
