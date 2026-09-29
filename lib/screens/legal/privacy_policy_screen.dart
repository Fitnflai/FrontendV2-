import 'package:flutter/material.dart';
import '../../config/app_theme_extension.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          isEs ? 'Política de Privacidad' : 'Privacy Policy',
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
              theme as AppThemeExtension,
              isEs ? '1. RESPONSABLE DEL TRATAMIENTO' : '1. DATA CONTROLLER',
              isEs
                  ? 'MEDICALHUB S.A.S., con domicilio en Ecuador, es el responsable del tratamiento de los datos personales que se recogen a través de la Aplicación FITNFLAI. Puede contactar con el Delegado de Protección de Datos en: legal@fitnflai.com'
                  : 'MEDICALHUB S.A.S., based in Ecuador, is the data controller for personal data collected through the FITNFLAI Application. You may contact the Data Protection Officer at: legal@fitnflai.com',
            ),
            _buildSection(
              theme as AppThemeExtension,
              isEs ? '2. DATOS QUE RECOPILAMOS' : '2. DATA WE COLLECT',
              isEs
                  ? '• Datos de identidad: nombre, email, nombre de usuario, foto de perfil.\n'
                    '• Datos antropométricos: peso, altura, edad, género, composición corporal.\n'
                    '• Datos de salud (con consentimiento explícito): lesiones, cirugías, dolores crónicos, ciclo menstrual, informes de bioimpedancia.\n'
                    '• Datos de actividad: entrenamientos, GPS, frecuencia cardíaca, pasos, calorías, sueño (desde wearables conectados).\n'
                    '• Datos de uso: interacciones en la app, logs de errores, datos de diagnóstico.\n'
                    '• Datos de pago: gestionados por pasarelas externas (Stripe, Google Play, Apple App Store). FITNFLAI no almacena números de tarjeta completos.'
                  : '• Identity data: name, email, username, profile photo.\n'
                    '• Anthropometric data: weight, height, age, gender, body composition.\n'
                    '• Health data (with explicit consent): injuries, surgeries, chronic pain, menstrual cycle, bioimpedance reports.\n'
                    '• Activity data: workouts, GPS, heart rate, steps, calories, sleep (from connected wearables).\n'
                    '• Usage data: app interactions, error logs, diagnostic data.\n'
                    '• Payment data: managed by external gateways (Stripe, Google Play, Apple App Store). FITNFLAI does not store full card numbers.',
            ),
            _buildSection(
              theme as AppThemeExtension,
              isEs ? '3. FINALIDAD DEL TRATAMIENTO' : '3. PURPOSE OF PROCESSING',
              isEs
                  ? '• Ejecución del contrato: generar planes de entrenamiento personalizados, seguimiento de progreso.\n'
                    '• Interés legítimo: mejora de la app, analíticas, seguridad, prevención de fraude.\n'
                    '• Consentimiento explícito: tratamiento de datos de salud sensibles, notificaciones push, marketing.\n'
                    '• Obligación legal: facturación, cumplimiento normativo LOPDP.'
                  : '• Contract execution: generate personalized training plans, progress tracking.\n'
                    '• Legitimate interest: app improvement, analytics, security, fraud prevention.\n'
                    '• Explicit consent: sensitive health data processing, push notifications, marketing.\n'
                    '• Legal obligation: billing, LOPDP compliance.',
            ),
            _buildSection(
              theme as AppThemeExtension,
              isEs ? '4. COMPARTICIÓN DE DATOS' : '4. DATA SHARING',
              isEs
                  ? '• Proveedores de servicios: pasarelas de pago, hosting, analíticas (Firebase), notificaciones push.\n'
                    '• Especialistas (solo si reserva cita): nutricionistas, fisios, entrenadores.\n'
                    '• Wearables conectados: Garmin, Strava, Apple Health, Huawei Health (bajo sus propios términos).\n'
                    '• Autoridades competentes: cuando sea requerido por ley.'
                  : '• Service providers: payment gateways, hosting, analytics (Firebase), push notifications.\n'
                    '• Specialists (only if booking appointment): nutritionists, physios, coaches.\n'
                    '• Connected wearables: Garmin, Strava, Apple Health, Huawei Health (under their own terms).\n'
                    '• Competent authorities: when required by law.',
            ),
            _buildSection(
              theme as AppThemeExtension,
              isEs ? '5. TRANSFERENCIAS INTERNACIONALES' : '5. INTERNATIONAL TRANSFERS',
              isEs
                  ? 'Sus datos pueden ser tratados en servidores ubicados fuera de Ecuador (ej. Google Cloud, Firebase en EE. UU.). Dichas transferencias se realizan bajo cláusulas contractuales tipo aprobadas y garantías adecuadas según LOPDP.'
                  : 'Your data may be processed on servers located outside Ecuador (e.g., Google Cloud, Firebase in the USA). Such transfers are carried out under approved standard contractual clauses and adequate safeguards per LOPDP.',
            ),
            _buildSection(
              theme as AppThemeExtension,
              isEs ? '6. CONSERVACIÓN DE DATOS' : '6. DATA RETENTION',
              isEs
                  ? '• Datos de cuenta: mientras la cuenta esté activa.\n'
                    '• Datos de salud/entrenamiento: 5 años tras la última actividad (fines de historial y mejora de algoritmos).\n'
                    '• Datos de facturación: 7 años (obligación tributaria).\n'
                    '• Logs de seguridad: 12 meses.\n'
                    '• Puede solicitar supresión anticipada (derecho al olvido).'
                  : '• Account data: while the account is active.\n'
                    '• Health/training data: 5 years after last activity (history and algorithm improvement purposes).\n'
                    '• Billing data: 7 years (tax obligation).\n'
                    '• Security logs: 12 months.\n'
                    '• You may request early deletion (right to be forgotten).',
            ),
            _buildSection(
              theme as AppThemeExtension,
              isEs ? '7. SUS DERECHOS (LOPDP)' : '7. YOUR RIGHTS (LOPDP)',
              isEs
                  ? '• Acceso: obtener confirmación y copia de sus datos.\n'
                    '• Rectificación: corregir datos inexactos o incompletos.\n'
                    '• Supresión: eliminar sus datos (derecho al olvido).\n'
                    '• Oposición: oponerse al tratamiento por interés legítimo o marketing.\n'
                    '• Limitación: restringir el tratamiento temporalmente.\n'
                    '• Portabilidad: recibir sus datos en formato estructurado.\n'
                    '• Revocación del consentimiento: en cualquier momento para datos de salud.\n\n'
                    'Para ejercerlos: legal@fitnflai.com o desde la app en Perfil > Privacidad.'
                  : '• Access: obtain confirmation and copy of your data.\n'
                    '• Rectification: correct inaccurate or incomplete data.\n'
                    '• Erasure: delete your data (right to be forgotten).\n'
                    '• Objection: object to processing based on legitimate interest or marketing.\n'
                    '• Restriction: temporarily restrict processing.\n'
                    '• Portability: receive your data in structured format.\n'
                    '• Consent withdrawal: at any time for health data.\n\n'
                    'To exercise: legal@fitnflai.com or from the app in Profile > Privacy.',
            ),
            _buildSection(
              theme as AppThemeExtension,
              isEs ? '8. SEGURIDAD' : '8. SECURITY',
              isEs
                  ? 'Implementamos medidas técnicas y organizativas apropiadas: cifrado TLS 1.3 en tránsito, cifrado en reposo (AES-256), autenticación segura (JWT, OAuth), acceso basado en roles, auditorías periódicas, y plan de respuesta a incidentes.'
                  : 'We implement appropriate technical and organizational measures: TLS 1.3 encryption in transit, encryption at rest (AES-256), secure authentication (JWT, OAuth), role-based access, periodic audits, and incident response plan.',
            ),
            _buildSection(
              theme as AppThemeExtension,
              isEs ? '9. CAMBIOS EN ESTA POLÍTICA' : '9. CHANGES TO THIS POLICY',
              isEs
                  ? 'Cualquier modificación será notificada en la app y/o por email con 30 días de antelación. El uso continuado implica aceptación.'
                  : 'Any modification will be notified in the app and/or by email with 30 days\' notice. Continued use implies acceptance.',
            ),
            _buildSection(
              theme as AppThemeExtension,
              isEs ? '10. CONTACTO' : '10. CONTACT',
              isEs
                  ? 'MEDICALHUB S.A.S.\nEmail: legal@fitnflai.com\nWeb: https://fitnflai.com/privacy'
                  : 'MEDICALHUB S.A.S.\nEmail: legal@fitnflai.com\nWeb: https://fitnflai.com/privacy',
            ),
            const SizedBox(height: 24),
            _buildFooter(theme as AppThemeExtension, isEs),
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
          isEs ? 'POLÍTICA DE PRIVACIDAD Y PROTECCIÓN DE DATOS PERSONALES' : 'PRIVACY POLICY AND PERSONAL DATA PROTECTION',
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
              ? 'Versión: Agosto 2026\nResponsable: MEDICALHUB S.A.S.\nContacto DPO: legal@fitnflai.com'
              : 'Version: August 2026\nController: MEDICALHUB S.A.S.\nDPO Contact: legal@fitnflai.com',
          style: TextStyle(
            color: theme.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isEs
              ? 'En FITNFLAI nos tomamos muy en serio la privacidad y la protección de sus datos personales. Esta Política explica qué datos recopilamos, para qué los usamos, con quién los compartimos, y qué derechos tiene sobre ellos, de conformidad con la Ley Orgánica de Protección de Datos Personales (LOPDP) de Ecuador y estándares internacionales (GDPR).'
              : 'At FITNFLAI we take your privacy and personal data protection very seriously. This Policy explains what data we collect, what we use it for, who we share it with, and what rights you have over it, in accordance with Ecuador\'s Organic Law on Personal Data Protection (LOPDP) and international standards (GDPR).',
          style: TextStyle(
            color: theme.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(AppThemeExtension theme, String title, String content) {
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

  Widget _buildFooter(AppThemeExtension theme, bool isEs) {
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
                ? 'Para consultas de privacidad: legal@fitnflai.com'
                : 'For privacy inquiries: legal@fitnflai.com',
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