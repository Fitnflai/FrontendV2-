# Revisión del flujo de pago de membresía

## Objetivo
Identificar posibles conflictos, inconsistencias o áreas de mejora en el flujo de pago de membresías y gestión de tarjetas dentro de la aplicación.

## Problema
Se requiere una revisión exhaustiva del flujo de pago de membresías para asegurar su robustez, manejo de errores y consistencia de estado, especialmente considerando la interacción con la pasarela de pagos externa (Nuvei) y las diferentes funcionalidades (suscripción, cambio de plan, gestión de tarjetas, pagos de especialistas).

## Alcance Autorizado
*   Análisis del código relacionado con el pago de membresías, gestión de tarjetas y pagos de especialistas.
*   Identificación de posibles puntos de conflicto, fallos en el manejo de errores o inconsistencias en la actualización del estado.
*   Propuesta de mejoras o áreas a investigar más a fondo.

## Tareas
- [x] **Tarea 1: Análisis detallado de `PaymentsService`**
    - [x] Leer el contenido completo de `lib/services/payments_service.dart`.
    - [x] Documentar la lógica de `subscribeNuvei`, `changePlan`, `initPayment`, `initAddCard`, `saveCard`, `getSavedCards`, `deleteCard` y `refundNuvei`.
    - [x] Analizar el manejo de errores (`_handleError`) y el parseo de respuestas (`_parseResponse`).
    - [x] **Hallazgos Clave:**
        -   **`chargeWithSavedCard` es simulado**: Actualmente llama a `/simulate-purchase` y un comentario indica que es un "mock/real fallback". **Sin embargo, tras una investigación exhaustiva, se determinó que este método (`PaymentsService.chargeWithSavedCard` y su llamador `ProfileProvider.chargeWithSavedCard`) NO es invocado en ningún punto del código actual de la aplicación. Es código muerto.** Esto lo convierte en una **Advertencia / Limpieza de Código** en lugar de un conflicto crítico funcional.
        -   **Manejo genérico de errores**: `_handleError` lanza una `Exception` genérica, lo que dificulta la diferenciación de errores específicos en la UI.
        -   **Inconsistencia en `getStatus`**: Devuelve el cuerpo crudo de la respuesta (`String`) en lugar de usar `_parseResponse` que maneja JSON, a diferencia de otros métodos.
        -   **Redundancia en `deleteCard`**: `cardId` se pasa como parámetro de ruta y de consulta. Validado con Swagger, la API espera ambos (`id` en path y `id_tarjeta_usuario` en query), aunque con nombres inconsistentes. Esto es una **Advertencia menor de diseño de API/cliente**.
        -   **Parámetros en `changePlan`**: `priceId` se envía como query parameter y el cuerpo es un JSON vacío. Funcional, pero inconsistente. **Advertencia menor de diseño de API/cliente**.
- [x] **Tarea 2: Rastreo de interacción UI-Servicio (Membership & Payment Methods)**
    - [x] Revisar `lib/screens/membership/membership_screen.dart` para entender cómo se inician las suscripciones.
    - [x] Revisar `lib/screens/profile/payment_methods_screen.dart` para ver cómo se gestionan las tarjetas, se inician los deep links (`_associateCard`) y se manejan las respuestas (`_saveCardFromDeepLink`).
    - [x] Identificar cómo se actualiza el estado de la UI y los proveedores (`AuthProvider`, `ProfileProvider`) después de las interacciones con `PaymentsService` y cómo se comunican los errores.
    - [x] **Hallazgos Clave:**
        -   **Deep Link "huérfano" en `MembershipScreen` (CRÍTICO):** Cuando se lanza la URL para asociar una tarjeta (`profileProvider.associateCard`), el modal de la `MembershipScreen` se cierra de inmediato. Si el usuario no completa el flujo externo o hay un fallo, la `MembershipScreen` ya no está activa para mostrar feedback. Esto deja al usuario en un estado incierto.
        -   **Robustez y seguridad de los parámetros de Deep Link (CRÍTICO):** La `PaymentMethodsScreen` recibe detalles de la tarjeta directamente a través de los parámetros del deep link. Aunque Nuvei debería asegurar la seguridad, la dependencia total de estos parámetros en la URL es un riesgo si no hay validación estricta o un mecanismo más seguro.
        -   **Mensajes de error genéricos en UI (ADVERTENCIA):** Los errores de `PaymentsService` se muestran directamente como `e.toString()` en la UI, lo cual no es amigable ni informativo.
        -   **Complejidad del manejo de estado en `MembershipScreen` (ADVERTENCIA):** La lógica de `checkoutStep` dentro de un `StatefulBuilder` en un `BottomSheet` es compleja y podría generar errores.
- [x] **Tarea 3: Investigación del `SpecialistProvider`**
    - [x] Analizar `lib/providers/specialist_provider.dart` para entender la razón de la lógica de pago específica de Nuvei.
    - [x] Documentar cómo interactúa con `PaymentsService` para los pagos de reserva de especialistas.
    - [x] Evaluar si este acoplamiento es adecuado o si presenta riesgos.
    - [x] **Hallazgos Clave:**
        -   **Acoplamiento Excesivo con `PaymentsService` (ADVERTENCIA / REFACTORIZACIÓN):** `SpecialistProvider` tiene una fuerte dependencia y maneja estados específicos de Nuvei. Viola el principio de responsabilidad única.
        -   **Ambigüedad en `initiatePaymentFlow` (ADVERTENCIA):** El método obtiene la URL de checkout pero no la lanza, distribuyendo la responsabilidad y pudiendo generar flujos poco claros.
        -   **Manejo Genérico de Errores (ADVERTENCIA):** Uso de `e.toString()` para errores, dificultad para dar feedback preciso.
        -   **Ciclo de vida de `_isWaitingForWebhook` (INVESTIGAR / CRÍTICO):** La variable existe, pero su ciclo de vida no está claro. Un manejo incorrecto puede dejar reservas en estado de "pago pendiente".

## Criterios de Aceptación
*   Se ha generado un informe con los hallazgos de conflictos o áreas de mejora.
*   Se ha documentado el flujo de pago principal, incluyendo la interacción con Nuvei.
*   Se han identificado los puntos débiles en el manejo de errores o la actualización del estado.

## Checks
*   [x] Revisión manual de código.

## Forecast
*   Se espera que esta revisión tome aproximadamente 2-4 horas de trabajo enfocado.
*   Se identificarán al menos 2-3 áreas de mejora o conflictos potenciales.
