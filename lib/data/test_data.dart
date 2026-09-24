// ─── Test data centralizado ────────────────────────────────────
// Importa este archivo en lugar de definir datos dentro de las pantallas

class TestStep {
  final String main;
  final String? tip;
  const TestStep(this.main, [this.tip]);
}

class TestModel {
  final String icon;
  final String tag;
  final String title;
  final String description;
  final List<TestStep> steps;
  final List<String> errors;
  final String measuresTitle;
  final String measuresDesc;
  final String startLabel;
  final bool obligatory;

  const TestModel({
    required this.icon,
    required this.tag,
    required this.title,
    required this.description,
    required this.steps,
    required this.errors,
    required this.measuresTitle,
    required this.measuresDesc,
    required this.startLabel,
    this.obligatory = false,
  });
}

class TimerMode {
  static const countdown = 'countdown';
  static const stopwatch = 'stopwatch';
}

class TimerModel {
  final String testTitle;
  final String icon;
  final String mode;
  final int durationSeconds;
  final String unit;
  final String resultHint;
  final String prepHint;

  const TimerModel({
    required this.testTitle,
    required this.icon,
    required this.mode,
    required this.durationSeconds,
    required this.unit,
    required this.resultHint,
    required this.prepHint,
  });
}

// ─── Tests ─────────────────────────────────────────────────────
const allTests = [
  TestModel(
    icon: '🏃',
    tag: 'Resistencia cardiovascular',
    title: 'Test de Cooper',
    description: 'Corre o camina rápido durante 12 minutos continuos. Mide la distancia total recorrida en metros. Es uno de los métodos más usados para estimar el VO2 Max.',
    steps: [
      TestStep('Busca una pista o trayecto plano y medido — idealmente una pista de atletismo de 400m.', 'Una calle plana con GPS también funciona.'),
      TestStep('Calienta 5 minutos caminando o trotando suave antes de iniciar el cronómetro.'),
      TestStep('Al dar inicio, corre o camina lo más rápido que puedas durante 12 minutos exactos.', 'Mantén un ritmo que puedas sostener — no arranques demasiado rápido.'),
      TestStep('Al terminar, anota la distancia total recorrida en metros.', 'FitnFlai calculará tu VO2 Max estimado automáticamente.'),
    ],
    errors: [
      'Arrancar demasiado rápido y agotarte en los primeros minutos.',
      'Hacer pausas largas — si necesitas caminar, está bien, pero mantén el movimiento.',
      'No medir la distancia con precisión — usa GPS o una pista conocida.',
    ],
    measuresTitle: '¿Qué mide exactamente este test?',
    measuresDesc: 'Capacidad aeróbica máxima (VO2 Max estimado). Predice tu resistencia general, recuperación entre sesiones y potencial de mejora cardiovascular.',
    startLabel: 'Iniciar Test de Cooper',
  ),
  TestModel(
    icon: '💪',
    tag: 'Fuerza de tren superior',
    title: 'Flexiones en 1 minuto',
    description: 'Cuenta cuántas flexiones completas puedes hacer en 1 minuto. Mide la fuerza y resistencia muscular de pecho, hombros y tríceps.',
    steps: [
      TestStep('Posición de plancha completa: manos al ancho de hombros, cuerpo recto de cabeza a talones.', 'Rodillas en el suelo si necesitas modificar la dificultad.'),
      TestStep('Baja hasta que el pecho casi toque el suelo. Codos a 45° del cuerpo — ni muy abiertos ni pegados.', 'Mantén el abdomen contraído durante todo el movimiento.'),
      TestStep('Sube extendiendo completamente los codos. Solo cuentan las repeticiones completas: abajo Y arriba.'),
      TestStep('Repite al ritmo que puedas mantener durante 60 segundos completos. Puedes pausar brevemente.', 'El cronómetro no se detiene aunque hagas una pausa.'),
    ],
    errors: [
      'Bajar solo a la mitad — el pecho debe casi tocar el suelo.',
      'Caderas arriba o hacia abajo — el cuerpo debe mantenerse recto.',
      'Codos muy abiertos (90°) — aumenta el riesgo de lesión en hombros.',
    ],
    measuresTitle: '¿Qué mide exactamente este test?',
    measuresDesc: 'Fuerza-resistencia de pecho, hombros y tríceps. Predice tu capacidad para mantener postura en bici, potencia de brazada en natación y estabilidad general.',
    startLabel: 'Iniciar Flexiones',
  ),
  TestModel(
    icon: '🧘',
    tag: 'Core / Estabilidad',
    title: 'Plancha abdominal',
    description: 'Mantén la posición de plancha el mayor tiempo posible. Mide la resistencia del core, fundamental para la eficiencia en todos los deportes.',
    steps: [
      TestStep('Posición sobre antebrazos y pies: codos justo bajo los hombros, antebrazos paralelos.', 'Puedes entrelazar las manos o mantenerlas planas.'),
      TestStep('Cuerpo completamente recto de cabeza a talones. Activa el abdomen como si fueras a recibir un golpe.', 'No dejes que las caderas suban ni bajen.'),
      TestStep('Mantén la posición fija mirando hacia abajo. Respira de forma continua y controlada.'),
      TestStep('El test termina cuando las caderas caen, se elevan o el cuerpo deja de estar recto.', 'FitnFlai registra el tiempo en segundos automáticamente.'),
    ],
    errors: [
      'Caderas demasiado altas — el cuerpo pierde la línea recta.',
      'Caderas hacia el suelo — compensa la debilidad del core.',
      'Retener la respiración — respira de forma continua durante todo el test.',
      'Codos muy alejados de los hombros — reduce la efectividad del ejercicio.',
    ],
    measuresTitle: '¿Qué mide exactamente este test?',
    measuresDesc: 'Resistencia isométrica del core. Predice tu postura en carrera y bici, prevención de lesiones lumbares y eficiencia de transferencia de fuerza.',
    startLabel: 'Iniciar Plancha',
  ),
  TestModel(
    icon: '🦵',
    tag: 'Fuerza de tren inferior',
    title: 'Sentadillas en 1 minuto',
    description: 'Cuenta cuántas sentadillas puedes hacer en 1 minuto. Mide la fuerza funcional de tus piernas y tu resistencia muscular local.',
    obligatory: true,
    steps: [
      TestStep('Párate con los pies al ancho de los hombros. Punta de los pies ligeramente hacia afuera (15–30°).', 'No es necesario calzado especial — descalzo funciona perfectamente.'),
      TestStep('Baja hasta que tus muslos queden paralelos al suelo — o lo más cerca posible. Espalda recta, pecho arriba.', 'Si no llegas al paralelo, llega hasta donde puedas sin dolor.'),
      TestStep('Sube empujando con los talones. Extiende completamente las rodillas y caderas al llegar arriba.', 'Cada repetición cuenta solo si llegas abajo Y arriba completamente.'),
      TestStep('Repite al ritmo que puedas mantener durante los 60 segundos completos.', 'El cronómetro no se detiene.'),
    ],
    errors: [
      'Rodillas hacia adentro — siempre deben seguir la dirección de los pies.',
      'Talones levantados — si se pasan, separa más los pies o coloca algo delgado bajo los talones.',
      'Espalda redondeada — mantén el pecho alto durante todo el movimiento.',
    ],
    measuresTitle: '¿Qué mide exactamente este test?',
    measuresDesc: 'Fuerza resistencia de cuádriceps, glúteos e isquiotibiales. Predice tu capacidad para mantener la postura en bici, la zancada en carrera y la potencia deportiva.',
    startLabel: 'Iniciar Sentadillas',
  ),
  TestModel(
    icon: '🤸',
    tag: 'Flexibilidad',
    title: 'Inclinación hacia adelante',
    description: 'Mide tu flexibilidad isquiotibial y lumbar. La flexibilidad impacta directamente en tu técnica de pedaleo, zancada y prevención de lesiones.',
    steps: [
      TestStep('De pie, junta los pies completamente. Piernas extendidas, sin doblar las rodillas.', 'Puedes apoyarte contra una pared para mantener el equilibrio.'),
      TestStep('Inspira profundo. Al exhalar, inclínate lentamente hacia adelante llevando las manos hacia el suelo.', 'No hagas rebotes — el movimiento debe ser suave y controlado.'),
      TestStep('Llega hasta donde puedas sin doblar las rodillas ni forzar. Mantén la posición 2–3 segundos.'),
      TestStep('Repite 2 veces y toma el mejor resultado.', 'El cuerpo suele abrirse más en el segundo intento.'),
    ],
    errors: [
      'Doblar las rodillas — anula el estiramiento isquiotibial.',
      'Hacer rebotes hacia abajo — puede causar lesión muscular.',
      'Forzar más allá del límite — debe haber tensión, no dolor.',
    ],
    measuresTitle: '¿Qué mide exactamente este test?',
    measuresDesc: 'Flexibilidad de isquiotibiales y zona lumbar. Predice tu rango de movimiento en pedaleo, eficiencia de zancada y riesgo de lesiones en espalda baja.',
    startLabel: 'Iniciar Flexibilidad',
  ),
  TestModel(
    icon: '📊',
    tag: 'Esfuerzo percibido',
    title: 'Escala de Borg',
    description: 'Durante los tests, calificas tu esfuerzo en la escala de Borg (6–20). FitnFlai usa RPE 1–10 en el uso diario pero mapea ambas para compatibilidad clínica.',
    steps: [
      TestStep('Al finalizar cada test físico, FitnFlai te pedirá que califiques tu esfuerzo percibido.', 'No hay respuesta correcta — es tu percepción subjetiva.'),
      TestStep('Escala Borg original (6–20): 6 = ningún esfuerzo, 20 = esfuerzo máximo absoluto.', 'Una carrera moderada equivale aproximadamente a 12–14.'),
      TestStep('FitnFlai convierte automáticamente tu calificación Borg al sistema RPE 1–10.', 'RPE 5–6 equivale aproximadamente a Borg 12–14.'),
      TestStep('Esta información calibra las zonas de intensidad de tu plan de forma personalizada.', 'Cuanto más honesto seas, más preciso será tu plan.'),
    ],
    errors: [
      'Subestimar el esfuerzo por querer parecer más fit — sé honesto.',
      'Sobrestimar el esfuerzo — el sistema detecta inconsistencias.',
      'Calificar al inicio del test en lugar de al final.',
    ],
    measuresTitle: '¿Qué mide exactamente este test?',
    measuresDesc: 'Percepción subjetiva del esfuerzo. Calibra tus zonas de entrenamiento personalizadas y permite al sistema adaptar la intensidad de cada sesión.',
    startLabel: 'Entendido, continuar',
  ),
];

// ─── Timer configs ──────────────────────────────────────────────
const timerConfigs = [
  TimerModel(testTitle: 'Test de Cooper',        icon: '🏃', mode: TimerMode.countdown, durationSeconds: 720, unit: 'metros',   resultHint: 'Anota la distancia recorrida al terminar',             prepHint: 'Posiciónate en tu punto de inicio'),
  TimerModel(testTitle: 'Flexiones en 1 minuto', icon: '💪', mode: TimerMode.countdown, durationSeconds: 60,  unit: 'reps',     resultHint: 'Cuenta las repeticiones completas',                    prepHint: 'Posición de plancha, listo para empezar'),
  TimerModel(testTitle: 'Plancha abdominal',      icon: '🧘', mode: TimerMode.stopwatch, durationSeconds: 0,   unit: 'segundos', resultHint: 'Para el cronómetro cuando no puedas más',              prepHint: 'Posición sobre antebrazos, cuerpo recto'),
  TimerModel(testTitle: 'Sentadillas en 1 min',  icon: '🦵', mode: TimerMode.countdown, durationSeconds: 60,  unit: 'reps',     resultHint: 'Cuenta las repeticiones completas',                    prepHint: 'De pie, pies al ancho de hombros'),
  TimerModel(testTitle: 'Inclinación adelante',  icon: '🤸', mode: TimerMode.stopwatch, durationSeconds: 0,   unit: 'cm',       resultHint: 'Anota hasta dónde llegan tus manos',                   prepHint: 'De pie, piernas juntas y extendidas'),
  TimerModel(testTitle: 'Escala de Borg',         icon: '📊', mode: TimerMode.stopwatch, durationSeconds: 0,   unit: 'puntos',   resultHint: 'Selecciona tu nivel de esfuerzo percibido',            prepHint: 'Responde con honestidad'),
];
