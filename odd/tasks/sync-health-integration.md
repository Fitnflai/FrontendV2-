# Feature: Sync Health Integration

## Objective
Activate health synchronization endpoint `/health-service-integration/sync-health` when the user connects to a health app, requesting read/write permissions, saving the data to the backend, and displaying it on Home in real-time.

## Enfoque de Permisos Extendidos (Android/iOS)
Para coincidir con las capacidades configuradas en el AndroidManifest y arrays de la aplicación, ahora se solicitan y procesan de forma nativa los siguientes 6 tipos de datos en lectura y escritura:
1. **Pasos** (`HealthDataType.STEPS`)
2. **Calorías** (`HealthDataType.ACTIVE_ENERGY_BURNED`)
3. **Distancia** (`HealthDataType.DISTANCE_DELTA`)
4. **Ritmo Cardíaco** (`HealthDataType.HEART_RATE`) -> Calcula promedio, mínimo y reposo
5. **Sesiones de Sueño** (`HealthDataType.SLEEP_SESSION`) -> Calcula duración en horas
6. **Peso Corporal** (`HealthDataType.WEIGHT`)

## Mejoras de Resiliencia y UI
- **Mock Fallback en Debug**: Si se corre en un emulador o dispositivo sin registros reales, la app inyecta automáticamente valores mock graciosos en modo debug para facilitar la prueba de la sincronización de extremo a extremo.
- **Sincronización Offline-first**: Si la API del servidor falla (ej. problemas de red), la app todavía actualiza las estadísticas locales para que el usuario pueda ver sus datos en el Home de forma inmediata.
- **Consulta Tipo por Tipo Resiliente (Solución Definitiva)**: Para evitar que un error o falta de permiso en un solo tipo de dato (como Peso o Sueño) haga fallar toda la consulta y deje los indicadores en cero, ahora el motor nativo realiza una iteración segura consultando cada tipo de dato de forma independiente. Si un tipo de dato falla, se registra en consola y continúa consultando los demás de forma exitosa.
- **Reemplazo de Calorías por Ritmo Cardíaco**: Se reemplazó la tarjeta de "Calorías hoy" por "Ritmo cardíaco" (bpm) en la pantalla de inicio para mostrar las pulsaciones promedio en tiempo real.

## Tasks
- [x] Task 1: Update Android Health Connect Service (`android_health_connect_service.dart`) to request read/write permissions. <!-- id: task_1 -->
- [x] Task 2: Update Apple HealthKit Service (`apple_health_kit_service.dart`) to request read/write permissions. <!-- id: task_2 -->
- [x] Task 3: Update Health Repository (`health_repository.dart`) to include all fields required by the `/sync-health` endpoint schema to prevent 422 errors. <!-- id: task_3 -->
- [x] Task 4: Add `WidgetsBindingObserver` to `HomeScreen` (`home_screen.dart`) to fetch and sync health data in real-time when the app is resumed. <!-- id: task_4 -->
- [x] Task 5: Ensure `HomeScreen` displays the stats row when any health provider is connected, syncing SharedPreferences and provider state. <!-- id: task_5 -->

## Status
- Active: No
- Total tasks: 5
- Completed: 5
