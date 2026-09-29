import 'package:flutter/material.dart';
import '../../config/app_theme_extension.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final isEs = Localizations.localeOf(context).languageCode == 'es';

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: theme.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEs ? 'Términos y Condiciones' : 'Terms and Conditions',
          style: TextStyle(color: theme.text, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, isEs),
            const SizedBox(height: 24),
            _buildSection(
              theme,
              isEs ? 'PRIMERA. OBJETO Y DESCRIPCIÓN DEL SERVICIO' : 'FIRST. PURPOSE AND SERVICE DESCRIPTION',
              isEs
                  ? 'FITNFLAI es una plataforma tecnológica orientada a brindar entrenamientos deportivos adaptativos. El servicio principal de la Aplicación consiste en la generación, actualización y seguimiento de rutinas y planes de entrenamiento físico personalizados, diseñados sobre la base de los datos antropométricos (como peso y altura), objetivos deportivos, disponibilidad de tiempo, días de entrenamiento, tipo de actividad física y equipamiento que el Usuario proporciona de manera voluntaria. El servicio está disponible bajo la modalidad de suscripciones gratuitas (Plan Básico) y de pago (Plan Premium), detalladas en la Cláusula Quinta.'
                  : 'FITNFLAI is a technology platform focused on providing adaptive sports training. The main service of the Application consists of the generation, updating, and tracking of personalized physical training routines and plans, designed based on anthropometric data (such as weight and height), sports objectives, time availability, training days, type of physical activity, and equipment that the User voluntarily provides. The service is available under free subscription (Basic Plan) and paid subscription (Premium Plan) modalities, detailed in Clause Five.',
            ),
            _buildSection(
              theme,
              isEs ? 'SEGUNDA. DESCARGO DE RESPONSABILIDAD MÉDICA Y DE SALUD (CRÍTICO)' : 'SECOND. MEDICAL AND HEALTH DISCLAIMER (CRITICAL)',
              isEs
                  ? 'FITNFLAI NO PRESTA SERVICIOS MÉDICOS, NO ES UN CENTRO DE SALUD, NO REALIZA DIAGNÓSTICOS CLÍNICOS, NO EMITE PRESCRIPCIONES TERAPÉUTICAS Y NO SUSTITUYE LA VALORACIÓN, CONSEJO O TRATAMIENTO DE UN PROFESIONAL DE LA SALUD CALIFICADO.\n\n'
                    '1. Finalidad Deportiva y de Bienestar: Los planes de entrenamiento generados por la Aplicación tienen un fin exclusivamente deportivo y de acondicionamiento físico. En ningún caso deben ser interpretados como tratamientos clínicos, rehabilitaciones de lesiones o recetas médicas.\n\n'
                    '2. Tratamiento de Datos de Salud para Seguridad: Cualquier información que el Usuario comparta voluntariamente sobre su estado de salud, lesiones activas, dolores recurrentes o informes de composición corporal (como bioimpedancia o InBody) es procesada con el único y exclusivo fin de personalizar la rutina para su seguridad (por ejemplo, excluyendo ejercicios de alta carga o adaptando la intensidad). Esta información no constituye una historia clínica completa ni una herramienta diagnóstica.\n\n'
                    '3. Responsabilidad del Usuario y Consulta Previa: Es responsabilidad exclusiva del Usuario evaluar su propia aptitud física antes de comenzar cualquier rutina. Si el Usuario presenta condiciones preexistentes, cardiopatías, cirugías recientes, embarazo, dolores crónicos o dudas sobre su estado físico, tiene la obligación y se le recomienda enfáticamente consultar con un profesional de la salud acreditado antes de iniciar cualquier entrenamiento.\n\n'
                    '4. Asunción de Riesgos: La práctica de cualquier actividad física conlleva riesgos de lesiones. El Usuario asume voluntariamente dichos riesgos al realizar las rutinas y exime a MEDICALHUB S.A.S. de cualquier responsabilidad por complicaciones de salud derivadas de la omisión de consultas médicas previas, o de la inserción de datos inexactos o incompletos dentro de la Aplicación.'
                  : 'FITNFLAI DOES NOT PROVIDE MEDICAL SERVICES, IS NOT A HEALTH CENTER, DOES NOT PERFORM CLINICAL DIAGNOSES, DOES NOT ISSUE THERAPEUTIC PRESCRIPTIONS, AND DOES NOT SUBSTITUTE THE EVALUATION, ADVICE, OR TREATMENT OF A QUALIFIED HEALTH PROFESSIONAL.\n\n'
                    '1. Sports and Wellness Purpose: The training plans generated by the Application have an exclusively sports and physical conditioning purpose. In no case should they be interpreted as clinical treatments, injury rehabilitation, or medical prescriptions.\n\n'
                    '2. Health Data Processing for Safety: Any information that the User voluntarily shares about their health status, active injuries, recurring pain, or body composition reports (such as bioimpedance or InBody) is processed solely and exclusively to personalize the routine for safety (for example, excluding high-load exercises or adapting intensity). This information does not constitute a complete medical history or a diagnostic tool.\n\n'
                    '3. User Responsibility and Prior Consultation: It is the exclusive responsibility of the User to evaluate their own physical fitness before starting any routine. If the User has pre-existing conditions, heart disease, recent surgeries, pregnancy, chronic pain, or doubts about their physical condition, they have the obligation and are strongly recommended to consult with an accredited health professional before starting any training.\n\n'
                    '4. Assumption of Risks: The practice of any physical activity carries risks of injury. The User voluntarily assumes such risks when performing the routines and releases MEDICALHUB S.A.S. from any liability for health complications arising from the omission of prior medical consultations, or from the insertion of inaccurate or incomplete data within the Application.',
            ),
            _buildSection(
              theme,
              isEs ? 'TERCERA. REQUISITOS DE CAPACIDAD Y REGISTRO DE CUENTA' : 'THIRD. CAPACITY REQUIREMENTS AND ACCOUNT REGISTRATION',
              isEs
                  ? 'Para utilizar FITNFLAI y registrar una cuenta, se deben cumplir los siguientes requisitos:\n\n'
                    '• Mayoría de edad: El Usuario debe tener al menos dieciocho (18) años de edad cumplidos. FITNFLAI no recopila datos de menores de edad ni permite su registro.\n'
                    '• Veracidad de la información: El Usuario se compromete a ingresar información exacta, actual y verídica en su perfil, especialmente en lo que respecta a sus métricas físicas y antecedentes antropométricos.\n'
                    '• Seguridad de credenciales: Las credenciales de acceso (usuario y contraseña) son personales, confidenciales e intransferibles. El Usuario es el único responsable de mantener la confidencialidad de sus claves y de todas las actividades que ocurran bajo su cuenta. Ante sospechas de vulneraciones, debe notificar inmediatamente a FITNFLAI.'
                  : 'To use FITNFLAI and register an account, the following requirements must be met:\n\n'
                    '• Legal age: The User must be at least eighteen (18) years old. FITNFLAI does not collect data from minors nor allow their registration.\n'
                    '• Accuracy of information: The User agrees to enter exact, current, and truthful information in their profile, especially regarding their physical metrics and anthropometric history.\n'
                    '• Credential security: Access credentials (username and password) are personal, confidential, and non-transferable. The User is solely responsible for maintaining the confidentiality of their credentials and all activities occurring under their account. In case of suspected breaches, they must notify FITNFLAI immediately.',
            ),
            _buildSection(
              theme,
              isEs ? 'CUARTA. PROTECCIÓN DE DATOS PERSONALES (LOPDP)' : 'FOURTH. PERSONAL DATA PROTECTION (LOPDP)',
              isEs
                  ? 'De conformidad con la Ley Orgánica de Protección de Datos Personales (LOPDP) de la República del Ecuador, MEDICALHUB S.A.S. actúa como responsable del tratamiento de los datos del Usuario. Los datos antropométricos y de actividad física se procesan para la ejecución de la relación contractual, mientras que el tratamiento de datos sensibles de salud (lesiones, cirugías recientes o composición corporal) requiere su consentimiento explícito separado, el cual puede ser revocado en cualquier momento desde la Aplicación sin que ello afecte la prestación principal del servicio. Puede revisar el tratamiento detallado de sus datos en nuestra Política de Privacidad y de Protección de Datos Personales, así como ejercer sus derechos de acceso, rectificación, eliminación y oposición siguiendo nuestro Protocolo para el Ejercicio de Derechos de los Titulares.'
                  : 'In accordance with the Organic Law on Personal Data Protection (LOPDP) of the Republic of Ecuador, MEDICALHUB S.A.S. acts as the data controller for User data. Anthropometric and physical activity data are processed for the execution of the contractual relationship, while the processing of sensitive health data (injuries, recent surgeries, or body composition) requires explicit separate consent, which can be revoked at any time from the Application without affecting the main service provision. You may review the detailed processing of your data in our Privacy Policy and Personal Data Protection Policy, as well as exercise your rights of access, rectification, deletion, and objection following our Protocol for the Exercise of Data Subject Rights.',
            ),
            _buildSection(
              theme,
              isEs ? 'QUINTA. PLAN BÁSICO Y PLAN PREMIUM (PAGOS Y FACTURACIÓN)' : 'FIFTH. BASIC PLAN AND PREMIUM PLAN (PAYMENTS AND BILLING)',
              isEs
                  ? 'FITNFLAI ofrece dos modalidades de suscripción:\n\n'
                    '1. Plan Básico: Brinda acceso a las funcionalidades estándar de generación de perfiles y planes de entrenamiento, sujeto a limitaciones publicitarias o funcionales generales.\n\n'
                    '2. Plan Premium (Suscripciones de Pago): Desbloquea herramientas adicionales de análisis, informes detallados, composición corporal avanzada, nutrición y acompañamiento. Las tarifas vigentes se publican de forma transparente en la sección de "Precios" de la plataforma.\n\n'
                    '3. Pagos y Datos Financieros: El procesamiento de cobros de las suscripciones Premium se realiza mediante plataformas de pasarelas de pago de terceros especializadas (como Stripe, PayPal o las pasarelas de Google Play y Apple App Store). FITNFLAI no recopila ni almacena los datos de tarjetas de crédito o cuentas bancarias completas del Usuario; dicho tratamiento es gestionado de manera segura y directa por el proveedor financiero correspondiente.'
                  : 'FITNFLAI offers two subscription modalities:\n\n'
                    '1. Basic Plan: Provides access to standard profile generation and training plan functionalities, subject to general advertising or functional limitations.\n\n'
                    '2. Premium Plan (Paid Subscriptions): Unlocks additional analysis tools, detailed reports, advanced body composition, nutrition, and coaching. Current rates are published transparently in the "Pricing" section of the platform.\n\n'
                    '3. Payments and Financial Data: The processing of Premium subscription charges is carried out through specialized third-party payment gateway platforms (such as Stripe, PayPal, or Google Play and Apple App Store gateways). FITNFLAI does not collect or store the User\'s complete credit card or bank account data; such processing is managed securely and directly by the corresponding financial provider.',
            ),
            _buildSection(
              theme,
              isEs ? 'SEXTA. VINCULACIÓN DE WEARABLES Y SERVICIOS DE TERCEROS' : 'SIXTH. WEARABLES AND THIRD-PARTY SERVICES INTEGRATION',
              isEs
                  ? 'La Aplicación permite a los usuarios conectar de manera voluntaria dispositivos inteligentes y relojes inteligentes (como Garmin, Strava, Apple Health, Huawei Health u otros wearables). El intercambio de datos (como calorías quemadas, pasos o frecuencia cardíaca) se realiza únicamente tras la autorización expresa del Usuario en su respectivo dispositivo. Una vez importados, el tratamiento se rige por la Política de Privacidad de FITNFLAI; no obstante, el funcionamiento de dichos dispositivos y el tratamiento que los terceros hagan antes de la importación se rige bajo sus respectivos términos independientes.'
                  : 'The Application allows users to voluntarily connect smart devices and smartwatches (such as Garmin, Strava, Apple Health, Huawei Health, or other wearables). Data exchange (such as calories burned, steps, or heart rate) occurs only after the User\'s express authorization on their respective device. Once imported, processing is governed by FITNFLAI\'s Privacy Policy; however, the operation of such devices and the processing that third parties perform before importation is governed by their respective independent terms.',
            ),
            _buildSection(
              theme,
              isEs ? 'SÉPTIMA. PROPIEDAD INTELECTUAL' : 'SEVENTH. INTELLECTUAL PROPERTY',
              isEs
                  ? 'Todos los contenidos de la Aplicación, incluidos los algoritmos de personalización de entrenamiento, código de software, diseños, logotipos, interfaces, textos, ilustraciones, bases de datos y marcas comerciales son de propiedad exclusiva de MEDICALHUB S.A.S. Queda terminantemente prohibido reproducir, distribuir, realizar ingeniería inversa, modificar o explotar de manera no autorizada cualquier componente de la plataforma sin el consentimiento previo y por escrito de FITNFLAI.'
                  : 'All content of the Application, including training personalization algorithms, software code, designs, logos, interfaces, texts, illustrations, databases, and trademarks are the exclusive property of MEDICALHUB S.A.S. It is strictly prohibited to reproduce, distribute, reverse engineer, modify, or exploit any component of the platform in an unauthorized manner without the prior written consent of FITNFLAI.',
            ),
            _buildSection(
              theme,
              isEs ? 'OCTAVA. USO ACEPTABLE Y PROHIBICIONES' : 'EIGHTH. ACCEPTABLE USE AND PROHIBITIONS',
              isEs
                  ? 'El Usuario se obliga a utilizar la plataforma con estricto apego a la ley, la moral y las buenas costumbres. Queda expresamente prohibido:\n\n'
                    '• Registrar información de terceros o suplantar identidades de otros atletas.\n'
                    '• Utilizar herramientas automáticas, bots, crawlers o scripts para extraer datos de la plataforma de forma masiva.\n'
                    '• Introducir código malicioso, troyanos o virus destinados a alterar, vulnerar o dañar los servidores o la seguridad de FITNFLAI.\n'
                    '• Utilizar las rutinas, consejos o planes con fines de lucro o comercialización comercial de manera independiente sin la debida licencia de FITNFLAI.'
                  : 'The User agrees to use the platform in strict adherence to the law, morality, and good customs. The following is expressly prohibited:\n\n'
                    '• Registering third-party information or impersonating other athletes\' identities.\n'
                    '• Using automated tools, bots, crawlers, or scripts to extract data from the platform massively.\n'
                    '• Introducing malicious code, trojans, or viruses intended to alter, breach, or damage FITNFLAI\'s servers or security.\n'
                    '• Using routines, advice, or plans for profit or independent commercial commercialization without due license from FITNFLAI.',
            ),
            _buildSection(
              theme,
              isEs ? 'NOVENA. SUSPENSIÓN Y TERMINACIÓN DE CUENTAS' : 'NINTH. ACCOUNT SUSPENSION AND TERMINATION',
              isEs
                  ? 'FITNFLAI se reserva el derecho de suspender de forma temporal, restringir o cancelar de manera definitiva y permanente el acceso a la cuenta de cualquier Usuario que incumpla las disposiciones de los presentes Términos, que realice actividades fraudulentas, falsifique información de salud, infrinja derechos de propiedad intelectual, o cuando se determine que el Usuario es menor de 18 años. Esta medida se aplicará de forma motivada para preservar la seguridad de la comunidad de atletas.'
                  : 'FITNFLAI reserves the right to temporarily suspend, restrict, or permanently cancel access to the account of any User who breaches the provisions of these Terms, engages in fraudulent activities, falsifies health information, infringes intellectual property rights, or when it is determined that the User is under 18 years old. This measure will be applied in a motivated manner to preserve the safety of the athlete community.',
            ),
            _buildSection(
              theme,
              isEs ? 'DÉCIMA. MODIFICACIONES DE LOS TÉRMINOS' : 'TENTH. TERMS MODIFICATIONS',
              isEs
                  ? 'FITNFLAI podrá actualizar o modificar los presentes Términos en cualquier momento para adaptarlos a mejoras operativas, cambios normativos o nuevas condiciones de servicio. Las modificaciones serán notificadas de manera oportuna a los usuarios mediante alertas dentro de la Aplicación o correo electrónico, indicando la fecha de última actualización. El uso continuado del servicio posterior a la notificación constituirá su conocimiento y aceptación.'
                  : 'FITNFLAI may update or modify these Terms at any time to adapt them to operational improvements, regulatory changes, or new service conditions. Modifications will be promptly notified to users via in-app alerts or email, indicating the last update date. Continued use of the service after notification shall constitute knowledge and acceptance.',
            ),
            _buildSection(
              theme,
              isEs ? 'DÉCIMA PRIMERA. LEGISLACIÓN APLICABLE Y RESOLUCIÓN DE DISPUTAS' : 'ELEVENTH. APPLICABLE LAW AND DISPUTE RESOLUTION',
              isEs
                  ? 'Los presentes Términos se rigen e interpretan bajo las leyes de la República del Ecuador. Para cualquier controversia, disputa o reclamo derivado de la interpretación, validez o ejecución de los presentes Términos, el Usuario y FITNFLAI renuncian a su fuero y se someten a la resolución de tribunales competentes en la ciudad de Quito, Pichincha, República del Ecuador.'
                  : 'These Terms are governed and interpreted under the laws of the Republic of Ecuador. For any controversy, dispute, or claim arising from the interpretation, validity, or execution of these Terms, the User and FITNFLAI waive their jurisdiction and submit to the resolution of competent courts in the city of Quito, Pichincha, Republic of Ecuador.',
            ),
            const SizedBox(height: 24),
            _buildFooter(theme, isEs),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppThemeExtensionWrapper theme, bool isEs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEs ? 'TÉRMINOS Y CONDICIONES GENERALES DE USO DE FITNFLAI' : 'FITNFLAI GENERAL TERMS AND CONDITIONS OF USE',
          style: TextStyle(
            color: theme.text,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isEs
              ? 'Operado por: MEDICALHUB S.A.S. (en adelante, "FITNFLAI")\nÚltima actualización: Agosto 2026'
              : 'Operated by: MEDICALHUB S.A.S. (hereinafter, "FITNFLAI")\nLast updated: August 2026',
          style: TextStyle(
            color: theme.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isEs
              ? 'Bienvenido a FITNFLAI. Los presentes Términos y Condiciones de Uso (en adelante, los "Términos") regulan el acceso, registro y uso de la aplicación digital, sitio web y servicios móviles de FITNFLAI (en adelante, la "Aplicación"), de propiedad y operada por MEDICALHUB S.A.S., una compañía legalmente constituida en la República del Ecuador.\n\nAl registrarse, acceder o utilizar la Aplicación, usted (en adelante, el "Usuario") declara bajo juramento ser mayor de edad, contar con la capacidad legal suficiente y acepta quedar plenamente vinculado por los presentes Términos en su totalidad. Si no está de acuerdo con alguna de las disposiciones establecidas en este documento, le rogamos que se abstenga de registrarse o utilizar la plataforma.'
              : 'Welcome to FITNFLAI. These Terms and Conditions of Use (hereinafter, the "Terms") govern the access, registration, and use of the FITNFLAI digital application, website, and mobile services (hereinafter, the "Application"), owned and operated by MEDICALHUB S.A.S., a company legally incorporated in the Republic of Ecuador.\n\nBy registering, accessing, or using the Application, you (hereinafter, the "User") declare under oath to be of legal age, have sufficient legal capacity, and agree to be fully bound by these Terms in their entirety. If you do not agree with any of the provisions set forth in this document, we ask that you refrain from registering or using the platform.',
          style: TextStyle(
            color: theme.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(AppThemeExtensionWrapper theme, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.primary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(AppThemeExtensionWrapper theme, bool isEs) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEs ? 'MEDICALHUB S.A.S. — Todos los derechos reservados.' : 'MEDICALHUB S.A.S. — All rights reserved.',
            style: TextStyle(
              color: theme.text,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEs
                ? 'Para consultas legales: legal@fitnflai.com'
                : 'For legal inquiries: legal@fitnflai.com',
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}