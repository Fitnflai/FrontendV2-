// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabPlan => 'Plan';

  @override
  String get tabProgress => 'Progreso';

  @override
  String get tabNutrition => 'Nutrición';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get onboardingParqTitle => 'Cuestionario PAR-Q';

  @override
  String get onboardingParqSubtitle => 'Aptitud física cardiovascular';

  @override
  String get onboardingParqDesc =>
      'Responde con honestidad. Estas 7 preguntas determinan si es seguro que empieces a entrenar sin supervisión médica.';

  @override
  String get onboardingParqValidated =>
      'Validado internacionalmente · Obligatorio';

  @override
  String onboardingParqQuestionLabel(int index, int total) {
    return 'Pregunta $index de $total';
  }

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get onboardingSportSelectionHeader =>
      'Selecciona tu disciplina principal';

  @override
  String get settingsTitle => 'General';

  @override
  String get settingsSectionAppearance => 'APARIENCIA';

  @override
  String get settingsDarkMode => 'Modo oscuro';

  @override
  String get settingsSectionLanguageUnits => 'IDIOMA Y UNIDADES';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsDistance => 'Distancia';

  @override
  String get settingsSectionPrivacy => 'PRIVACIDAD';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidad';

  @override
  String get settingsTermsConditions => 'Términos y condiciones';

  @override
  String get settingsSaveChanges => 'Guardar cambios';

  @override
  String get settingsSavedSuccess => 'Configuración guardada';

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String onboardingSaveError(int statusCode) {
    return 'Error al guardar ($statusCode)';
  }

  @override
  String get onboardingParqClearTitle => '¡Estás listo para entrenar!';

  @override
  String get onboardingParqClearDesc =>
      'Respondiste No a todas las preguntas. Puedes comenzar tu plan de entrenamiento con total seguridad.';

  @override
  String get onboardingParqClearBullet1 =>
      'Sin contraindicaciones cardiovasculares detectadas';

  @override
  String get onboardingParqClearBullet2 =>
      'Sin factores de riesgo articular o muscular';

  @override
  String get onboardingParqClearBullet3 =>
      'Sin medicación cardiovascular activa';

  @override
  String get onboardingParqClearConfirmTitle =>
      'Confirmación de responsabilidad';

  @override
  String get onboardingParqClearConfirmDesc =>
      'Al continuar confirmas que la información que proporcionaste es correcta y que estás en condiciones de iniciar un programa de entrenamiento físico.';

  @override
  String get onboardingParqClearCheckboxLabel =>
      'Confirmo que la información es correcta y estoy apto para entrenar.';

  @override
  String get onboardingParqWarningTitle => 'Consulta médica requerida';

  @override
  String get onboardingParqWarningSubtitle => 'Antes de empezar tu plan';

  @override
  String get onboardingParqWarningDesc =>
      'Una o más de tus respuestas indica que debes hablar con un médico antes de iniciar un programa de ejercicio. Esto es por tu seguridad — no significa que no puedas entrenar.';

  @override
  String get onboardingParqWarningAlertTitle =>
      'Respuestas que activaron la alerta';

  @override
  String get onboardingParqWarningHelpTitle => '¿Qué debes hacer?';

  @override
  String get onboardingParqWarningHelpDesc =>
      'Consulta con un médico antes de empezar. Muéstrale este resultado. Una vez que obtengas su autorización, podrás activar tu plan desde Fitnflai.';

  @override
  String get onboardingParqWarningUnderstoodButton =>
      'Entendido · Lo consultaré con mi médico';

  @override
  String get onboardingParqWarningOverrideTitle =>
      '¿Quieres continuar de todas formas?';

  @override
  String get onboardingParqWarningOverrideDesc =>
      'Si ya tienes autorización médica o consideras que tu respuesta fue un error, puedes declararlo aquí. Fitnflai no se hace responsable si continúas sin consultar a un profesional.';

  @override
  String get onboardingParqWarningOverrideCheckboxLabel =>
      'Tengo autorización médica y asumo la responsabilidad de continuar con el programa';

  @override
  String onboardingSportSelected(String sport) {
    return '$sport seleccionado';
  }

  @override
  String get onboardingSportWeeksDurationTitle =>
      'Cuantas semanas\nquieres que dure tu plan';

  @override
  String get onboardingSportObligatory => 'Obligatorio';

  @override
  String onboardingSportWeeks(int weeks) {
    return '$weeks semanas';
  }

  @override
  String onboardingSportWeeksLabel(int weeks) {
    return '$weeks sem';
  }

  @override
  String onboardingSportMinRecommended(int weeks) {
    return 'mín. recomendado: $weeks sem';
  }

  @override
  String get onboardingSportTimeTight => 'Tiempo muy ajustado';

  @override
  String onboardingSportTimeTightDesc(int weeks) {
    return 'Para tu nivel y disciplina, recomendamos al menos $weeks semanas. Con menos tiempo el riesgo de sobreentrenamiento y lesiones aumenta considerablemente.';
  }

  @override
  String get onboardingSportTimeTightCheckbox =>
      'Entiendo el riesgo y deseo continuar bajo mi propia responsabilidad.';

  @override
  String get onboardingSportObligatoryBanner =>
      'Este paso es obligatorio — define la estructura de tu plan.';

  @override
  String get onboardingSportTrailRunning => 'Trail running';

  @override
  String get onboardingSportTrailRunningSubtitle =>
      'Carrera en montaña y senderos.';

  @override
  String get onboardingSportTriathlon => 'Triatlón';

  @override
  String get onboardingSportTriathlonSubtitle => 'Nado, bici, carrera.';

  @override
  String get onboardingSportRoadCycling => 'Ciclismo de ruta';

  @override
  String get onboardingSportRoadCyclingSubtitle => 'Ruta y velocidad.';

  @override
  String get onboardingSportMtb => 'MTB';

  @override
  String get onboardingSportMtbSubtitle => 'Ciclismo de montaña.';

  @override
  String get onboardingSportHiking => 'Senderismo';

  @override
  String get onboardingSportHikingSubtitle => 'Caminatas y trekking.';

  @override
  String get onboardingSportConditioning => 'Acondicionamiento';

  @override
  String get onboardingSportConditioningSubtitle => 'Fitness y fuerza general.';

  @override
  String get onboardingSportPrepRace => 'Prepararme para una competencia';

  @override
  String get onboardingSportPrepRaceSubtitle =>
      'Tengo una fecha objetivo en mente';

  @override
  String get onboardingSportImproveTime => 'Mejorar mi tiempo personal';

  @override
  String get onboardingSportImproveTimeSubtitle =>
      'Ya compito, quiero ser más rápido';

  @override
  String get onboardingSportImproveCondition => 'Mejorar mi condición general';

  @override
  String get onboardingSportImproveConditionSubtitle =>
      'Sin competencia específica por ahora';

  @override
  String get onboardingSportFormRaceData => 'Danos los datos de tu competencia';

  @override
  String get onboardingSportFormRaceDataDesc =>
      'Tu plan se estructurará en fases para que llegues en tu mejor forma el día de la competencia.';

  @override
  String get onboardingSportFormTimeImprove => 'Que tiempo quieres mejorar';

  @override
  String get onboardingSportFormImprove => 'Que quieres mejorar';

  @override
  String get onboardingSportDropdownRace => 'Competencia';

  @override
  String get onboardingSportDropdownSelectRace => 'Selecciona tu competencia';

  @override
  String get onboardingSportDropdownSelectSportFirst =>
      'Selecciona primero una disciplina';

  @override
  String get onboardingSportRaceName => 'Nombre de la competencia';

  @override
  String get onboardingSportRaceNameHint => 'Ej: Ultra Trail del Sur';

  @override
  String get onboardingSportDate => 'Fecha';

  @override
  String get onboardingSportSelectDate => 'Seleccionar fecha';

  @override
  String get onboardingSportDistance => 'Distancia';

  @override
  String get onboardingSportDistanceHint => 'Ej: 15';

  @override
  String onboardingSportRaceWeeksAvailable(int weeks) {
    return '$weeks semanas disponibles · Plan ajustado';
  }

  @override
  String get onboardingSportRaceWeeksRequiredTitle =>
      'Tiempo insuficiente para prepararte';

  @override
  String onboardingSportRaceWeeksRequiredDesc(
    int weeksAvailable,
    int weeksRequired,
  ) {
    return 'Tienes $weeksAvailable semanas hasta un día antes de tu competencia, pero para tu nivel necesitas al menos $weeksRequired. Con este tiempo el riesgo de lesión es alto y no podemos garantizar que llegues en las mejores condiciones.';
  }

  @override
  String get onboardingSportRaceWeeksRequiredNote =>
      'Aun así, podemos ayudarte a prepararte de la mejor manera posible dentro del tiempo disponible. 💪';

  @override
  String get onboardingSportRaceWeeksRequiredCheckbox =>
      'Entiendo los riesgos y asumo la responsabilidad. Quiero continuar con la preparación bajo mi propia cuenta.';

  @override
  String get onboardingSportActualTime => 'Tiempo actual';

  @override
  String get onboardingSportTargetTime => 'Tiempo objetivo';

  @override
  String get onboardingSportActualTimeDesc =>
      'Tu plan se estructurará en fases para que mejores tu tiempo progresivamente.';

  @override
  String get onboardingSportTargetTimeError =>
      'El tiempo objetivo debe ser menor al tiempo actual. Tu meta es mejorar tu marca.';

  @override
  String get onboardingSportWhatToImprove => '¿Qué quieres mejorar?';

  @override
  String get onboardingSportSelectCategory => 'Selecciona una categoría';

  @override
  String get onboardingSportSpecificGoal => '¿Cuál es tu objetivo específico?';

  @override
  String get onboardingSportSelectGoal => 'Selecciona un objetivo';

  @override
  String get onboardingSportGeneralConditionDesc =>
      'Tu plan se estructurará en fases para alcanzar tu objetivo de forma progresiva.';

  @override
  String get onboardingProfileBasicTitle => 'Perfil básico';

  @override
  String get onboardingProfileBirthdate => 'Fecha de nacimiento';

  @override
  String get onboardingProfileBirthdateHint => 'DD / MM / AAAA';

  @override
  String get onboardingProfileGender => 'Género';

  @override
  String get onboardingProfileGenderMale => 'Masculino';

  @override
  String get onboardingProfileGenderFemale => 'Femenino';

  @override
  String get onboardingProfileMetricsTitle => 'Medidas corporales';

  @override
  String get onboardingProfileWeight => 'Peso actual';

  @override
  String get onboardingProfileHeight => 'Altura';

  @override
  String get onboardingProfileCityTitle => 'Ciudad y altitud';

  @override
  String get onboardingProfileCity => 'Ciudad';

  @override
  String get onboardingProfileCityHint => 'Buscar ciudad...';

  @override
  String get onboardingProfileCitySearching => 'Calculando...';

  @override
  String get onboardingProfileAltitude => 'Altitud';

  @override
  String get onboardingProfileAltitudeHint => 'Ej: 2850';

  @override
  String get onboardingProfileAltitudeActiveTitle =>
      'Altitud inteligente activada';

  @override
  String onboardingProfileAltitudeActiveDesc(String altitude) {
    return 'Tu plan ajusta zonas FC, hidratación y recuperación para ${altitude}m s.n.m.';
  }

  @override
  String get onboardingProfileAltitudeActiveDescSimple =>
      'Tu plan ajusta zonas FC, hidratación y recuperación según tu altitud.';

  @override
  String onboardingProfileAltitudeCorrection(String altitude) {
    return '🏔️  $altitude m s.n.m. · Corrección activa';
  }

  @override
  String get onboardingProfileAltitudeCorrectionSimple =>
      '🏔️  Corrección activa';

  @override
  String get onboardingProfileMenstrualTitle => 'Ciclo femenino';

  @override
  String get onboardingProfileMenstrualToggle => 'Activar adaptación de carga';

  @override
  String get onboardingProfileMenstrualDesc =>
      'Si lo activas, Fitnflai adaptará la intensidad del plan según las fases de tu ciclo menstrual.';

  @override
  String get onboardingProfileMenstrualLastCycle => 'Último ciclo';

  @override
  String get onboardingProfileMenstrualCycleStart => 'Inicio';

  @override
  String get onboardingProfileMenstrualCycleEnd => 'Fin';

  @override
  String get onboardingProfileMenstrualSelect => 'Seleccionar';

  @override
  String get onboardingProfileMenstrualSelectDates => 'Seleccionar fechas';

  @override
  String onboardingProfileMenstrualRange(int start, int end, String month) {
    return 'Del $start al $end de $month';
  }

  @override
  String get onboardingProfileOptional => 'Opcional';

  @override
  String get onboardingFitnessActivityTitle => 'Nivel de actividad actual';

  @override
  String get onboardingFitnessSessionTitle => 'Tiempo por sesión';

  @override
  String get onboardingFitnessEquipmentTitle => 'Equipamiento disponible';

  @override
  String get onboardingFitnessDaysTitle => 'Días disponibles';

  @override
  String get onboardingFitnessDaysSelectAtLeastOne =>
      'Selecciona al menos un día';

  @override
  String onboardingFitnessDaysSelected(int count) {
    return '$count día seleccionado';
  }

  @override
  String onboardingFitnessDaysSelectedPlural(int count) {
    return '$count días seleccionados';
  }

  @override
  String get onboardingFitnessStartTitle => 'Cuando quieres iniciar';

  @override
  String get onboardingFitnessStartDate => 'Fecha de inicio';

  @override
  String get onboardingFitnessSelect => 'Seleccionar';

  @override
  String get onboardingFitnessExperienceTitle => 'Experiencia deportiva';

  @override
  String get onboardingFitnessExercisingNow => '¿Te ejercitas actualmente?';

  @override
  String get onboardingFitnessYearsTraining => 'Años entrenando';

  @override
  String get onboardingFitnessInactivityDuration =>
      '¿Desde cuándo no te ejercitas?';

  @override
  String get onboardingFitnessCompetedBefore => '¿Has competido antes?';

  @override
  String get onboardingBodyInjuriesTitle => 'Lesiones y condiciones';

  @override
  String get onboardingBodyInjuryActive => '¿Lesiones activas?';

  @override
  String get onboardingBodyInjuryDesc => 'Descripción de la molestia';

  @override
  String get onboardingBodyInjuryDescHint =>
      'Ej: Condromalacia rotuliana, duele al bajar pendientes';

  @override
  String get onboardingBodyInjuryZone => 'Zona afectada';

  @override
  String get onboardingBodyInjuryZoneHint => 'Ej: Rodilla Derecha';

  @override
  String get onboardingBodyInjuryType => 'Tipo de lesión';

  @override
  String get onboardingBodyInjuryTypeActive => 'Activa';

  @override
  String get onboardingBodyInjuryTypeChronic => 'Crónica';

  @override
  String get onboardingBodyInjuryPainLevel => 'Nivel de dolor (EVA: 1–10)';

  @override
  String get onboardingBodySurgery => '¿Cirugías recientes (último año)?';

  @override
  String get onboardingBodySurgeryHint => '¿Cuál? Ej: menisco, hombro...';

  @override
  String get onboardingBodyPainChronic => '¿Dolor crónico o recurrente?';

  @override
  String get onboardingBodyPainChronicHint => '¿Dónde? Ej: lumbar, cadera...';

  @override
  String get onboardingBodyCardio => '¿Condición cardiovascular diagnosticada?';

  @override
  String get onboardingBodyCardioHint => '¿Cuál? Ej: hipertensión, arritmia...';

  @override
  String get onboardingBodyCompositionTitle =>
      '¿Tienes datos de composición corporal?';

  @override
  String get onboardingBodyCompositionDesc =>
      'Si tienes una balanza inteligente o informe de bioimpedancia, Fitnflai extrae los datos automáticamente para personalizar mejor tu plan.';

  @override
  String get onboardingBodyUploadTitle => 'Subir informe';

  @override
  String get onboardingBodyUploadProcessing => 'Procesando informe...';

  @override
  String get onboardingBodyUploadScaleHint => 'Sube el informe de tu balanza';

  @override
  String get onboardingBodyUploadScaleDesc =>
      'Fitnflai extrae % grasa, músculo, agua corporal\ny TMB para calibrar mejor tu plan.';

  @override
  String get onboardingBodyUploadImageBtn => 'Subir foto';

  @override
  String get onboardingBodyUploadPdfBtn => 'Subir PDF';

  @override
  String get onboardingBodyUploadDeleteBtn => '✕  Eliminar archivo';

  @override
  String get onboardingBodyOptionalNote =>
      'Este paso es completamente opcional. Puedes agregar estos datos más tarde desde tu perfil.';

  @override
  String get onboardingBodyUploadSuccess => '✅ Archivo subido correctamente';

  @override
  String get onboardingBodyUploadProcessedSuccess =>
      'Informe procesado correctamente';

  @override
  String get onboardingBodyUploadScaleDataExtracted =>
      'Datos extraídos de tu báscula:';

  @override
  String get onboardingBodyUploadSuccessDialogTitle =>
      'Informe procesado correctamente';

  @override
  String get onboardingBodyUploadErrorDialogTitle => 'No se pudo procesar';

  @override
  String get onboardingBodyUploadErrorDialogDesc =>
      'No fue posible extraer los datos del informe. Asegúrate de que el archivo sea legible y vuelve a intentarlo.';

  @override
  String get onboardingBodyUploadErrorDialogCancel => 'Cancelar';

  @override
  String get onboardingBodyUploadErrorDialogRetry => 'Reintentar';

  @override
  String get onboardingGeneratingPlanTitle => 'Generando tu plan personalizado';

  @override
  String get onboardingGeneratingWorking => 'Estamos trabajando en tu plan.';

  @override
  String get onboardingGeneratingAnalyzing =>
      'Analizando tus datos y estructurando tu plan';

  @override
  String get onboardingGeneratingStepParq => '✓ PAR-Q guardado\ncorrectamente';

  @override
  String get onboardingGeneratingStepUserProfile =>
      '✓ Datos de usuario\nguardados correctamente';

  @override
  String get onboardingGeneratingStepPhysical =>
      '✓ Datos físicos\nguardados correctamente';

  @override
  String get onboardingGeneratingStepFitness =>
      '✓ Estado físico y disponibilidad\nguardados correctamente';

  @override
  String get onboardingGeneratingStepMedical =>
      '✓ Historial médico y lesiones\nguardados correctamente';

  @override
  String get onboardingGeneratingStepFunctionalTest =>
      '✓ Test funcional\nguardado correctamente';

  @override
  String get onboardingGeneratingStepStructuring =>
      'Estructurando fases de tu plan...';

  @override
  String get onboardingGeneratingStepWeeklySessions =>
      'Generando sesiones semana a semana';

  @override
  String onboardingFeedbackReadyTitle(String name) {
    return '¡Listo, $name!';
  }

  @override
  String get onboardingFeedbackReadySubtitle =>
      'Tu plan está personalizado, inicia y\nalcanza tus objetivos.';

  @override
  String get onboardingFeedbackDetailTitle => 'Tu plan en detalle';

  @override
  String get onboardingFeedbackEcosystemTitle =>
      'Lo que ves aquí es solo la superficie. Detrás de tu plan hay un ';

  @override
  String get onboardingFeedbackEcosystemHighlight => 'ecosistema de wellness';

  @override
  String get onboardingFeedbackWorkingForYou =>
      ' trabajando para ti — cada sesión, cada intensidad, cada descanso ';

  @override
  String get onboardingFeedbackHasReason => 'tiene una razón.';

  @override
  String get onboardingFeedbackStartFreeTrial => 'Empezar mis 21 días gratis';

  @override
  String get onboardingFeedbackDurationLabel => 'Duracion';

  @override
  String get onboardingFeedbackStartLabel => 'Inicio';

  @override
  String get onboardingFeedbackZonesTitle => 'Tus zonas de entrenamiento';

  @override
  String get onboardingFeedbackZonesDesc =>
      'Cada zona indica exactamente qué tan fuerte ir en cada sesión. Sin esto, entrenas a ciegas.';

  @override
  String get onboardingFeedbackZonesHighlight =>
      'Tu plan especifica en qué zona va cada sesión.';

  @override
  String get onboardingFeedbackZonesDisclaimer =>
      'A medida que entrenas, tu cuerpo mejora y estas zonas cambian. ';

  @override
  String get onboardingFeedbackZonesDisclaimerAction =>
      'Repetir los tests periódicamente permite ajustarlas.';

  @override
  String get authDividerOr => 'o continúa con';

  @override
  String get authEmail => 'Correo electrónico';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authConfirmPassword => 'Confirmar contraseña';

  @override
  String get authEmailHint => 'correo@ejemplo.com';

  @override
  String get authPasswordHint => 'Tu contraseña';

  @override
  String get authGoogleButton => 'Continuar con Google';

  @override
  String get authAppleButton => 'Continuar con Apple';

  @override
  String get authMetaButton => 'Continuar con Meta';

  @override
  String get welcomeTitle => 'Elige tu idioma';

  @override
  String get welcomeSubtitle => 'Puedes cambiarlo después en ajustes';

  @override
  String get welcomeButton => 'Continuar';

  @override
  String get welcomeMarketingText => 'Wellness completo, a tu ritmo.';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginWelcomeBack => 'Bienvenido de vuelta';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginNoAccount => '¿No tienes cuenta? ';

  @override
  String get loginSignUpLink => 'Regístrate →';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get loginEmailRequired => 'Ingresa tu correo';

  @override
  String get loginEmailInvalid => 'Correo inválido';

  @override
  String get loginPasswordRequired => 'Ingresa tu contraseña';

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get registerSubtitle => 'Crea tu cuenta para comenzar';

  @override
  String get registerNameLabel => 'Nombre completo';

  @override
  String get registerNameHint => 'Tu nombre';

  @override
  String get registerNameRequired => 'Ingresa tu nombre';

  @override
  String get registerUsernameLabel => 'Nombre de usuario';

  @override
  String get registerUsernameHint => '@usuario';

  @override
  String get registerUsernameRequired => 'Ingresa un nombre de usuario';

  @override
  String get registerUsernameNoSpaces => 'Sin espacios';

  @override
  String get registerUsernameTooShort => 'Mínimo 3 caracteres';

  @override
  String get registerEmailInvalid =>
      'Ingresa un correo válido (ej: nombre@gmail.com)';

  @override
  String get registerPasswordRequired => 'Ingresa una contraseña';

  @override
  String get registerPasswordTooShort => 'Mínimo 8 caracteres';

  @override
  String get registerConfirmPasswordRequired => 'Confirma tu contraseña';

  @override
  String get registerPasswordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get registerTermsAccept => 'Acepto los ';

  @override
  String get registerTermsLink => 'Términos y Condiciones';

  @override
  String get registerAnd => ' y la ';

  @override
  String get registerPrivacyLink => 'Política de Privacidad';

  @override
  String get registerAlreadyHaveAccount => '¿Ya tienes cuenta? ';

  @override
  String get registerLoginLink => 'Inicia sesión →';

  @override
  String get registerTermsSnackBarError =>
      'Debes aceptar los términos y condiciones';

  @override
  String get forgotPasswordTitle => 'Recuperar contraseña';

  @override
  String get forgotPasswordInstruction =>
      'Ingresa tu correo y te enviaremos\nun enlace para restablecer tu contraseña.';

  @override
  String get forgotPasswordSendButton => 'Enviar enlace';

  @override
  String get forgotPasswordBackToLogin => 'Volver al inicio de sesión';

  @override
  String get forgotPasswordHasCode => 'Ya tengo un código';

  @override
  String get forgotPasswordErrorSending =>
      'No se pudo enviar el enlace. Verifica tu correo.';

  @override
  String get forgotPasswordConnectionError =>
      'Error de conexión. Intenta de nuevo.';

  @override
  String get forgotPasswordSuccessTitle => '¡Correo enviado!';

  @override
  String forgotPasswordSuccessDesc(String email) {
    return 'Enviamos un enlace de recuperación a\n$email';
  }

  @override
  String get forgotPasswordEnterCodeButton => 'Ingresar código / token';

  @override
  String get resetPasswordTitle => 'Nueva contraseña';

  @override
  String get resetPasswordInstruction =>
      'Ingresa el token que recibiste por correo y tu nueva contraseña.';

  @override
  String get resetPasswordErrorDefault => 'Token inválido o expirado.';

  @override
  String get resetPasswordConnectionError =>
      'Error de conexión. Intenta de nuevo.';

  @override
  String get resetPasswordTokenLabel => 'Token de recuperación';

  @override
  String get resetPasswordTokenHint => 'Pega el token del correo';

  @override
  String get resetPasswordTokenRequired => 'Ingresa el token';

  @override
  String get resetPasswordNewLabel => 'Nueva contraseña';

  @override
  String get resetPasswordNewHint => 'Mínimo 8 caracteres';

  @override
  String get resetPasswordNewRequired => 'Ingresa tu nueva contraseña';

  @override
  String get resetPasswordNewTooShort => 'Mínimo 8 caracteres';

  @override
  String get resetPasswordConfirmLabel => 'Confirmar contraseña';

  @override
  String get resetPasswordConfirmHint => 'Repite la contraseña';

  @override
  String get resetPasswordConfirmRequired => 'Confirma tu contraseña';

  @override
  String get resetPasswordConfirmMismatch => 'Las contraseñas no coinciden';

  @override
  String get resetPasswordChangeButton => 'Cambiar contraseña';

  @override
  String get resetPasswordBackLink => 'Volver';

  @override
  String get resetPasswordSuccessTitle => '¡Contraseña actualizada!';

  @override
  String get resetPasswordSuccessDesc =>
      'Tu contraseña fue cambiada correctamente.\nYa puedes iniciar sesión.';

  @override
  String get resetPasswordGoToLoginButton => 'Ir al inicio de sesión';

  @override
  String get homeHeaderSection => 'Inicio';

  @override
  String get homeKeySessionNoteHeader => 'Sesión clave de la semana';

  @override
  String get homeConnectDevicesTitle => 'Conecta tus dispositivos';

  @override
  String get homeConnectDevicesDesc =>
      'Opcional pero recomendado. Con tus datos de wearable Fitnflai adapta tu plan en tiempo real pasos, sueño, FC y más.';

  @override
  String get homeDeviceConnectedTitle => 'Dispositivo conectado';

  @override
  String get homeDeviceConnectedDesc =>
      'Fitnflai está recibiendo tus datos en tiempo real.';

  @override
  String get homeSleepLabel => 'Sueño\nanoche';

  @override
  String get homeRestHRLabel => 'FC reposo';

  @override
  String get homeTemperatureLabel => 'Temperatura\nahora';

  @override
  String get homeWeatherLabel => 'Condición\nclimática';

  @override
  String get homeDailyCheckinTitle => '¿Cómo estás hoy?';

  @override
  String get homeDailyCheckinDesc =>
      'Responde 4 preguntas rápidas para que Fitnflai ajuste tu sesión.';

  @override
  String get homeSectionWeeklyDist => 'DISTRIBUCIÓN SEMANAL';

  @override
  String get homeSectionWeeklyIntensity => 'INTENSIDAD SEMANAL';

  @override
  String get homeSectionWeeklyAdherence => 'ADHERENCIA AL PLAN';

  @override
  String homeSessionCompleted(int completed, int total) {
    return '$completed de $total sesiones completadas';
  }

  @override
  String homeRestDayTitle(String name) {
    return 'Descansa, $name';
  }

  @override
  String get homeRestDayDesc =>
      'La recuperación es parte del entrenamiento.\n¡Disfruta este día de descanso!';

  @override
  String get homeRestDayActiveSection => 'DESCANSO ACTIVO';

  @override
  String get homeRestTipWalkTitle => 'Caminata suave';

  @override
  String get homeRestTipWalkDesc => '20–30 min a ritmo conversacional';

  @override
  String get homeRestTipMobilityTitle => 'Movilidad';

  @override
  String get homeRestTipMobilityDesc => '10 min de estiramientos dinámicos';

  @override
  String get homeRestTipHydrationTitle => 'Hidratación';

  @override
  String get homeRestTipHydrationDesc => 'Mantén un buen nivel hídrico hoy';

  @override
  String get homeRestTipSleepTitle => 'Sueño';

  @override
  String get homeRestTipSleepDesc => 'Prioriza 7–9 horas de descanso';

  @override
  String get homeSessionMissed => 'Sin completar';

  @override
  String get homeWorkoutStartButton => 'Iniciar entrenamiento';

  @override
  String get homeWorkoutAdjustButton => '¿Cansado o mal clima? Ajustar';

  @override
  String get homeWorkoutDetailButton => 'Ver detalle del entrenamiento';

  @override
  String homeAdherencePct(int percentage) {
    return '$percentage%';
  }

  @override
  String get homeTipOfTheDayTitle => 'Tip del día';

  @override
  String get homeTipOfTheDayDesc =>
      'Recuerda hidratarte bien antes de tu próxima sesión de alta intensidad.';

  @override
  String get settingsRefundRequest => 'Solicitar reembolso';

  @override
  String get membershipNuveiInstructions =>
      'Hemos abierto la pasarela de pagos segura de Nuvei en tu navegador. Por favor, completa tu pago allí. Una vez finalizado, vuelve a Fitnflai y pulsa el botón \'Verificar Pago\' para actualizar tu suscripción. NO CIERRES esta ventana hasta haber completado el proceso.';

  @override
  String get membershipNuveiVerifyButton => 'Verificar Pago';

  @override
  String get membershipNuveiCloseButton => 'Cerrar';

  @override
  String get refundReferenceLabel => 'Referencia de pago (número de orden)';

  @override
  String get refundReasonLabel => 'Razón del reembolso';

  @override
  String get refundEmptyFieldsError =>
      'Por favor, ingresa la referencia y la razón.';

  @override
  String get refundSuccess =>
      'Solicitud de reembolso enviada con éxito. Te contactaremos pronto.';

  @override
  String get workoutAdjustmentReasonLabel => 'Motivo del ajuste';

  @override
  String get workoutAdjustmentReasonSelect => 'Seleccioná un motivo';

  @override
  String get workoutAdjustmentReasonWeather => 'Mal clima';

  @override
  String get workoutAdjustmentReasonTired => 'Cansado';

  @override
  String get workoutAdjustmentReasonInjury => 'Lesión';

  @override
  String get workoutAdjustmentReasonOther => 'Otro';

  @override
  String get workoutAdjustmentSeverityLabel => 'Gravedad de la lesión';

  @override
  String get workoutAdjustmentSeveritySelect => 'Seleccioná la gravedad';

  @override
  String get workoutAdjustmentSeverityMild => 'Leve';

  @override
  String get workoutAdjustmentSeverityModerate => 'Media';

  @override
  String get workoutAdjustmentSeveritySevere => 'Grave';

  @override
  String get workoutAdjustmentDescLabel => 'Detalles adicionales (opcional)';

  @override
  String get workoutAdjustmentDescPlaceholder =>
      'Escribí acá más detalles de cómo te sentís...';

  @override
  String get workoutAdjustmentValidationRequired => 'Este campo es obligatorio';

  @override
  String get workoutAdjustmentBtnSubmit => 'Enviar';

  @override
  String get workoutAdjustmentBtnCancel => 'Cancelar';

  @override
  String get workoutAdjustmentSuccessMessage => '¡Ajuste enviado con éxito!';

  @override
  String get specialistBookingTitle => 'Agendar Cita';

  @override
  String get specialistBookingSelectDate => 'Selecciona el día';

  @override
  String get specialistBookingSelectTime => 'Selecciona el horario';

  @override
  String get specialistBookingConfirmBtn => 'Programar cita (\$19.99)';

  @override
  String get specialistBookingDuration => 'Cita de 45 min';

  @override
  String get specialistBookingCheckoutTitle => 'Confirmar Reserva';

  @override
  String get specialistBookingCheckoutSummary => 'Sesión Especialista (45 min)';

  @override
  String get specialistBookingCheckoutConfirmBtn => 'Confirmar y Pagar';

  @override
  String get specialistBookingSuccessTitle => '¡Cita Programada!';

  @override
  String specialistBookingSuccessDesc(String date, String time) {
    return 'Tu cita ha sido programada con éxito para el $date a las $time.';
  }

  @override
  String get specialistBookingSuccessClose => 'Entendido';

  @override
  String get specialistBookingErrorMissingData =>
      'Faltan datos para la reserva. Asegúrate de seleccionar un especialista y una hora.';

  @override
  String get specialistBookingProfileReloadFailed =>
      'Cita programada, pero no se pudo actualizar el perfil de inmediato.';

  @override
  String get specialistBookingGenericError =>
      'Error al programar la cita. Por favor, intenta de nuevo.';

  @override
  String get specialistBookingDefaultDescription => 'Consulta online';

  @override
  String get testTimerBorgQuestion =>
      '¿Cuánto esfuerzo percibiste? (Borg 6–20)';

  @override
  String get testTimerBorgLevel6 => 'Ningún esfuerzo';

  @override
  String get testTimerBorgLevel7 => 'Muy muy suave';

  @override
  String get testTimerBorgLevel8 => 'Muy suave';

  @override
  String get testTimerBorgLevel9 => 'Bastante suave';

  @override
  String get testTimerBorgLevel10 => 'Suave';

  @override
  String get testTimerBorgLevel11 => 'Ligeramente moderado';

  @override
  String get testTimerBorgLevel12 => 'Moderado';

  @override
  String get testTimerBorgLevel13 => 'Algo fuerte';

  @override
  String get testTimerBorgLevel14 => 'Fuerte';

  @override
  String get testTimerBorgLevel15 => 'Muy fuerte';

  @override
  String get testTimerBorgLevel16 => 'Muy muy fuerte';

  @override
  String get testTimerBorgLevel17 => 'Extremadamente fuerte';

  @override
  String get testTimerBorgLevel18 => 'Casi máximo';

  @override
  String get testTimerBorgLevel19 => 'Muy cerca del máximo';

  @override
  String get testTimerBorgLevel20 => 'Esfuerzo máximo';

  @override
  String get testTimerBorgMinLabel => 'Ninguno';

  @override
  String get testTimerBorgMidLabel => 'Algo fuerte';

  @override
  String get testTimerBorgMaxLabel => 'Máximo';

  @override
  String get testTimerEnterResultPrompt =>
      'Ingresa tu resultado antes de continuar';

  @override
  String get testTimerSaveError =>
      'Error al guardar el resultado. Intenta de nuevo.';

  @override
  String get testTimerConnectionError => 'Error de conexión. Intenta de nuevo.';

  @override
  String get testTimerModeFree => 'Libre';

  @override
  String get testTimerStatusCompleted => 'Completado';

  @override
  String get testTimerButtonFinishNow => 'Terminar ahora';

  @override
  String get testTimerButtonReset => 'Reiniciar desde cero';

  @override
  String get testTimerCompletionTitle => '¡Test completado!';

  @override
  String testTimerCompletionTime(String time) {
    return 'Tiempo: $time';
  }

  @override
  String get testTimerFlexibilityQuestion => '¿Hasta dónde llegaron tus manos?';

  @override
  String get testTimerFlexOptionKnees => 'No llega a rodillas';

  @override
  String get testTimerFlexOptionFeet => 'Llega a pies';

  @override
  String get testTimerFlexOptionPastFeet => 'Supera los pies';

  @override
  String get testTimerFlexOptionGround => 'Palmas al suelo';

  @override
  String testTimerEnterResultWithUnit(String unit) {
    return 'Ingresa tu resultado en $unit';
  }

  @override
  String get testTimerSaveAndContinue => 'Guardar y continuar';

  @override
  String get homeCalendarToday => 'Hoy';

  @override
  String get weatherRain => 'Lluvia';

  @override
  String get weatherClear => 'Despejado';

  @override
  String get weatherPartlyCloudy => 'Poco nublado';

  @override
  String get weatherCloudy => 'Nublado';

  @override
  String get weatherFog => 'Niebla';

  @override
  String get weatherSnow => 'Nieve';

  @override
  String get weatherShowers => 'Chubascos';

  @override
  String get weatherThunderstorm => 'Tormenta';

  @override
  String get planHeaderSection => 'Plan';

  @override
  String get planContextPast => 'Semana pasada';

  @override
  String get planContextFuture => 'Semana próxima';

  @override
  String get planContextCurrent => 'Semana actual';

  @override
  String get planSessionsLabel => 'sesiones';

  @override
  String get planCompletedLabel => 'completado';

  @override
  String get planEmptyFutureTitle =>
      'Tu plan para esta semana aún no está listo';

  @override
  String get planEmptyFutureDesc =>
      'La IA generará tu plan cuando llegue el momento.';

  @override
  String get planEmptyPastTitle => 'No hay entrenamientos esta semana';

  @override
  String get planEmptyPastDesc =>
      'La IA generará tu plan cuando llegue el momento.';

  @override
  String get planLoadError => 'Error al cargar el plan';

  @override
  String get planConnError => 'Error de conexión';

  @override
  String get planRetry => 'Reintentar';

  @override
  String get planActiveRestLabel => 'DÍA DE DESCANSO';

  @override
  String get planActiveRestToday => 'Hoy · Descanso';

  @override
  String get planActiveRestActive => 'Descanso activo';

  @override
  String get planActiveRestDefaultMsg =>
      'La recuperación es parte del entrenamiento. ¡Disfruta este día de descanso!';

  @override
  String get planActiveRestRecs => 'RECOMENDACIONES';

  @override
  String get planActiveRestTipWalk => 'Caminata';

  @override
  String get planActiveRestTipMobility => 'Movilidad';

  @override
  String get planActiveRestTipHydration => 'Hidratación';

  @override
  String get planActiveRestTipSleep => 'Sueño';

  @override
  String get planActiveRestTipWalkDesc => 'Caminata suave';

  @override
  String get planActiveRestTipMobilityDesc => 'Estiramientos dinámicos';

  @override
  String get planActiveRestTipHydrationDesc => 'Mantén tu hidratación';

  @override
  String get planActiveRestTipSleepDesc => 'Duerme bien';

  @override
  String get planSessionCardTodayHeader => 'ENTRENAMIENTO DE HOY';

  @override
  String get planSessionCardTodayBadge => 'Hoy';

  @override
  String get planSessionCardCompletedBadge => 'Completado';

  @override
  String get planSessionCardMissedBadge => 'No completada';

  @override
  String get planSessionCardStartBtn => 'Iniciar entrenamiento';

  @override
  String get planSessionCardAdjustBtn => '¿Cansado o mal clima? Ajustar';

  @override
  String get planSessionCardDetailBtn => 'Ver detalle';

  @override
  String get planSessionCardLockDesc => 'Disponible cuando llegue la semana';

  @override
  String get progressHeaderSection => 'Progreso';

  @override
  String progressSummaryTitle(int months) {
    return 'En estos $months meses lograste:';
  }

  @override
  String get progressSummaryCompleted => 'sesiones completadas';

  @override
  String get progressSummaryHours => 'horas entrenando';

  @override
  String get progressSummaryFat => 'grasa corporal';

  @override
  String get progressWellnessAgeTitle => 'Edad de bienestar';

  @override
  String progressWellnessAgeDesc(int years, int startAge) {
    return 'Tu cuerpo es $years años más joven que tu edad real. Empezaste con $startAge.';
  }

  @override
  String progressWellnessAgeDiff(int years) {
    return '$years años desde que empezaste';
  }

  @override
  String get progressClaveBadge => 'Clave';

  @override
  String get progressClaveDesc =>
      'Mantén condiciones cardiovasculares. Fuerza, movilidad y composición corporal son las métricas que \"van\" con entrenamiento de calidad. Cuenta más entrenar, más fácil todo se vuelve.';

  @override
  String get progressSectionHealthComp => 'Salud y composición';

  @override
  String get progressIndicatorsSubtitle => 'Los 3 indicadores clave';

  @override
  String progressIndicatorBefore(String before) {
    return 'antes: $before';
  }

  @override
  String progressIndicatorTarget(String target) {
    return 'objetivo: $target';
  }

  @override
  String get progressSectionPerformance => 'Rendimiento y entrenamiento';

  @override
  String get progressComplianceTitle => 'Cumplimiento del plan';

  @override
  String get progressComplianceSubtitle => 'Últimas 4 semanas';

  @override
  String get progressComplianceDesc =>
      'La constancia es el factor que más predice el progreso. Completar el plan semana a semana es tan importante como el entrenamiento en sí.';

  @override
  String get progressLoadTitle => 'Carga semanal';

  @override
  String get progressLoadSubtitle => 'para misma carga';

  @override
  String get progressLoadDesc =>
      'Más horas de forma progresiva es la señal de que tu cuerpo se adapta y puede soportar más. Las semanas bajas son descargas planificadas, no retrocesos.';

  @override
  String get progressLoadThisWeek => 'esta semana';

  @override
  String get progressLoadVsPrevious => 'vs mes anterior';

  @override
  String get progressLoadAverage => 'promedio';

  @override
  String get progressLoadDescNote =>
      '= semanas marcadas con descargas planificadas';

  @override
  String get progressRpeTitle => 'Esfuerzo percibido (RPE)';

  @override
  String get progressRpeSubtitle => '#2 horas · # sesiones';

  @override
  String get progressRpeDesc =>
      'Si haces el entrenamiento con menos esfuerzo, tu cuerpo se está volviendo más eficiente. Que las barras bajen es la prueba de que estás mejorando.';

  @override
  String get progressAITendencyTitle => 'Tendencia general · Fitnflai';

  @override
  String get progressAITendencySubtitle => 'Análisis de los últimos 3 meses';

  @override
  String get progressAITendencyDesc =>
      'Llevas 3 meses con tendencia positiva en todas las métricas clave. Nico, tu recomposición corporal avanza de forma consistente y tu capacidad cardiovascular se encuentra en un nivel excelente para tu edad.';

  @override
  String get nutritionHeaderSection => 'Nutrición';

  @override
  String get nutritionAIBannerTitle =>
      'Nutrición inteligente para tu entrenamiento';

  @override
  String get nutritionAIBannerDesc =>
      'Tu plan nutricional semanal, macros personalizados y tipo de alimentación antes de cada sesión. Generado por Fitnflai según tu carga de entrenamiento.';

  @override
  String get nutritionAIBannerProTitle => 'Con el plan Pro desbloqueas:';

  @override
  String get nutritionAIBannerProBtn => 'Ver plan Pro';

  @override
  String get nutritionAIBannerProNote =>
      'Sin tarjeta de crédito · Cancela cuando quieras';

  @override
  String get nutritionRestDayBanner =>
      'Día de descanso · Come liviano y mantente bien hidratado.';

  @override
  String get nutritionMacrosTitle => 'Macros del día';

  @override
  String nutritionMacrosKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get nutritionMacrosCarbs => 'Carbohidratos';

  @override
  String get nutritionMacrosProtein => 'Proteína';

  @override
  String get nutritionMacrosFat => 'Grasas';

  @override
  String nutritionSectionPlanTitle(String title) {
    return 'PLAN DEL DÍA · $title';
  }

  @override
  String get nutritionHydrationTitle => 'Hidratación básica';

  @override
  String nutritionHydrationValue(double current, double total) {
    return '${current}L / ${total}L';
  }

  @override
  String nutritionHydrationInfo(int altitude, int pct) {
    return 'A ${altitude}m tu necesidad de hidratación aumenta un $pct% vs el nivel del mar';
  }

  @override
  String get profileButtonEdit => 'EDITAR PERFIL';

  @override
  String profilePremiumTitle(String name) {
    return '$name, únete a Fitnflai Premium';
  }

  @override
  String get profilePremiumDesc =>
      'Desbloquea tu plan completo y alcanza todo tu potencial.';

  @override
  String get profilePremiumSubscribe => 'SUSCRIBIRSE';

  @override
  String get profilePremiumRestore => 'RESTAURAR';

  @override
  String get profilePlanActiveHeader => 'PLAN ACTIVO';

  @override
  String profilePlanActiveProgress(int completed, int total) {
    return '$completed / $total sesiones';
  }

  @override
  String profileJoinDate(String month, int year) {
    return 'Se unió en: $month $year';
  }

  @override
  String get profileSectionMyStuff => 'MIS COSAS';

  @override
  String get profileMenuConnectedApps => 'Apps y dispositivos conectados';

  @override
  String get profileMenuPersonalInfo => 'Información personal';

  @override
  String get profileMenuNotifications => 'Notificaciones';

  @override
  String get profileMenuWeeklyReport => 'Configurar reporte semanal';

  @override
  String get profileSectionPreferences => 'MIS PREFERENCIAS';

  @override
  String get profileMenuGeneral => 'General';

  @override
  String get profileMenuMyPlan => 'Mi plan';

  @override
  String get profileMenuMyTests => 'Mis tests';

  @override
  String get profileMenuPeriodicEval => 'Evaluación periódica';

  @override
  String get profileSectionAccount => 'CUENTA';

  @override
  String get profileMenuDeleteAccount => 'Eliminar cuenta';

  @override
  String get profileButtonLogout => 'Cerrar sesión';

  @override
  String get profileConfirmDeleteTitle => '¿Eliminar cuenta?';

  @override
  String get profileConfirmDeleteDesc =>
      'Esta acción es irreversible. Se eliminarán todos tus datos, plan e historial.';

  @override
  String get profileConfirmDeleteCancel => 'Cancelar';

  @override
  String get profileConfirmDeleteConfirm => 'Eliminar';

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get editProfileChangePhoto => 'Cambiar foto de perfil';

  @override
  String get editProfileTakePhoto => 'Tomar foto';

  @override
  String get editProfileChooseGallery => 'Elegir de la galería';

  @override
  String get editProfileDeletePhoto => 'Eliminar foto';

  @override
  String get editProfileSuccess => 'Perfil actualizado';

  @override
  String get editProfileError => 'Error al guardar. Intenta de nuevo.';

  @override
  String get editProfileTapToChange => 'Toca para cambiar foto';

  @override
  String get editProfileUsername => 'Nombre de usuario';

  @override
  String get editProfileUsernameHint => '@usuario';

  @override
  String get editProfileUsernameError => 'Ingresa un nombre de usuario';

  @override
  String get editProfileEmail => 'Correo electrónico';

  @override
  String get editProfileEmailHint => 'correo@ejemplo.com';

  @override
  String get editProfileEmailEmpty => 'Ingresa tu correo';

  @override
  String get editProfileEmailInvalid => 'Correo inválido';

  @override
  String get editProfileCity => 'Ciudad';

  @override
  String get editProfileCitySearchHint => 'Busca tu ciudad...';

  @override
  String get editProfileAltitude => 'Altitud (m.s.n.m.)';

  @override
  String get editProfileAltitudeHint => 'Se detecta al seleccionar ciudad';

  @override
  String get editProfileMembership => 'Membresía';

  @override
  String get editProfileMembershipPlan => 'Plan Essential';

  @override
  String get editProfileMembershipDays => '21 días gratis activos';

  @override
  String get editProfileMembershipChange => 'Cambiar';

  @override
  String get editProfileSaving => 'Guardando...';

  @override
  String get editProfileSave => 'Guardar cambios';

  @override
  String get trainingSettingsTitle => 'Plan';

  @override
  String get trainingSettingsSmartAdaptations => 'ADAPTACIONES INTELIGENTES';

  @override
  String get trainingSettingsSmartAltitude => 'Altitud inteligente';

  @override
  String get trainingSettingsSmartAltitudeDesc =>
      'Ajusta zonas FC e hidratación según tu altitud';

  @override
  String get trainingSettingsInjuryAlerts => 'Alertas de lesión';

  @override
  String get trainingSettingsInjuryAlertsDesc =>
      'Avisa cuando hay riesgo de sobreentrenamiento';

  @override
  String get trainingSettingsPlanPrefs => 'PREFERENCIAS DE PLAN';

  @override
  String get trainingSettingsDiscipline => 'Disciplina';

  @override
  String get trainingSettingsDifficulty => 'Nivel de dificultad';

  @override
  String get trainingSettingsTimePerSession => 'Tiempo por sesión';

  @override
  String trainingSettingsMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get trainingSettingsTrainingDays => 'DÍAS DE ENTRENAMIENTO';

  @override
  String get trainingSettingsSelectDays => 'Selecciona los días que entrenas';

  @override
  String get trainingSettingsCompetitions => 'COMPETENCIAS Y EVENTOS';

  @override
  String get trainingSettingsMyCompetitions => 'Mis competencias y eventos';

  @override
  String get trainingSettingsSaved => 'Preferencias guardadas';

  @override
  String get difficultyEasy => 'Suave';

  @override
  String get difficultyModerate => 'Moderado';

  @override
  String get difficultyChallenging => 'Exigente';

  @override
  String get difficultyCompetitive => 'Competitivo';

  @override
  String get weekdayMon => 'Lun';

  @override
  String get weekdayTue => 'Mar';

  @override
  String get weekdayWed => 'Mié';

  @override
  String get weekdayThu => 'Jue';

  @override
  String get weekdayFri => 'Vie';

  @override
  String get weekdaySat => 'Sáb';

  @override
  String get weekdaySun => 'Dom';

  @override
  String get supportTitle => 'Soporte';

  @override
  String get supportHelpHeader => '¿En qué podemos ayudarte?';

  @override
  String get supportHelpSub =>
      'Estamos aquí para ayudarte a sacar el máximo provecho de tu entrenamiento.';

  @override
  String get supportContact => 'CONTACTO';

  @override
  String get supportLiveChat => 'Chat en vivo';

  @override
  String get supportLiveChatSub => 'Respuesta en menos de 2 horas';

  @override
  String get supportAvailable => 'Disponible';

  @override
  String get supportEmail => 'Correo electrónico';

  @override
  String get supportHelpCenter => 'Centro de ayuda';

  @override
  String get supportHelpCenterSub => 'Guías y tutoriales detallados';

  @override
  String get supportFaqs => 'PREGUNTAS FRECUENTES';

  @override
  String get supportFollowUs => 'SÍGUENOS';

  @override
  String supportVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get supportFaqQ1 => '¿Cómo funciona el plan de entrenamiento?';

  @override
  String get supportFaqA1 =>
      'Fitnflai analiza tu perfil, historial, tests funcionales y objetivos para generar un plan personalizado semana a semana. El plan se ajusta automáticamente según tu progreso y feedback diario.';

  @override
  String get supportFaqQ2 => '¿Puedo cambiar mis días de entrenamiento?';

  @override
  String get supportFaqA2 =>
      'Sí. Ve a Perfil → Mi plan → Días de entrenamiento y selecciona los días que mejor se adapten a tu semana. El plan se reorganizará automáticamente.';

  @override
  String get supportFaqQ3 => '¿Qué pasa si me salto un entrenamiento?';

  @override
  String get supportFaqA3 =>
      'No hay problema. Fitnflai detecta la sesión perdida y ajusta la carga de la semana para no comprometer tu progreso. Puedes marcar la razón en el check-in diario.';

  @override
  String get supportFaqQ4 => '¿Cómo conecto mi Garmin o Strava?';

  @override
  String get supportFaqA4 =>
      'Ve a Perfil → Apps y dispositivos. Desde ahí puedes conectar Garmin, Strava o tu app de salud. Una vez conectado, los datos de tus actividades se sincronizan automáticamente.';

  @override
  String get supportFaqQ5 => '¿Puedo usar Fitnflai sin dispositivo wearable?';

  @override
  String get supportFaqA5 =>
      'Sí, completamente. El wearable enriquece el plan con datos en tiempo real, pero no es obligatorio. Puedes ingresar tu estado manualmente a través del check-in diario.';

  @override
  String get supportFaqQ6 => '¿Cómo cancelo mi suscripción?';

  @override
  String get supportFaqA6 =>
      'Puedes cancelar desde la tienda donde te suscribiste (App Store o Google Play). Tu plan activo continuará hasta el final del período facturado.';

  @override
  String get connectedAppsTitle => 'Apps y dispositivos';

  @override
  String get connectedAppsDesc =>
      'Sigue tus entrenamientos en dispositivos compatibles y sincroniza las sesiones completadas con tus aplicaciones favoritas.';

  @override
  String get connectedAppsSectionApps => 'APLICACIONES';

  @override
  String get connectedAppsConnected => 'Conectado';

  @override
  String get connectedAppsSectionCalendars => 'CALENDARIOS';

  @override
  String get connectedAppsConnectCalendar => 'Conectar un calendario';

  @override
  String get connectedAppsCalendarDesc =>
      'Sincroniza tus entrenamientos con Google Calendar, Apple Calendar u otros.';

  @override
  String get connectedAppsSectionWearables => 'WEARABLE DEVICES';

  @override
  String get connectedAppsConnectWearable =>
      'Conectar otro dispositivo wearable';

  @override
  String connectedAppsDisconnectTitle(String name) {
    return 'Desconectar $name';
  }

  @override
  String connectedAppsDisconnectDesc(String name) {
    return '¿Seguro que quieres desconectar $name?';
  }

  @override
  String get connectedAppsCancel => 'Cancelar';

  @override
  String get connectedAppsDisconnect => 'Desconectar';

  @override
  String connectedAppsDisconnectedToast(String name) {
    return '$name desconectado';
  }

  @override
  String connectedAppsConnectedToast(String name) {
    return '$name conectado';
  }

  @override
  String get connectedAppsActionPrompt => '¿Qué deseas hacer?';

  @override
  String get connectedAppsSync => 'Sincronizar';

  @override
  String get connectedAppsStravaSynced => 'Strava sincronizado';

  @override
  String get connectedAppsStravaSyncError => 'Error al sincronizar';

  @override
  String connectedAppsComingSoon(String feature) {
    return '$feature — próximamente';
  }

  @override
  String get connectedAppsNullUserError =>
      'No se pudo cargar la información de usuario. Por favor reintentá.';

  @override
  String get connectedAppsStravaSyncPrompt =>
      '¿Deseas sincronizar todos tus entrenamientos?';

  @override
  String get connectedAppsAccept => 'Aceptar';

  @override
  String get connectedAppsSkip => 'Omitir';

  @override
  String get competitionsTitle => 'Competencias y eventos';

  @override
  String get competitionsAddEvent => 'Agregar evento';

  @override
  String get competitionsEditEvent => 'Editar evento';

  @override
  String get competitionsFieldName => 'Nombre del evento';

  @override
  String get competitionsFieldNameHint => 'Ej: Maratón de Bogotá 2026';

  @override
  String get competitionsFieldType => 'Tipo de evento';

  @override
  String get competitionsFieldLocation => 'Lugar (opcional)';

  @override
  String get competitionsFieldLocationHint => 'Ciudad o sede del evento';

  @override
  String get competitionsFieldDate => 'Fecha del evento';

  @override
  String get competitionsSelectDate => 'Seleccionar fecha';

  @override
  String get competitionsSaveButton => 'Guardar cambios';

  @override
  String get competitionsDeleteTitle => '¿Eliminar evento?';

  @override
  String competitionsDeleteDesc(String name) {
    return '¿Seguro que quieres eliminar \"$name\"?';
  }

  @override
  String get competitionsCancel => 'Cancelar';

  @override
  String get competitionsDelete => 'Eliminar';

  @override
  String get shortMonths => 'ene,feb,mar,abr,may,jun,jul,ago,sep,oct,nov,dic';

  @override
  String get competitionsStatusPast => 'Pasado';

  @override
  String get competitionsStatusToday => '¡Hoy!';

  @override
  String competitionsStatusDays(int days) {
    return '$days días';
  }

  @override
  String get competitionsType5k => 'Carrera 5K';

  @override
  String get competitionsType10k => 'Carrera 10K';

  @override
  String get competitionsTypeHalfMarathon => 'Media Maratón';

  @override
  String get competitionsTypeMarathon => 'Maratón';

  @override
  String get competitionsTypeTrail => 'Trail';

  @override
  String get competitionsTypeTriathlon => 'Triatlón';

  @override
  String get competitionsTypeCycling => 'Ciclismo';

  @override
  String get competitionsTypeSwimming => 'Natación';

  @override
  String get competitionsTypeOther => 'Otro';

  @override
  String get competitionsEmptyTitle => 'Sin competencias aún';

  @override
  String get competitionsEmptyDesc =>
      'Agrega las carreras, triatlones o eventos en los que planeas participar. Tu plan se adaptará a tus fechas.';

  @override
  String get competitionsAddFirst => 'Agregar primer evento';

  @override
  String get periodicEvalTitle => 'Test periódico';

  @override
  String get periodicEvalBanner =>
      'Registra tu peso y altura cada semana. Estos datos ayudan a Fitnflai a calcular tu IMC, zonas de esfuerzo y mantener tu plan siempre actualizado.';

  @override
  String get periodicEvalMetrics => 'Medidas corporales';

  @override
  String get periodicEvalWeight => 'Peso actual';

  @override
  String get periodicEvalHeight => 'Altura';

  @override
  String get periodicEvalCompTitle => '¿Tienes datos de\ncomposición corporal?';

  @override
  String get periodicEvalCompDesc =>
      'Si tienes una balanza inteligente o informe de bioimpedancia, Fitnflai extrae los datos automáticamente para personalizar mejor tu plan.';

  @override
  String get periodicEvalUploadTitle => 'Subir informe';

  @override
  String get periodicEvalOptional => 'Opcional';

  @override
  String get periodicEvalUploadHint => 'Sube el informe de tu balanza';

  @override
  String get periodicEvalUploadDesc =>
      'Fitnflai extrae % grasa, músculo, agua corporal y TMB para calibrar mejor tu plan.';

  @override
  String get periodicEvalUploadPhoto => 'Subir foto';

  @override
  String get periodicEvalUploadPdf => 'Subir PDF';

  @override
  String get periodicEvalSave => 'Guardar';

  @override
  String get myTestsTitle => 'Mis tests';

  @override
  String get myTestsBannerTitle => 'Tests periódicos = plan más preciso';

  @override
  String get myTestsBannerDesc =>
      'Realiza cada test cada 30 días para que Fitnflai ajuste tu plan a tu nivel real.';

  @override
  String get myTestsSection => 'TUS TESTS';

  @override
  String get myTestsSquatsName => 'Sentadillas 1 min';

  @override
  String get myTestsSquatsCategory => 'Fuerza tren inferior';

  @override
  String get myTestsCooperName => 'Test de Cooper';

  @override
  String get myTestsCooperCategory => 'Resistencia cardiovascular';

  @override
  String get myTestsPushupsName => 'Flexiones 1 min';

  @override
  String get myTestsPushupsCategory => 'Fuerza tren superior';

  @override
  String get myTestsPlankName => 'Plancha abdominal';

  @override
  String get myTestsPlankCategory => 'Core / Estabilidad';

  @override
  String get myTestsFlexName => 'Inclinación hacia adelante';

  @override
  String get myTestsFlexCategory => 'Flexibilidad';

  @override
  String get myTestsStatusPending => 'Pendiente';

  @override
  String get myTestsStatusRepeat => 'Repetir';

  @override
  String myTestsStatusDays(int days) {
    return 'En $days días';
  }

  @override
  String myTestsLastTime(String date) {
    return 'Última vez: $date';
  }

  @override
  String get myTestsBtnRetake => 'Realizar de nuevo';

  @override
  String get myTestsBtnStart => 'Hacer test';

  @override
  String get notificationsSettingsTitle => 'Notificaciones';

  @override
  String get notificationsSettingsIntensityHeader => 'INTENSIDAD GENERAL';

  @override
  String get notificationsSettingsIntensityLabel =>
      'Frecuencia de notificaciones';

  @override
  String get notificationsSettingsIntensityDesc =>
      'Controla cuántas notificaciones recibes en total';

  @override
  String get notificationsIntensityLow => 'Baja';

  @override
  String get notificationsIntensityMedium => 'Media';

  @override
  String get notificationsIntensityHigh => 'Alta';

  @override
  String get notificationsSettingsTypesHeader => 'TIPOS DE NOTIFICACIÓN';

  @override
  String get notificationsSettingsWorkoutsLabel => 'Entrenamientos';

  @override
  String get notificationsSettingsWorkoutsDesc =>
      'Recordatorio de tu sesión diaria';

  @override
  String get notificationsSettingsRemindersLabel => 'Recordatorios';

  @override
  String get notificationsSettingsRemindersDesc =>
      'Avisos antes de tu sesión programada';

  @override
  String get notificationsSettingsProgressLabel => 'Progreso semanal';

  @override
  String get notificationsSettingsProgressDesc =>
      'Resumen de tu avance cada semana';

  @override
  String get notificationsSettingsNutritionLabel => 'Nutrición e hidratación';

  @override
  String get notificationsSettingsNutritionDesc =>
      'Recordatorios de comidas y agua';

  @override
  String get notificationsSettingsOffersLabel => 'Ofertas y novedades';

  @override
  String get notificationsSettingsOffersDesc =>
      'Noticias y promociones de Fitnflai';

  @override
  String get notificationsSettingsSaving => 'Guardando...';

  @override
  String get notificationsSettingsSave => 'Guardar';

  @override
  String get notificationsSettingsSaveSuccess => 'Notificaciones guardadas';

  @override
  String get notificationsSettingsSaveError =>
      'Error al guardar. Intenta de nuevo.';

  @override
  String get notificationsPanelTitle => 'Notificaciones';

  @override
  String get notificationsPanelMarkAll => 'Marcar todas';

  @override
  String get notificationsPanelEmptyTitle => 'Sin notificaciones';

  @override
  String get notificationsPanelEmptyDesc =>
      'Aquí aparecerán tus alertas y novedades.';

  @override
  String get timeAgoJustNow => 'Hace un momento';

  @override
  String timeAgoMinutes(int minutes) {
    return 'Hace $minutes min';
  }

  @override
  String timeAgoHours(int hours) {
    return 'Hace ${hours}h';
  }

  @override
  String timeAgoDays(int days) {
    return 'Hace $days día';
  }

  @override
  String timeAgoDaysPlural(int days) {
    return 'Hace $days días';
  }

  @override
  String dailyCheckinGreeting(String name) {
    return 'Buenos días, $name 👋';
  }

  @override
  String get dailyCheckinSubtitle => 'Martes · Sesión de hoy: Carrera Zona 2';

  @override
  String get dailyCheckinHeaderDesc =>
      'Responde 4 preguntas rápidas para que la IA ajuste tu sesión de hoy.';

  @override
  String dailyCheckinQuestionLabel(int index, String label) {
    return 'Pregunta $index · $label';
  }

  @override
  String get dailyCheckinLabelSleep => 'Sueño';

  @override
  String get dailyCheckinLabelEnergy => 'Energía';

  @override
  String get dailyCheckinLabelPain => 'Dolor o molestia';

  @override
  String get dailyCheckinLabelTime => 'Tiempo disponible';

  @override
  String get dailyCheckinQuestionSleep => '¿Cómo dormiste anoche?';

  @override
  String get dailyCheckinQuestionEnergy => '¿Cómo está tu energía ahora mismo?';

  @override
  String get dailyCheckinQuestionPain => '¿Tienes algún dolor o molestia hoy?';

  @override
  String get dailyCheckinQuestionTime =>
      '¿Cuánto tiempo tienes para entrenar hoy?';

  @override
  String get dailyCheckinPainNo => '✓ No, estoy bien';

  @override
  String get dailyCheckinPainYes => 'Sí, algo';

  @override
  String get dailyCheckinPainWhere => '¿Dónde?';

  @override
  String get dailyCheckinPainDetailsHint => 'Detalles adicionales (opcional)';

  @override
  String get dailyCheckinBtnResult => 'Ver mi sesión ajustada →';

  @override
  String get dailyCheckinBtnAnswerAll => 'Responde todas las preguntas';

  @override
  String dailyCheckinProgressStatus(int answered, int total) {
    return '$answered de $total respondidas';
  }

  @override
  String get dailyCheckinScoreSleep => 'Sueño';

  @override
  String get dailyCheckinScoreEnergy => 'Energía';

  @override
  String get dailyCheckinScorePain => 'Dolor';

  @override
  String get dailyCheckinScoreTime => 'Tiempo';

  @override
  String get dailyCheckinPainValueNo => 'No';

  @override
  String get dailyCheckinPainValueMild => 'Leve';

  @override
  String get dailyCheckinSemaforoGreenTitle =>
      '¡Hoy estás para entrenar fuerte!';

  @override
  String get dailyCheckinSemaforoGreenDesc =>
      'Dormiste bien, tienes energía y no hay molestias. Condiciones perfectas para tu sesión de carrera.';

  @override
  String get dailyCheckinSemaforoGreenBadge =>
      '✓ Sesión completa · sin cambios';

  @override
  String get dailyCheckinSemaforoYellowTitle =>
      'Hoy no estás al 100% — la IA ajustó tu sesión';

  @override
  String get dailyCheckinSemaforoYellowDesc =>
      'Dormiste poco y la energía está baja. Puedes entrenar, pero con menos carga. Tu plan no se ve afectado.';

  @override
  String get dailyCheckinSemaforoYellowBadge => '⚡ Ajustada';

  @override
  String get dailyCheckinSemaforoRedTitle => 'Hoy el cuerpo necesita descanso';

  @override
  String get dailyCheckinSemaforoRedDesc =>
      'Sueño muy bajo, sin energía y dolor fuerte. Entrenar hoy aumenta el riesgo de lesión.';

  @override
  String get dailyCheckinSemaforoRedBadge => '↔ Alternativa';

  @override
  String get dailyCheckinSessionTitleGreen => 'Carrera base · Zona 2';

  @override
  String get dailyCheckinSessionSubGreen => 'Martes · Semana 3 de 18';

  @override
  String get dailyCheckinSessionTitleYellow =>
      'Carrera base · Zona 2 · Reducida';

  @override
  String get dailyCheckinSessionSubYellow =>
      'Versión ajustada por la IA para hoy';

  @override
  String get dailyCheckinSessionTitleRed => 'Movilidad y respiración';

  @override
  String get dailyCheckinSessionSubRed =>
      'Alternativa recomendada · Descanso activo';

  @override
  String get dailyCheckinSessionChangeTitle => '¿Qué cambió la IA?';

  @override
  String get dailyCheckinSessionChangeDesc =>
      'Duración reducida. FC objetivo más baja. El volumen perdido hoy se redistribuye en el jueves.';

  @override
  String get dailyCheckinSessionReducePct => '−30% intensidad';

  @override
  String get dailyCheckinSessionNoFc => 'Sin FC objetivo';

  @override
  String get dailyCheckinPainAlertUrgent => 'Dolor fuerte · Acción recomendada';

  @override
  String dailyCheckinPainAlertNormal(String zone) {
    return 'Molestia registrada · $zone';
  }

  @override
  String get dailyCheckinPainAlertUrgentDesc =>
      'Reportaste dolor fuerte. Si lleva más de 2 días, considera consultar con un especialista deportivo.';

  @override
  String get dailyCheckinPainAlertNormalDesc =>
      'La IA eliminó los ejercicios de impacto alto. Si la molestia persiste mañana, activa el protocolo de lesión.';

  @override
  String get dailyCheckinInsightTitle => 'La IA dice';

  @override
  String get dailyCheckinInsightGreen =>
      'Con buen sueño y energía alta, esta es una sesión ideal para trabajar tu base aeróbica. Mantén la FC por debajo de 130 lpm. Hidratación: 500ml antes de salir.';

  @override
  String get dailyCheckinInsightYellow =>
      'Dormir mal eleva el cortisol y reduce la capacidad de recuperación muscular. Hoy no es día de forzar — 35 minutos suaves te mantienen activo sin arriesgar.';

  @override
  String get dailyCheckinInsightRed =>
      'Un día de descanso hoy no arruina tus 18 semanas — las arruina ignorar las señales del cuerpo. La sesión de carrera se mueve al jueves.';

  @override
  String get dailyCheckinCtaGreen => '¡Vamos! Iniciar sesión →';

  @override
  String get dailyCheckinCtaYellow => 'Entrenar la versión ajustada';

  @override
  String get dailyCheckinCtaRed => 'Hacer los 20 min de movilidad';

  @override
  String get dailyCheckinCtaRestRed => 'Descanso total hoy · No entrenar';

  @override
  String get dailyCheckinCtaRestNormal =>
      'Descansar hoy · marcar como día libre';

  @override
  String get dailyCheckinCtaBottomNote =>
      'Tu plan se ajusta automáticamente · Sigues en track';

  @override
  String get dailyCheckinSaveSuccess => 'Estado diario registrado con éxito.';

  @override
  String dailyCheckinSaveError(String error) {
    return 'Error de conexión o al registrar estado: $error';
  }

  @override
  String get workoutDetailTitle => 'Detalle del entrenamiento';

  @override
  String get workoutDetailObj => 'Objetivo';

  @override
  String get workoutDetailCal => 'Calentamiento';

  @override
  String get workoutDetailDes => 'Vuelta a la calma';

  @override
  String get workoutDetailPrinc => 'Bloque principal';

  @override
  String get workoutDetailInt => 'Intervalos';

  @override
  String get workoutDetailMealPre => 'Comida pre-entreno';

  @override
  String get workoutDetailMealPost => 'Comida post-entreno';

  @override
  String get workoutDetailStart => 'Comenzar entrenamiento';

  @override
  String workoutDetailDuration(int minutes) {
    return '$minutes min';
  }

  @override
  String get workoutActiveTitle => 'Entrenamiento activo';

  @override
  String get workoutActiveTimer => 'Tiempo';

  @override
  String get workoutActivePace => 'Ritmo';

  @override
  String get workoutActiveHr => 'Frecuencia Cardíaca';

  @override
  String get workoutActiveDist => 'Distancia';

  @override
  String get workoutActivePause => 'Pausar';

  @override
  String get workoutActiveResume => 'Reanudar';

  @override
  String get workoutActiveFinish => 'Finalizar';

  @override
  String get workoutActiveCancel => 'Cancelar';

  @override
  String get workoutActiveConfirmFinishTitle => '¿Finalizar entrenamiento?';

  @override
  String get workoutActiveConfirmFinishDesc =>
      '¿Seguro que quieres finalizar esta sesión?';

  @override
  String get workoutFeedbackTitle => 'Feedback del entrenamiento';

  @override
  String get workoutFeedbackFeelingQuestion => '¿Cómo te sentiste?';

  @override
  String get workoutFeedbackRpeQuestion => 'Esfuerzo percibido (RPE)';

  @override
  String get workoutFeedbackRpe1 => 'Muy suave';

  @override
  String get workoutFeedbackRpe2 => 'Suave';

  @override
  String get workoutFeedbackRpe3 => 'Moderado';

  @override
  String get workoutFeedbackRpe4 => 'Duro';

  @override
  String get workoutFeedbackRpe5 => 'Esfuerzo máximo';

  @override
  String get workoutFeedbackFeeling1 => 'Agotado';

  @override
  String get workoutFeedbackFeeling2 => 'Cansado';

  @override
  String get workoutFeedbackFeeling3 => 'Bien';

  @override
  String get workoutFeedbackFeeling4 => 'Fuerte';

  @override
  String get workoutFeedbackFeeling5 => 'Invencible';

  @override
  String get workoutFeedbackPainQuestion => '¿Sentiste algún dolor?';

  @override
  String get workoutFeedbackSubmit => 'Enviar feedback';

  @override
  String get dailyCheckinSleepOpt1 => 'Muy mal';

  @override
  String get dailyCheckinSleepOpt2 => 'Mal';

  @override
  String get dailyCheckinSleepOpt3 => 'Regular';

  @override
  String get dailyCheckinSleepOpt4 => 'Bien';

  @override
  String get dailyCheckinSleepOpt5 => 'Muy bien';

  @override
  String get dailyCheckinEnergyOpt1 => 'Sin energía';

  @override
  String get dailyCheckinEnergyOpt2 => 'Baja';

  @override
  String get dailyCheckinEnergyOpt3 => 'Normal';

  @override
  String get dailyCheckinEnergyOpt4 => 'Alta';

  @override
  String get dailyCheckinEnergyOpt5 => 'Al máximo';

  @override
  String get dailyCheckinTimeOpt1 => 'justo';

  @override
  String get dailyCheckinTimeOpt2 => 'normal';

  @override
  String get dailyCheckinTimeOpt3 => 'bien';

  @override
  String get dailyCheckinTimeOpt4 => 'holgado';

  @override
  String get dailyCheckinTimeOpt5 => 'completo';

  @override
  String get painZoneCuello => 'Cuello';

  @override
  String get painZoneHombro => 'Hombro';

  @override
  String get painZoneEspaldaAlta => 'Espalda alta';

  @override
  String get painZoneLumbar => 'Lumbar';

  @override
  String get painZoneCadera => 'Cadera';

  @override
  String get painZoneRodilla => 'Rodilla';

  @override
  String get painZoneTobillo => 'Tobillo';

  @override
  String get painZoneOtro => 'Otro';

  @override
  String get workoutDetailDesc => 'Descripción';

  @override
  String get workoutDetailNotes => 'Notas';

  @override
  String get workoutDetailNutrition => 'Nutrición';

  @override
  String get workoutDetailDurationTitle => 'Duración';

  @override
  String get workoutDetailExercises => 'Ejercicios';

  @override
  String get workoutDetailNoExercises => 'No hay ejercicios disponibles';

  @override
  String get workoutDetailDayNutrition => 'Nutrición del día';

  @override
  String get workoutDetailCompleted => 'Completado';

  @override
  String get workoutDetailCompletedBanner => '¡Entrenamiento completado!';

  @override
  String get mealBreakfast => 'DESAYUNO';

  @override
  String get mealLunch => 'ALMUERZO';

  @override
  String get mealDinner => 'CENA';

  @override
  String get mealPreWorkout => 'PRE-ENTRENO · 30-60 MIN ANTES';

  @override
  String get mealPostWorkout => 'POST-ENTRENO · +30 MIN DESPUÉS';

  @override
  String get mealSnack => 'SNACK';

  @override
  String get mealDuring => 'DURANTE · SI +60 MIN';

  @override
  String statsSeriesCount(int count) {
    return '$count series';
  }

  @override
  String statsRepsCount(int count) {
    return '$count reps';
  }

  @override
  String statsMinCount(int count) {
    return '$count min';
  }

  @override
  String get workoutActiveExterior => 'Exterior';

  @override
  String get workoutActiveInterior => 'Interior';

  @override
  String get workoutActiveExitTitle => '¿Salir del entrenamiento?';

  @override
  String get workoutActiveExitDesc => 'El progreso se perderá.';

  @override
  String get workoutActiveExitContinue => 'Continuar';

  @override
  String get workoutActiveExitBtn => 'Salir';

  @override
  String get workoutActiveExercises => 'Ejercicios';

  @override
  String get workoutActiveNow => 'AHORA';

  @override
  String get workoutActiveModeQuestion =>
      'Este ejercicio puede realizarse en exterior o interior.\n¿Dónde lo harás?';

  @override
  String get workoutActiveSets => 'SERIES';

  @override
  String get workoutActiveReps => 'REPS';

  @override
  String get workoutActiveSpeed => 'VELOCIDAD';

  @override
  String workoutActiveSetLabel(int number) {
    return 'Serie $number';
  }

  @override
  String get workoutActivePosInicial => 'Posición Inicial';

  @override
  String get workoutActiveEjecucion => 'Ejecución';

  @override
  String get workoutActiveConsejos => 'Consejos Técnicos';

  @override
  String get workoutActiveNoPreview => 'Vista previa no disponible';

  @override
  String get workoutActiveStartBtn => 'Iniciar entrenamiento';

  @override
  String get workoutActiveCompleted => 'Completado';

  @override
  String get workoutActiveCompleteSets => 'Completa las series';

  @override
  String get workoutActiveMarkDone => 'Marcar hecho';

  @override
  String get workoutActiveNext => 'Siguiente';

  @override
  String get workoutActiveTapFinish => 'Toca  🏁  para terminar';

  @override
  String get workoutActiveHoldFinish => 'Mantén pulsado  🏁  para terminar';

  @override
  String get workoutFeedbackQuestion => '¿Cómo fue el entrenamiento?';

  @override
  String get workoutFeedbackFinished => '¡Rutina finalizada!';

  @override
  String get workoutFeedbackTime => 'TIEMPO';

  @override
  String get workoutFeedbackDistance => 'DISTANCIA';

  @override
  String get workoutFeedbackMode => 'MODO';

  @override
  String get workoutFeedbackOutdoor => '🌤 Exterior';

  @override
  String get workoutFeedbackIndoor => '🏠 Interior';

  @override
  String get workoutFeedbackDidComplete => '¿Completaste la rutina?';

  @override
  String get workoutFeedbackYesComplete => 'Sí, completa';

  @override
  String get workoutFeedbackPartially => 'Parcialmente';

  @override
  String get workoutFeedbackEasy => 'Fácil';

  @override
  String get workoutFeedbackMax => 'Máximo';

  @override
  String get workoutFeedbackRpeEasy => 'Muy fácil';

  @override
  String get workoutFeedbackRpeModerate => 'Moderado';

  @override
  String get workoutFeedbackRpeSomewhatHard => 'Algo difícil';

  @override
  String get workoutFeedbackRpeHard => 'Difícil';

  @override
  String get workoutFeedbackRpeMax => 'Máximo esfuerzo';

  @override
  String get workoutFeedbackFeelingVeryTired => 'Muy cansado';

  @override
  String get workoutFeedbackFeelingTired => 'Cansado';

  @override
  String get workoutFeedbackFeelingGood => 'Bien';

  @override
  String get workoutFeedbackFeelingGreat => 'Sobrado';

  @override
  String get workoutFeedbackYesPain => 'Sí, algo';

  @override
  String get workoutFeedbackNoPain => 'No, ninguno';

  @override
  String get workoutFeedbackPainHint => 'Zona del cuerpo, tipo de dolor...';

  @override
  String get workoutFeedbackAdditionalNotes => 'Notas adicionales';

  @override
  String get workoutFeedbackOptional => 'Opcional';

  @override
  String get workoutFeedbackNotesHint =>
      'Ej: las últimas series costaron más, sentí las piernas pesadas...';

  @override
  String get workoutFeedbackSaveFinish => 'Guardar y terminar';

  @override
  String get workoutFeedbackAnswerAll =>
      'Responde todas las preguntas para continuar';

  @override
  String get parqQuestion1 =>
      '¿Alguna vez un médico te ha dicho que tienes una condición cardíaca y que solo debes hacer actividad física bajo supervisión médica?';

  @override
  String get parqShortLabel1 =>
      'Pregunta 1 — Condición cardíaca diagnosticada.';

  @override
  String get parqQuestion2 =>
      '¿Sientes dolor en el pecho cuando realizas actividad física?';

  @override
  String get parqShortLabel2 =>
      'Pregunta 2 — Dolor en el pecho durante actividad física.';

  @override
  String get parqQuestion3 =>
      'En el último mes, ¿has sentido dolor en el pecho en reposo?';

  @override
  String get parqShortLabel3 => 'Pregunta 3 — Dolor en el pecho en reposo.';

  @override
  String get parqQuestion4 =>
      '¿Pierdes el equilibrio por mareos o has perdido el conocimiento durante o después de ejercicio?';

  @override
  String get parqShortLabel4 =>
      'Pregunta 4 — Mareos o pérdida de conocimiento.';

  @override
  String get parqQuestion5 =>
      '¿Tienes algún problema óseo o articular que pueda empeorar con la actividad física?';

  @override
  String get parqShortLabel5 => 'Pregunta 5 — Problema óseo o articular.';

  @override
  String get parqQuestion6 =>
      '¿Un médico te receta medicamentos para la presión arterial o condición cardíaca?';

  @override
  String get parqShortLabel6 =>
      'Pregunta 6 — Medicación para presión o corazón.';

  @override
  String get parqQuestion7 =>
      '¿Conoces alguna otra razón por la que no deberías realizar actividad física ahora?';

  @override
  String get parqShortLabel7 => 'Pregunta 7 — Otra razón médica.';

  @override
  String onboardingStepLabel(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String onboardingTestSelectionCompletedCount(int completed, int total) {
    return '$completed/$total completados';
  }

  @override
  String get onboardingTestSelectionCompletedTitle =>
      '¿Deseas hacer más tests?';

  @override
  String get onboardingTestSelectionTitle => 'Batería de tests funcionales';

  @override
  String get onboardingTestSelectionCompletedDesc =>
      'Cada test adicional hace tu plan más preciso.';

  @override
  String get onboardingTestSelectionDesc =>
      'Evaluamos tu condición física real. Solo toma 20–30 min.';

  @override
  String get onboardingTestSelectionObligatory => 'Obligatorio';

  @override
  String get onboardingTestSelectionCompletedBadge => '✅ Completado';

  @override
  String get onboardingTestSelectionCompletedInfo =>
      'Puedes hacer los tests restantes ahora o más adelante desde \"Mis tests\" en tu perfil.';

  @override
  String get onboardingTestSelectionInfo =>
      'El test de sentadillas es obligatorio. Los demás enriquecen tu perfil y hacen el plan más preciso.';

  @override
  String onboardingTestSelectionStartBtn(String title) {
    return 'Empezar: $title';
  }

  @override
  String get onboardingTestSelectionContinueToPlan => 'Continuar al plan →';

  @override
  String get onboardingTestSelectionContinueWithoutTests =>
      'Continuar sin hacer más tests →';

  @override
  String get onboardingTestInstructionTabInstruction => 'Instrucción';

  @override
  String get onboardingTestInstructionTabRecord => 'Registro';

  @override
  String get onboardingTestInstructionTabFeedback => 'Feedback';

  @override
  String get onboardingTestInstructionHowToTitle =>
      'Cómo hacerlo correctamente';

  @override
  String get onboardingTestInstructionErrorsTitle => 'Errores comunes a evitar';

  @override
  String get onboardingTestInstructionMeasuresTitle =>
      '¿Qué mide exactamente este test?';

  @override
  String onboardingTestInstructionGreeting(String name) {
    return 'Hola, $name';
  }

  @override
  String onboardingTestInstructionDateSubtitle(String day, int week) {
    return '$day · Semana $week';
  }

  @override
  String get testSquatsTitle => 'Sentadillas en 1 minuto';

  @override
  String get testSquatsTag => 'Fuerza de tren inferior';

  @override
  String get testSquatsDescShort =>
      'De pie, pies al ancho de hombros. Bajar hasta 90° de flexión de rodilla.';

  @override
  String get testSquatsDescLong =>
      'Cuenta cuántas sentadillas puedes hacer en 1 minuto. Mide la fuerza funcional de tus piernas y tu resistencia muscular local — uno de los mejores predictores de rendimiento deportivo.';

  @override
  String get testSquatsDurationLabel => '1 min';

  @override
  String get testSquatsStartLabel => 'Iniciar Sentadillas';

  @override
  String get testSquatsPrepHint => 'De pie, pies al ancho de hombros';

  @override
  String get testSquatsResultHint => 'Cuenta las repeticiones completas';

  @override
  String get testSquatsMeasuresDesc =>
      'Fuerza resistencia de cuádriceps, glúteos e isquiotibiales. Predice tu capacidad para mantener la postura en bici, la zancada en carrera y la potencia en cualquier disciplina deportiva.';

  @override
  String get testSquatsStep1Main =>
      'Párate con los pies al ancho de los hombros. Punta de los pies ligeramente hacia afuera (15–30°).';

  @override
  String get testSquatsStep1Tip =>
      'No es necesario calzado especial — descalzo funciona perfectamente.';

  @override
  String get testSquatsStep2Main =>
      'Baja hasta que tus muslos queden paralelos al suelo — o lo más cerca posible. Espalda recta, pecho arriba.';

  @override
  String get testSquatsStep2Tip =>
      'Si no llegas al paralelo, llega hasta donde puedas sin dolor.';

  @override
  String get testSquatsStep3Main =>
      'Sube empujando con los talones. Extiende completamente las rodillas y caderas al llegar arriba.';

  @override
  String get testSquatsStep3Tip =>
      'Cada repetición cuenta solo si llegas abajo Y arriba completamente.';

  @override
  String get testSquatsStep4Main =>
      'Repite al ritmo que puedas mantener durante los 60 segundos completos. Puedes pausar brevemente si lo necesitas.';

  @override
  String get testSquatsStep4Tip => 'El cronómetro no se detiene.';

  @override
  String get testSquatsError1 =>
      'Rodillas hacia adentro — las rodillas siempre deben seguir la dirección de los pies.';

  @override
  String get testSquatsError2 =>
      'Talones levantados — si se pasan, separa más los pies o coloca algo delgado bajo los talones.';

  @override
  String get testSquatsError3 =>
      'Espalda redondeada — mantén el pecho alto durante todo el movimiento.';

  @override
  String get testCooperTitle => 'Test de Cooper';

  @override
  String get testCooperTag => 'Resistencia cardiovascular';

  @override
  String get testCooperDescShort =>
      'Corre o camina rápido durante 12 minutos continuos. Mide la distancia en metros.';

  @override
  String get testCooperDescLong =>
      'Corre o camina rápido durante 12 minutos continuos. Mide la distancia total recorrida en metros. Es uno de los métodos más usados para estimar el VO2 Max.';

  @override
  String get testCooperDurationLabel => '12 min';

  @override
  String get testCooperStartLabel => 'Iniciar Test de Cooper';

  @override
  String get testCooperPrepHint => 'Posiciónate en tu punto de inicio';

  @override
  String get testCooperResultHint => 'Anota la distancia recorrida al terminar';

  @override
  String get testCooperMeasuresDesc =>
      'Capacidad aeróbica máxima (VO2 Max estimado). Predice tu resistencia general, recuperación entre sesiones y potencial de mejora cardiovascular.';

  @override
  String get testCooperStep1Main =>
      'Busca una pista o trayecto plano y medido — idealmente una pista de atletismo de 400m.';

  @override
  String get testCooperStep1Tip => 'Una calle plana con GPS también funciona.';

  @override
  String get testCooperStep2Main =>
      'Calienta 5 minutos caminando o trotando suave antes de iniciar el cronómetro.';

  @override
  String get testCooperStep3Main =>
      'Al dar inicio, corre o camina lo más rápido que puedas durante 12 minutos exactos.';

  @override
  String get testCooperStep3Tip =>
      'Mantén un ritmo que puedas sostener — no arranques demasiado rápido.';

  @override
  String get testCooperStep4Main =>
      'Al terminar, anota la distancia total recorrida en metros.';

  @override
  String get testCooperStep4Tip =>
      'FitnFlai calculará tu VO2 Max estimado automáticamente.';

  @override
  String get testCooperError1 =>
      'Arrancar demasiado rápido y agotarte en los primeros minutos.';

  @override
  String get testCooperError2 =>
      'Hacer pausas largas — si necesitas caminar, está bien, pero mantén el movimiento.';

  @override
  String get testCooperError3 =>
      'No medir la distancia con precisión — usa GPS o una pista conocida.';

  @override
  String get testPushupsTitle => 'Flexiones en 1 minuto';

  @override
  String get testPushupsTag => 'Fuerza de tren superior';

  @override
  String get testPushupsDescShort =>
      'Plancha completa. Bajar hasta que el pecho casi toque el suelo.';

  @override
  String get testPushupsDescLong =>
      'Cuenta cuántas flexiones completas puedes hacer en 1 minuto. Mide la fuerza y resistencia muscular de pecho, hombros y tríceps.';

  @override
  String get testPushupsDurationLabel => '1 min';

  @override
  String get testPushupsStartLabel => 'Iniciar Flexiones';

  @override
  String get testPushupsPrepHint => 'Posición de plancha, listo para empezar';

  @override
  String get testPushupsResultHint => 'Cuenta las repeticiones completas';

  @override
  String get testPushupsMeasuresDesc =>
      'Fuerza-resistencia de pecho, hombros y tríceps. Predice tu capacidad para mantener postura en bici, potencia de brazada en natación y estabilidad general.';

  @override
  String get testPushupsStep1Main =>
      'Posición de plancha completa: manos al ancho de hombros, cuerpo recto de cabeza a talones.';

  @override
  String get testPushupsStep1Tip =>
      'Rodillas en el suelo si necesitas modificar la dificultad.';

  @override
  String get testPushupsStep2Main =>
      'Baja hasta que el pecho casi toque el suelo. Codos a 45° del cuerpo — ni muy abiertos ni pegados.';

  @override
  String get testPushupsStep2Tip =>
      'Mantén el abdomen contraído durante todo el movimiento.';

  @override
  String get testPushupsStep3Main =>
      'Sube extendiendo completamente los codos. Solo cuentan las repeticiones completas: abajo Y arriba.';

  @override
  String get testPushupsStep4Main =>
      'Repite al ritmo que puedas mantener durante 60 segundos completos. Puedes pausar brevemente.';

  @override
  String get testPushupsStep4Tip =>
      'El cronómetro no se detiene aunque hagas una pausa.';

  @override
  String get testPushupsError1 =>
      'Bajar solo a la mitad — el pecho debe casi tocar el suelo.';

  @override
  String get testPushupsError2 =>
      'Caderas arriba o hacia abajo — el cuerpo debe mantenerse recto.';

  @override
  String get testPushupsError3 =>
      'Codos muy abiertos (90°) — aumenta el riesgo de lesión en hombros.';

  @override
  String get testPlankTitle => 'Plancha abdominal';

  @override
  String get testPlankTag => 'Core / Estabilidad';

  @override
  String get testPlankDescShort =>
      'Plancha sobre antebrazos y pies. Cuerpo recto. Máximo tiempo posible.';

  @override
  String get testPlankDescLong =>
      'Mantén la posición de plancha el mayor tiempo posible. Mide la resistencia del core, fundamental para la eficiencia en todos los deportes.';

  @override
  String get testPlankDurationLabel => 'Máx. tiempo';

  @override
  String get testPlankStartLabel => 'Iniciar Plancha';

  @override
  String get testPlankPrepHint => 'Posición sobre antebrazos, cuerpo recto';

  @override
  String get testPlankResultHint => 'Para el cronómetro cuando no puedas más';

  @override
  String get testPlankMeasuresDesc =>
      'Resistencia isométrica del core (abdomen, lumbar, glúteos). Predice tu postura en carrera y bici, prevención de lesiones lumbares y eficiencia de transferencia de fuerza.';

  @override
  String get testPlankStep1Main =>
      'Posición sobre antebrazos y pies: codos justo bajo los hombros, antebrazos paralelos.';

  @override
  String get testPlankStep1Tip =>
      'Puedes entrelazar las manos o mantenerlas planas.';

  @override
  String get testPlankStep2Main =>
      'Cuerpo completamente recto de cabeza a talones. Activa el abdomen como si fueras a recibir un golpe.';

  @override
  String get testPlankStep2Tip => 'No dejes que las caderas suban ni bajen.';

  @override
  String get testPlankStep3Main =>
      'Mantén la posición fija mirando hacia abajo. Respira de forma continua y controlada.';

  @override
  String get testPlankStep4Main =>
      'El test termina cuando las caderas caen, se elevan excesivamente o el cuerpo deja de estar recto.';

  @override
  String get testPlankStep4Tip =>
      'FitnFlai registra el tiempo en segundos automáticamente.';

  @override
  String get testPlankError1 =>
      'Caderas demasiado altas — el cuerpo pierde la línea recta.';

  @override
  String get testPlankError2 =>
      'Caderas hacia el suelo — compensa la debilidad del core.';

  @override
  String get testPlankError3 =>
      'Retener la respiración — respira de forma continua durante todo el test.';

  @override
  String get testPlankError4 =>
      'Codos muy alejados de los hombros — reduce la efectividad del ejercicio.';

  @override
  String get testFlexibilityTitle => 'Inclinación hacia adelante';

  @override
  String get testFlexibilityTag => 'Flexibilidad';

  @override
  String get testFlexibilityDescShort =>
      'De pie, piernas juntas. Inclinarse hacia adelante lo más posible.';

  @override
  String get testFlexibilityDescLong =>
      'Mide tu flexibilidad isquiotibial y lumbar. La flexibilidad impacta directamente en tu técnica de pedaleo, zancada y prevención de lesiones.';

  @override
  String get testFlexibilityDurationLabel => '1 intento';

  @override
  String get testFlexibilityStartLabel => 'Iniciar Flexibilidad';

  @override
  String get testFlexibilityPrepHint => 'De pie, piernas juntas y extendidas';

  @override
  String get testFlexibilityResultHint =>
      'Selecciona hasta dónde llegaron tus manos';

  @override
  String get testFlexibilityMeasuresDesc =>
      'Flexibilidad de isquiotibiales y zona lumbar. Predice tu rango de movimiento en pedaleo, eficiencia de zancada y riesgo de lesiones en espalda baja.';

  @override
  String get testFlexibilityStep1Main =>
      'De pie, junta los pies completamente. Piernas extendidas, sin doblar las rodillas en ningún momento.';

  @override
  String get testFlexibilityStep1Tip =>
      'Puedes apoyarte contra una pared para mantener el equilibrio.';

  @override
  String get testFlexibilityStep2Main =>
      'Inspira profundo. Al exhalar, inclínate lentamente hacia adelante llevando las manos hacia el suelo.';

  @override
  String get testFlexibilityStep2Tip =>
      'No hagas rebotes — el movimiento debe ser suave y controlado.';

  @override
  String get testFlexibilityStep3Main =>
      'Llega hasta donde puedas sin doblar las rodillas ni forzar. Mantén la posición 2–3 segundos.';

  @override
  String get testFlexibilityStep3Tip =>
      'FitnFlai registra hasta dónde llegan tus manos.';

  @override
  String get testFlexibilityStep4Main =>
      'Repite 2 veces y toma el mejor resultado.';

  @override
  String get testFlexibilityStep4Tip =>
      'El cuerpo se suele abrir un poco más en el segundo intento.';

  @override
  String get testFlexibilityError1 =>
      'Doblar las rodillas — anula el estiramiento isquiotibial.';

  @override
  String get testFlexibilityError2 =>
      'Hacer rebotes hacia abajo — puede causar lesión muscular.';

  @override
  String get testFlexibilityError3 =>
      'Forzar más allá del límite — debe haber tensión, no dolor.';

  @override
  String get onboardingTestTimerErrorResultEmpty =>
      'Ingresa tu resultado antes de continuar';

  @override
  String get onboardingTestTimerErrorSave =>
      'Error al guardar el resultado. Intenta de nuevo.';

  @override
  String get onboardingTestTimerErrorConnection =>
      'Error de conexión. Intenta de nuevo.';

  @override
  String get onboardingTestTimerBadgeFree => 'Libre';

  @override
  String get onboardingTestTimerStatusCompleted => 'Completado';

  @override
  String get onboardingTestTimerLabelRemaining => 'Tiempo restante';

  @override
  String get onboardingTestTimerLabelElapsed => 'Tiempo transcurrido';

  @override
  String get onboardingTestTimerStatusPaused => 'Pausado';

  @override
  String get onboardingTestTimerStatusReady => 'Listo';

  @override
  String get onboardingTestTimerRepsHint => 'cuenta tus reps';

  @override
  String get onboardingTestTimerBtnStart => 'Iniciar';

  @override
  String get onboardingTestTimerBtnPause => 'Pausar';

  @override
  String get onboardingTestTimerBtnResume => 'Continuar';

  @override
  String get onboardingTestTimerBtnFinish => 'Terminar ahora';

  @override
  String get onboardingTestTimerBtnReset => 'Reiniciar desde cero';

  @override
  String get onboardingTestTimerSuccessTitle => '¡Test completado!';

  @override
  String onboardingTestTimerSuccessTime(String time) {
    return 'Tiempo: $time';
  }

  @override
  String get onboardingTestTimerFlexibilityQuestion =>
      '¿Hasta dónde llegaron tus manos?';

  @override
  String get onboardingTestTimerFlexibilityOpt1 => 'No llega a rodillas';

  @override
  String get onboardingTestTimerFlexibilityOpt2 => 'Llega a pies';

  @override
  String get onboardingTestTimerFlexibilityOpt3 => 'Supera los pies';

  @override
  String get onboardingTestTimerFlexibilityOpt4 => 'Palmas al suelo';

  @override
  String onboardingTestTimerInputLabel(String unit) {
    return 'Ingresa tu resultado en $unit';
  }

  @override
  String get onboardingTestTimerBtnSave => 'Guardar y continuar';

  @override
  String get onboardingTestTimerBorgQuestion =>
      '¿Cuánto esfuerzo percibiste? (Borg 6–20)';

  @override
  String get onboardingTestTimerBorgLabelNone => 'Ninguno';

  @override
  String get onboardingTestTimerBorgLabelHard => 'Algo fuerte';

  @override
  String get onboardingTestTimerBorgLabelMax => 'Máximo';

  @override
  String get onboardingTestTimerBorgLevel6 => 'Ningún esfuerzo';

  @override
  String get onboardingTestTimerBorgLevel7 => 'Muy muy suave';

  @override
  String get onboardingTestTimerBorgLevel8 => 'Muy suave';

  @override
  String get onboardingTestTimerBorgLevel9 => 'Bastante suave';

  @override
  String get onboardingTestTimerBorgLevel10 => 'Suave';

  @override
  String get onboardingTestTimerBorgLevel11 => 'Moderado suave';

  @override
  String get onboardingTestTimerBorgLevel12 => 'Moderado';

  @override
  String get onboardingTestTimerBorgLevel13 => 'Algo fuerte';

  @override
  String get onboardingTestTimerBorgLevel14 => 'Fuerte';

  @override
  String get onboardingTestTimerBorgLevel15 => 'Muy fuerte';

  @override
  String get onboardingTestTimerBorgLevel16 => 'Muy muy fuerte';

  @override
  String get onboardingTestTimerBorgLevel17 => 'Extremadamente fuerte';

  @override
  String get onboardingTestTimerBorgLevel18 => 'Casi máximo';

  @override
  String get onboardingTestTimerBorgLevel19 => 'Muy cerca del máximo';

  @override
  String get onboardingTestTimerBorgLevel20 => 'Esfuerzo máximo';

  @override
  String get onboardingTestFeedbackErrorSave =>
      'Error al guardar el feedback. Intenta de nuevo.';

  @override
  String get onboardingTestFeedbackBtnSave => 'Guardar feedback';

  @override
  String get onboardingTestFeedbackAnswerAll =>
      'Responde todas las preguntas para continuar';

  @override
  String get onboardingTestFeedbackDesc =>
      'Cuéntanos cómo te fue — esto personaliza tu plan.';

  @override
  String get onboardingTestFeedbackCompletionQuestion =>
      '¿Completaste el test al 100%?';

  @override
  String get onboardingTestFeedbackCompletionYes => '✓  Sí, completo';

  @override
  String get onboardingTestFeedbackCompletionNo => '✗  No del todo';

  @override
  String get onboardingTestFeedbackRpeQuestion =>
      '¿Cuánto esfuerzo percibiste?';

  @override
  String get onboardingTestFeedbackRpeScale => 'Escala RPE 1–10';

  @override
  String get onboardingTestFeedbackRpeScaleEasy => 'Muy fácil';

  @override
  String get onboardingTestFeedbackRpeScaleMax => 'Máximo esfuerzo';

  @override
  String get onboardingTestFeedbackRpeLabelVeryEasy => 'Muy fácil';

  @override
  String get onboardingTestFeedbackRpeLabelModerate => 'Moderado';

  @override
  String get onboardingTestFeedbackRpeLabelSomewhatHard => 'Algo difícil';

  @override
  String get onboardingTestFeedbackRpeLabelHard => 'Difícil';

  @override
  String get onboardingTestFeedbackRpeLabelVeryHard => 'Muy difícil';

  @override
  String get onboardingTestFeedbackRpeLabelMax => 'Esfuerzo máximo';

  @override
  String get onboardingTestFeedbackFeelingQuestion =>
      '¿Cómo te sentiste durante el test?';

  @override
  String get onboardingTestFeedbackFeelingVeryTired => 'Muy cansado';

  @override
  String get onboardingTestFeedbackFeelingTired => 'Cansado';

  @override
  String get onboardingTestFeedbackFeelingGood => 'Bien';

  @override
  String get onboardingTestFeedbackFeelingGreat => 'Sobrado';

  @override
  String get onboardingTestFeedbackFeelingOwnWords =>
      'Cuéntanos con tus palabras (opcional)';

  @override
  String get onboardingTestFeedbackFeelingHint =>
      'Ej: Me sentí con energía aunque me costó al final...';

  @override
  String get onboardingTestFeedbackPainQuestion =>
      '¿Sentiste algún dolor o molestia?';

  @override
  String get onboardingTestFeedbackPainYes => 'Sí, algo';

  @override
  String get onboardingTestFeedbackPainNo => 'No, ninguno';

  @override
  String get onboardingTestFeedbackPainDescHint =>
      'Descríbela: zona del cuerpo, tipo de dolor...';

  @override
  String get onboardingTestFeedbackNotesQuestion =>
      '¿Algo más que quieras contarnos?';

  @override
  String get onboardingTestFeedbackOptional => 'Opcional';

  @override
  String get onboardingTestFeedbackNotesHint =>
      'Ej: las últimas reps me costaron más, sentí las piernas pesadas...';

  @override
  String get onboardingTestTimerModeFree => 'Libre';

  @override
  String get profileSectionSpecialist => 'ESPECIALISTA';

  @override
  String get profileMenuBookSpecialist => 'Pedir cita con el especialista';

  @override
  String get specialistBookingDefaultName => 'Dra. Sofía Rodríguez';

  @override
  String get specialistBookingDefaultBio =>
      'Especialista en nutrición deportiva y kinesiología. Te guiará para alcanzar tus objetivos optimizando tu plan.';

  @override
  String get specialistBookingCheckoutPrice => 'Precio';

  @override
  String get profileActiveBookingHeader => 'Tu cita programada:';

  @override
  String get profileActiveBookingJoinBtn => 'Ir a la cita';

  @override
  String get profileActiveBookingCancelBtn => 'Cancelar cita';

  @override
  String get dailyCheckinLabelPulse => 'Frecuencia Cardíaca';

  @override
  String get dailyCheckinQuestionPulse =>
      'Mídete las pulsaciones durante 15 segundos con el cronómetro e ingrésalas.';

  @override
  String get dailyCheckinPulseHint => 'Pulsaciones en 15 seg';

  @override
  String dailyCheckinPulseCalculated(String bpm) {
    return 'Tu FC estimada es de $bpm lpm';
  }

  @override
  String get dailyCheckinScorePulse => 'Pulsaciones';

  @override
  String get workoutAdjustmentTitle => 'Ajustar entrenamiento';

  @override
  String get specialistBookingNoSpecialist =>
      'Primero debés seleccionar un especialista';

  @override
  String get specialistBookingNo30DayAvailability =>
      'Este especialista no tiene turnos disponibles en los próximos 30 días';

  @override
  String get specialistBookingNoSlotsForSelectedDate =>
      'Este especialista no tiene turnos disponibles para la fecha seleccionada';

  @override
  String get specialistBookingEliteRequiredTitle => 'Plan Elite Requerido';

  @override
  String get specialistBookingEliteRequiredDesc =>
      'Para acceder a la reserva de especialistas, necesitas un plan Elite.';

  @override
  String get specialistBookingUpgradeBtn => 'Actualizar Plan';

  @override
  String get workoutActiveGpsDisabled =>
      'El GPS de tu dispositivo está apagado. Es necesario activarlo para entrenar al aire libre.';

  @override
  String get workoutActiveGpsDenied =>
      'Los permisos de ubicación fueron denegados. Activá los permisos para poder entrenar al aire libre.';

  @override
  String get workoutActiveGpsDeniedForever =>
      'Los permisos de ubicación están denegados permanentemente. Por favor, habilitálos desde los ajustes del sistema.';

  @override
  String get workoutActiveGpsRequired => 'GPS Obligatorio';

  @override
  String get workoutActiveSwitchToIndoor => 'Cambiar a Interior';

  @override
  String get workoutActiveGoToSettings => 'Ir a Ajustes';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get submitButton => 'Enviar';

  @override
  String get profileMenuPaymentMethods => 'Métodos de pago';

  @override
  String subscribeToPlan(String planName) {
    return 'Suscribirse a $planName';
  }

  @override
  String payWithCardEnding(String brand, String lastFour) {
    return 'Pagar con $brand terminada en $lastFour';
  }

  @override
  String get confirmAndSubscribe => 'Confirmar y suscribirse';

  @override
  String get associateCardAndSubscribe => 'Asociar tarjeta y suscribirse';

  @override
  String get processingYourPayment => 'Procesando tu pago...';

  @override
  String get nuveiVerificationMessage =>
      'Estamos verificando la transacción con Nuvei. Esto tomará unos segundos, por favor no cierres la app.';

  @override
  String get paymentCompleted => '¡Pago completado!';

  @override
  String get membershipActivatedMessage =>
      'Tu membresía ha sido activada con éxito. Ahora tienes acceso completo a todas las funciones premium de Fitnflai.';

  @override
  String get startTraining => 'Empezar entrenamiento';

  @override
  String get loadingCards => 'Cargando tarjetas...';

  @override
  String get errorTitle => 'Error';

  @override
  String get retryButton => 'Reintentar';
}
