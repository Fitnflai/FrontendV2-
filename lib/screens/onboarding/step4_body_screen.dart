import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../config/app_colors.dart';
import '../../config/onboarding_router.dart'; // Added
import '../../config/app_routes.dart'; // Added
import '../../providers/auth_provider.dart';
import '../../widgets/shared_widgets.dart';

class Step4BodyScreen extends StatefulWidget {
  const Step4BodyScreen({super.key});
  @override
  State<Step4BodyScreen> createState() => _Step4BodyScreenState();
}

class _Step4BodyScreenState extends State<Step4BodyScreen> {
  // Lesiones
  bool _hasInjury  = false;
  bool _hasSurgery = false;
  bool _hasPain    = false;
  bool _hasCardio  = false;

  // Campos detallados de lesión activa
  final _injuryDescCtrl       = TextEditingController(); // descripcion_molestia
  final _injuryZonaCtrl       = TextEditingController(); // zona_afectada
  double _injuryNivelDolor    = 4;                       // nivel_dolor_eva
  String _injuryTipoLesion    = 'activa';                // tipo_lesion

  final _injuryCtrl  = TextEditingController();
  final _surgeryCtrl = TextEditingController();
  final _painCtrl    = TextEditingController();
  final _cardioCtrl  = TextEditingController();

  // Medicación — lista del backend

  // Loading general
  bool _loading = false;

  // Archivo subido
  File?   _uploadedFile;
  String? _uploadedFileName;
  bool    _isImage = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _uploadedFile     = File(picked.path);
        _uploadedFileName = picked.name;
        _isImage          = true;
      });
      if (!mounted) return;
      final token = context.read<AuthProvider>().token ?? '';
      await _uploadFile(token);
    }
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _uploadedFile     = File(result.files.single.path!);
        _uploadedFileName = result.files.single.name;
        _isImage          = false;
      });
      if (!mounted) return;
      final token = context.read<AuthProvider>().token ?? '';
      await _uploadFile(token);
    }
  }

  void _showUploadChooser() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined, color: AppColors.orange),
              title: Text(l10n.onboardingBodyUploadImageBtn, style: const TextStyle(color: AppColors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.orange),
              title: Text(l10n.onboardingBodyUploadPdfBtn, style: const TextStyle(color: AppColors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickPdf();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  // Resultados de la báscula
  Map<String, dynamic>? _scaleData;
  bool _uploadingScale = false;

  Future<void> _uploadFile(String token) async {
    if (_uploadedFile == null) return;
    setState(() => _uploadingScale = true);
    try {
      final req = http.MultipartRequest(
        'POST',
        Uri.parse('https://apifitnflai.com/onboarding/save-process-scale-report-data'),
      );
      req.headers['Authorization'] = 'Bearer $token';

      // Detectar mime type según tipo de archivo
      final ext      = _uploadedFile!.path.split('.').last.toLowerCase();
      final mimeType = ext == 'pdf' ? 'application/pdf' : 'image/jpeg';
      final mediaParts = mimeType.split('/');
      req.files.add(await http.MultipartFile.fromPath(
        'file',
        _uploadedFile!.path,
        contentType: http.MediaType(mediaParts[0], mediaParts[1]),
      ));

      final streamed = await req.send();
      final res      = await http.Response.fromStream(streamed);
      debugPrint('STEP5 FILE: ${res.statusCode} — ${res.body}');

      if (!mounted) return;
      if (res.statusCode == 200 || res.statusCode == 201) {
        // El API puede devolver un string o un JSON con datos
        try {
          final body = jsonDecode(res.body);
          Map<String, dynamic>? data;
          if (body is Map) {
            data = (body['data'] as Map<String, dynamic>?)
                ?? (body as Map<String, dynamic>);
          }
          // Mostrar modal si hay datos útiles
          if (data != null &&
              (data['imb'] != null || data['grasa_corporal'] != null ||
               data['muscular'] != null || data['imc'] != null)) {
            setState(() => _scaleData = data);
            _showScaleResultModal(data);
            return;
          }
        } catch (_) {}
        // Si no hay datos parseables, mostrar éxito simple
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('✅ Archivo subido correctamente'),
            backgroundColor: Color(0xFF2E6B4F),
            duration: Duration(seconds: 2),
          ));
        }
      } else {
        _showScaleErrorDialog(retry: true);
      }
    } catch (e) {
      debugPrint('STEP5 FILE ERROR: $e');
      if (mounted) _showScaleErrorDialog(retry: true);
    } finally {
      if (mounted) setState(() => _uploadingScale = false);
    }
  }

  void _showScaleResultModal(Map<String, dynamic> data) {
    final locale = Localizations.localeOf(context).languageCode;
    // Mapeo de keys del API → labels legibles + unidades
    final labelMap = locale == 'es' ? {
      'imb':              ('TMB / IMB',         'kcal'),
      'imc':              ('IMC',                ''),
      'grasa_corporal':   ('Grasa corporal',     '%'),
      'masa_muscular':    ('Masa muscular',      'kg'),
      'muscular':         ('Masa muscular',      'kg'),
      'agua_corporal':    ('Agua corporal',      '%'),
      'masa_osea':        ('Masa ósea',          'kg'),
      'grasa_visceral':   ('Grasa visceral',     ''),
      'edad_metabolica':  ('Edad metabólica',    'años'),
      'peso':             ('Peso',               'kg'),
      'altura':           ('Altura',             'cm'),
      'proteinas':        ('Proteínas',          '%'),
    } : {
      'imb':              ('BMR / AMR',         'kcal'),
      'imc':              ('BMI',                ''),
      'grasa_corporal':   ('Body fat',           '%'),
      'masa_muscular':    ('Muscle mass',        'kg'),
      'muscular':         ('Muscle mass',        'kg'),
      'agua_corporal':    ('Body water',         '%'),
      'masa_osea':        ('Bone mass',          'kg'),
      'grasa_visceral':   ('Visceral fat',       ''),
      'edad_metabolica':  ('Metabolic age',      'years'),
      'peso':             ('Weight',             'kg'),
      'altura':           ('Height',             'cm'),
      'proteinas':        ('Proteins',           '%'),
    };

    // Construir lista dinámica de todos los campos no nulos
    final items = <({String label, String value})>[];
    data.forEach((key, value) {
      if (value == null) return;
      final meta   = labelMap[key];
      final label  = meta?.$1 ?? _keyToLabel(key);
      final unit   = meta?.$2 ?? '';
      final display = unit.isNotEmpty ? '$value $unit' : '$value';
      items.add((label: label, value: display));
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, scrollCtrl) => SingleChildScrollView(
          controller: scrollCtrl,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Handle
            Center(child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2)),
            )),
            Row(children: [
              const Text('✅', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(child: Text(AppLocalizations.of(context).onboardingBodyUploadSuccessDialogTitle,
                  style: const TextStyle(color: AppColors.white,
                      fontSize: 16, fontWeight: FontWeight.w800))),
            ]),
            const SizedBox(height: 4),
            Text(AppLocalizations.of(context).onboardingBodyUploadScaleDataExtracted,
                style: const TextStyle(color: AppColors.grey, fontSize: 13)),
            const SizedBox(height: 16),

            // Grid 2 columnas con todos los campos
            ...List.generate((items.length / 2).ceil(), (row) {
              final a = row * 2;
              final b = a + 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(children: [
                  Expanded(child: _ScaleMetricTile(
                      label: items[a].label, value: items[a].value)),
                  const SizedBox(width: 10),
                  if (b < items.length)
                    Expanded(child: _ScaleMetricTile(
                        label: items[b].label, value: items[b].value))
                  else
                    const Expanded(child: SizedBox()),
                ]),
              );
            }),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(locale == 'es' ? 'Entendido' : 'Got it',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  /// Convierte una key del API en un label legible como fallback
  String _keyToLabel(String key) =>
      key.replaceAll('_', ' ')
         .split(' ')
         .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
         .join(' ');

  void _showScaleErrorDialog({bool retry = false}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Text('⚠️', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(AppLocalizations.of(context).onboardingBodyUploadErrorDialogTitle,
              style: const TextStyle(color: AppColors.white, fontSize: 16,
                  fontWeight: FontWeight.w700)),
        ]),
        content: Text(
          AppLocalizations.of(context).onboardingBodyUploadErrorDialogDesc,
          style: const TextStyle(color: AppColors.grey, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).onboardingBodyUploadErrorDialogCancel,
                style: const TextStyle(color: AppColors.grey)),
          ),
          if (retry)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                final token = context.read<AuthProvider>().token ?? '';
                _uploadFile(token);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(AppLocalizations.of(context).onboardingBodyUploadErrorDialogRetry,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }

  Future<void> _saveAndContinue() async {
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.token ?? '';
    final userId = authProvider.user?.id;
    setState(() => _loading = true);
    try {

      // 1. Subir archivo si existe y no fue subido aún
      if (_uploadedFile != null && !_uploadingScale) {
        await _uploadFile(token);
      }

      // 2. Construir detalles de lesiones
      final lesiones = <Map<String, dynamic>>[];
      if (_hasInjury) {
        lesiones.add({
          'descripcion_molestia': _injuryDescCtrl.text.trim().isNotEmpty
              ? _injuryDescCtrl.text.trim() : 'Lesión activa',
          'tipo_lesion':     _injuryTipoLesion,
          'zona_afectada':   _injuryZonaCtrl.text.trim().isNotEmpty
              ? _injuryZonaCtrl.text.trim() : 'No especificada',
          'nivel_dolor_eva': _injuryNivelDolor.round(),
        });
      }
      if (_hasPain) {
        lesiones.add({
          'descripcion_molestia': _painCtrl.text.trim().isNotEmpty
              ? _painCtrl.text.trim() : 'Dolor crónico',
          'tipo_lesion':     'cronica',
          'zona_afectada':   _painCtrl.text.trim().isNotEmpty
              ? _painCtrl.text.trim() : 'No especificada',
          'nivel_dolor_eva': 5,
        });
      }
      if (_hasSurgery) {
        lesiones.add({
          'descripcion_molestia': _surgeryCtrl.text.trim().isNotEmpty
              ? _surgeryCtrl.text.trim() : 'Cirugía reciente',
          'tipo_lesion':     'cronica',
          'zona_afectada':   _surgeryCtrl.text.trim().isNotEmpty
              ? _surgeryCtrl.text.trim() : 'No especificada',
          'nivel_dolor_eva': 0,
        });
      }

      // 3. Guardar datos médicos — POST /onboarding/save-health-medical-data
      final body = {
        'cirugias_recientes':       _hasSurgery,
        'condicion_cardiovascular': _hasCardio,
        'lesiones_activas':         _hasInjury,
        'dolor_cronico':            _hasPain,
        'toma_medicacion_deporte':  false,
        'detalles_lesiones':        lesiones,
        'id_medicamentos':          <String>[],
      };

      final res = await http.post(
        Uri.parse('https://apifitnflai.com/onboarding/save-health-medical-data'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      debugPrint('STEP5 HEALTH: ${res.statusCode} ${res.body}');

      if (!mounted) return;

      if (res.statusCode == 200 || res.statusCode == 201) {
        // Save completed step 4 after successful API response
        if (userId != null) {
          await OnboardingRouter.saveCompletedStep(userId, 4);
        }
        if (!mounted) return;
        // Éxito — continuar al selector de tests
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.step5Test,
        );
      } else {
        // Error del servidor
        final msg = _parseError(res.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al guardar: $msg'),
          backgroundColor: AppColors.redMid,
          duration: const Duration(seconds: 3),
        ));
      }
    } catch (e) {
      debugPrint('STEP5 ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error de conexión. Verifica tu red e intenta de nuevo.'),
          backgroundColor: AppColors.redMid,
          duration: Duration(seconds: 3),
        ));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _parseError(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['detail'] != null) {
        final detail = decoded['detail'];
        if (detail is List && detail.isNotEmpty) {
          return detail.first['msg']?.toString() ?? 'Error desconocido';
        }
        return detail.toString();
      }
    } catch (_) {}
    return 'Error ${body.substring(0, body.length.clamp(0, 50))}';
  }

  @override
  void dispose() {
    _injuryDescCtrl.dispose();
    _injuryZonaCtrl.dispose();
    _injuryCtrl.dispose();
    _surgeryCtrl.dispose();
    _painCtrl.dispose();
    _cardioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(children: [
            const StepHeader(stepLabel: 'Paso 3 de 6'),
            const SizedBox(height: 16),
  
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Lesiones y condiciones ────────
                  _SectionCard(
                    title: l10n.onboardingBodyInjuriesTitle,
                    badge: _ObligatoryBadge(),
                    child: Column(children: [

                      _ToggleRow(
                        label: l10n.onboardingBodyInjuryActive,
                        value: _hasInjury,
                        onChanged: (v) => setState(() => _hasInjury = v),
                      ),
                      if (_hasInjury) ...[
                        const SizedBox(height: 12),
                        // descripcion_molestia
                        _FieldLabel(label: l10n.onboardingBodyInjuryDesc),
                        const SizedBox(height: 6),
                        _ConditionalInput(
                          controller: _injuryDescCtrl,
                          hint: l10n.onboardingBodyInjuryDescHint,
                        ),
                        const SizedBox(height: 12),
                        // zona_afectada
                        _FieldLabel(label: l10n.onboardingBodyInjuryZone),
                        const SizedBox(height: 6),
                        _ConditionalInput(
                          controller: _injuryZonaCtrl,
                          hint: l10n.onboardingBodyInjuryZoneHint,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 12),
                        // tipo_lesion
                        _FieldLabel(label: l10n.onboardingBodyInjuryType),
                        const SizedBox(height: 8),
                        Row(children: [
                          _TipoChip(
                            label: l10n.onboardingBodyInjuryTypeActive,
                            value: 'activa',
                            selected: _injuryTipoLesion == 'activa',
                            onTap: () => setState(() => _injuryTipoLesion = 'activa'),
                          ),
                          const SizedBox(width: 10),
                          _TipoChip(
                            label: l10n.onboardingBodyInjuryTypeChronic,
                            value: 'cronica',
                            selected: _injuryTipoLesion == 'cronica',
                            onTap: () => setState(() => _injuryTipoLesion = 'cronica'),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        // nivel_dolor_eva
                        _FieldLabel(label: l10n.onboardingBodyInjuryPainLevel),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Text('0', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppColors.orange,
                                inactiveTrackColor: const Color(0xFF3A3A3A),
                                thumbColor: AppColors.orange,
                                overlayColor: AppColors.orange.withValues(alpha: 0.2),
                                valueIndicatorColor: AppColors.orange,
                                valueIndicatorTextStyle: const TextStyle(color: AppColors.white),
                                showValueIndicator: ShowValueIndicator.onDrag,
                              ),
                              child: Slider(
                                value: _injuryNivelDolor,
                                min: 0,
                                max: 10,
                                divisions: 10,
                                label: _injuryNivelDolor.round().toString(),
                                onChanged: (v) => setState(() => _injuryNivelDolor = v),
                              ),
                            ),
                          ),
                          const Text('10', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.cardDark,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.orange, width: 1.5),
                            ),
                            child: Text(
                              _injuryNivelDolor.round().toString(),
                              style: const TextStyle(
                                  color: AppColors.orange,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 4),
                      ],

                      const Divider(color: AppColors.border, height: 20),
                      _ToggleRow(
                        label: l10n.onboardingBodySurgery,
                        value: _hasSurgery,
                        onChanged: (v) => setState(() => _hasSurgery = v),
                      ),
                      if (_hasSurgery) ...[
                        const SizedBox(height: 8),
                        _ConditionalInput(
                          controller: _surgeryCtrl,
                          hint: l10n.onboardingBodySurgeryHint,
                        ),
                      ],

                      const Divider(color: AppColors.border, height: 20),
                      _ToggleRow(
                        label: l10n.onboardingBodyPainChronic,
                        value: _hasPain,
                        onChanged: (v) => setState(() => _hasPain = v),
                      ),
                      if (_hasPain) ...[
                        const SizedBox(height: 8),
                        _ConditionalInput(
                          controller: _painCtrl,
                          hint: l10n.onboardingBodyPainChronicHint,
                        ),
                      ],

                      const Divider(color: AppColors.border, height: 20),
                      _ToggleRow(
                        label: l10n.onboardingBodyCardio,
                        value: _hasCardio,
                        onChanged: (v) => setState(() => _hasCardio = v),
                      ),
                      if (_hasCardio) ...[
                        const SizedBox(height: 8),
                        _ConditionalInput(
                          controller: _cardioCtrl,
                          hint: l10n.onboardingBodyCardioHint,
                        ),
                      ],
                    ]),
                  ),

                   // ── Composición corporal title ─────
                  Text(
                    l10n.onboardingBodyCompositionTitle,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.25),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.onboardingBodyCompositionDesc,
                    style: const TextStyle(
                        color: AppColors.grey, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // ── Subir informe ─────────────────
                  _SectionCard(
                    title: l10n.onboardingBodyUploadTitle,
                    badge: _OptionalBadge(),
                    child: Column(children: [
                      // Preview / placeholder dinámico
                      GestureDetector(
                        onTap: _showUploadChooser,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 28, horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.cardDark,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: _uploadingScale
                              ? Column(children: [
                                  const CircularProgressIndicator(color: AppColors.orange),
                                  const SizedBox(height: 12),
                                  Text(l10n.onboardingBodyUploadProcessing,
                                      style: const TextStyle(
                                          color: AppColors.greyLight,
                                          fontSize: 13)),
                                ])
                              : _uploadedFile == null
                              ? Column(children: [
                                  const Text('📤', style: TextStyle(fontSize: 36)),
                                  const SizedBox(height: 10),
                                  Text(l10n.onboardingBodyUploadScaleHint,
                                      style: const TextStyle(
                                          color: AppColors.greyLight,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  Text(
                                    l10n.onboardingBodyUploadScaleDesc,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 12,
                                        height: 1.4),
                                  ),
                                ])
                              : _isImage
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(_uploadedFile!,
                                          fit: BoxFit.cover,
                                          height: 180,
                                          width: double.infinity),
                                    )
                                  : Column(children: [
                                      const Text('📄',
                                          style: TextStyle(fontSize: 36)),
                                      const SizedBox(height: 8),
                                      Text(_uploadedFileName ?? '',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: AppColors.greenText,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 4),
                                      Text(locale == 'es' ? 'PDF cargado correctamente' : 'PDF loaded successfully',
                                          style: const TextStyle(
                                              color: AppColors.grey,
                                              fontSize: 12)),
                                      if (_scaleData != null) ...[
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.orange.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(locale == 'es' ? '✅ Datos extraídos' : '✅ Data extracted',
                                              style: const TextStyle(
                                                  color: AppColors.orange,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ]),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Botones subir
                      Row(children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: AppColors.cardDark,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _isImage && _uploadedFile != null
                                      ? AppColors.orange
                                      : AppColors.border,
                                  width: _isImage && _uploadedFile != null ? 1.5 : 1,
                                ),
                              ),
                              child: Column(children: [
                                const Text('🖼️', style: TextStyle(fontSize: 28)),
                                const SizedBox(height: 6),
                                Text(l10n.onboardingBodyUploadImageBtn,
                                    style: TextStyle(
                                        color: _isImage && _uploadedFile != null
                                            ? AppColors.orange
                                            : AppColors.greyLight,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ]),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: _pickPdf,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: AppColors.cardDark,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: !_isImage && _uploadedFile != null
                                      ? AppColors.orange
                                      : AppColors.border,
                                  width: !_isImage && _uploadedFile != null ? 1.5 : 1,
                                ),
                              ),
                              child: Column(children: [
                                const Text('📄', style: TextStyle(fontSize: 28)),
                                const SizedBox(height: 6),
                                Text(l10n.onboardingBodyUploadPdfBtn,
                                    style: TextStyle(
                                        color: !_isImage && _uploadedFile != null
                                            ? AppColors.orange
                                            : AppColors.greyLight,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ]),
                            ),
                          ),
                        ),
                      ]),
                      if (_uploadedFile != null) ...[
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => setState(() {
                            _uploadedFile     = null;
                            _uploadedFileName = null;
                          }),
                          child: Text(l10n.onboardingBodyUploadDeleteBtn,
                              style: const TextStyle(
                                  color: AppColors.redText,
                                  fontSize: 12)),
                        ),
                      ],
                    ]),
                  ),

                  // ── Optional note ─────────────────
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2A2A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.greenMid),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.greenText, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.onboardingBodyOptionalNote,
                            style: const TextStyle(
                                color: AppColors.greenText,
                                fontSize: 13,
                                height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Continuar button ──────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.orange))
                : PrimaryButton(
                    labelWidget: Text(l10n.onboardingContinue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    onTap: _saveAndContinue,
                  ),
          ),
        ]),
      ),
    ),
  );
}
}

// ═══════════════════════════════════════════════════════════════
// SECTION CARD
// ═══════════════════════════════════════════════════════════════
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget badge;
  final Widget child;
  const _SectionCard({
    required this.title,
    required this.badge,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: AppColors.card, borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  color: AppColors.orange,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 8),
        badge,
      ]),
      const SizedBox(height: 14),
      child,
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// TOGGLE ROW
// ═══════════════════════════════════════════════════════════════
class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(
      child: Text(label,
          style: const TextStyle(
              color: AppColors.greyLight, fontSize: 14)),
    ),
    Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.orange,
      activeTrackColor: const Color(0xFF8B3A15),
      inactiveThumbColor: AppColors.grey,
      inactiveTrackColor: const Color(0xFF3A3A3A),
    ),
  ]);
}

// ═══════════════════════════════════════════════════════════════
// CONDITIONAL INPUT (aparece al activar switch)
// ═══════════════════════════════════════════════════════════════
class _ConditionalInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  const _ConditionalInput({
    required this.controller,
    required this.hint,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    style: const TextStyle(color: AppColors.white, fontSize: 14),
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.grey, fontSize: 13),
      filled: true,
      fillColor: AppColors.cardDark,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.orange, width: 1.5)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.orange, width: 1.5)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.orange, width: 2)),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// FIELD LABEL
// ═══════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════
// SCALE METRIC TILE
// ═══════════════════════════════════════════════════════════════
class _ScaleMetricTile extends StatelessWidget {
  final String label, value;
  const _ScaleMetricTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.orange.withValues(alpha: 0.4)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.grey, fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: AppColors.orange,
                fontSize: 16,
                fontWeight: FontWeight.w800)),
      ],
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// FIELD LABEL
// ═══════════════════════════════════════════════════════════════
class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: const TextStyle(
        color: AppColors.greyLight,
        fontSize: 13,
        fontWeight: FontWeight.w600),
  );
}

// ═══════════════════════════════════════════════════════════════
// TIPO CHIP (activa / crónica)
// ═══════════════════════════════════════════════════════════════
class _TipoChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;
  const _TipoChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF8B3A15) : AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.orange : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.orange : AppColors.grey,
          fontSize: 13,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════
// BADGES
// ═══════════════════════════════════════════════════════════════
class _ObligatoryBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        color: const Color(0xFF3A1515),
        borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: const [
      CircleAvatar(radius: 3, backgroundColor: AppColors.redText),
      SizedBox(width: 5),
      Text('Obligatorio',
          style: TextStyle(
              color: AppColors.redText,
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    ]),
  );
}

class _OptionalBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        color: AppColors.greenBg, borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: const [
      CircleAvatar(radius: 3, backgroundColor: AppColors.greenText),
      SizedBox(width: 5),
      Text('Opcional',
          style: TextStyle(
              color: AppColors.greenText,
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    ]),
  );
}