import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../config/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../config/app_theme_extension.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';

class PeriodicEvaluationScreen extends StatefulWidget {
  const PeriodicEvaluationScreen({super.key});
  @override
  State<PeriodicEvaluationScreen> createState() => _PeriodicEvaluationScreenState();
}

class _PeriodicEvaluationScreenState extends State<PeriodicEvaluationScreen> {
  final _pesoCtrl   = TextEditingController(text: '87.1');
  final _alturaCtrl = TextEditingController(text: '179');
  String _pesoUnit   = 'Kg';
  String _alturaUnit = 'Cm';

  File? _uploadedFile;
  String? _uploadedFileName;
  bool _saving = false;

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _uploadedFile = File(picked.path);
          _uploadedFileName = picked.name;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          _uploadedFile = File(result.files.single.path!);
          _uploadedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      debugPrint('Error picking PDF: $e');
    }
  }

  Future<void> _saveEvaluation() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final token = context.read<AuthProvider>().token ?? '';
      final req = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}/users/actualizar-test-periodico'),
      );
      req.headers['Authorization'] = 'Bearer $token';

      final pesoVal = double.tryParse(_pesoCtrl.text.trim());
      if (pesoVal != null) {
        req.fields['peso'] = pesoVal.toString();
        req.fields['unidad_peso'] = _pesoUnit;
      }

      final alturaVal = double.tryParse(_alturaCtrl.text.trim());
      if (alturaVal != null) {
        req.fields['altura'] = alturaVal.toString();
        req.fields['unidad_altura'] = _alturaUnit;
      }

      if (_uploadedFile != null) {
        final ext = _uploadedFile!.path.split('.').last.toLowerCase();
        final mimeType = ext == 'pdf' ? 'application/pdf' : 'image/jpeg';
        final mediaParts = mimeType.split('/');
        req.files.add(await http.MultipartFile.fromPath(
          'file',
          _uploadedFile!.path,
          contentType: http.MediaType(mediaParts[0], mediaParts[1]),
        ));
      }

      final streamed = await req.send();
      final res = await http.Response.fromStream(streamed);
      debugPrint('ACTUALIZAR TEST: ${res.statusCode} — ${res.body}');

      if (!mounted) return;
      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Localizations.localeOf(context).languageCode == 'es'
                  ? '✅ Evaluación guardada correctamente'
                  : '✅ Evaluation saved successfully',
            ),
            backgroundColor: const Color(0xFF2E6B4F),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Localizations.localeOf(context).languageCode == 'es'
                  ? 'Error al guardar la evaluación'
                  : 'Error saving evaluation',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving evaluation: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _pesoCtrl.dispose();
    _alturaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: FitnflaiAppBar(title: l10n.periodicEvalTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Banner opcional ──────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.greenBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.successBorder),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.loop, color: theme.successText, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.periodicEvalBanner,
                  style: TextStyle(color: theme.successText.withValues(alpha: 0.8), fontSize: 13, height: 1.5),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),

          // ── Medidas corporales ───────────────────────
          Container(
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.border),
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 4),
                child: Center(
                  child: Text(l10n.periodicEvalMetrics,
                      style: TextStyle(color: theme.primary,
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
              Divider(color: theme.border, height: 1),
              _MedidaRow(
                label: l10n.periodicEvalWeight,
                controller: _pesoCtrl,
                unit: _pesoUnit,
                unitOptions: const ['Kg', 'Lb'],
                onUnitChanged: (v) => setState(() => _pesoUnit = v!),
              ),
              Divider(color: theme.border, height: 1, indent: 16),
              _MedidaRow(
                label: l10n.periodicEvalHeight,
                controller: _alturaCtrl,
                unit: _alturaUnit,
                unitOptions: const ['Cm', 'In'],
                onUnitChanged: (v) => setState(() => _alturaUnit = v!),
                isLast: true,
              ),
            ]),
          ),
          const SizedBox(height: 24),

          // ── ¿Tienes datos de composición corporal? ───
          Text(l10n.periodicEvalCompTitle,
              style: TextStyle(color: theme.text,
                  fontSize: 24, fontWeight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 10),
          Text(
            l10n.periodicEvalCompDesc,
            style: TextStyle(color: theme.textSecondary, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 20),

          // ── Subir informe ────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Row(children: [
                  Text(l10n.periodicEvalUploadTitle,
                      style: TextStyle(color: theme.primary,
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.greenBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.successBorder),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.circle, color: theme.successText, size: 8),
                      const SizedBox(width: 5),
                      Text(l10n.periodicEvalOptional,
                          style: TextStyle(color: theme.successText,
                              fontSize: 11, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ]),
              ),
              Divider(color: theme.border, height: 1),

              // Drop zone
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(
                      color: theme.cardDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: theme.border, style: BorderStyle.solid),
                    ),
                    child: Column(children: [
                      Icon(
                        _uploadedFile != null ? Icons.file_present_outlined : Icons.folder_open_outlined,
                        color: theme.primary,
                        size: 44,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _uploadedFileName ?? l10n.periodicEvalUploadHint,
                        style: TextStyle(color: theme.text,
                            fontSize: 13, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          _uploadedFile != null
                              ? 'Archivo listo para subir'
                              : l10n.periodicEvalUploadDesc,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.textMuted,
                              fontSize: 12, height: 1.4),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),

                  // Botones subir
                  Row(children: [
                    Expanded(child: _UploadButton(
                      icon: Icons.photo_camera_outlined,
                      label: l10n.periodicEvalUploadPhoto,
                      onTap: _pickImage,
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _UploadButton(
                      icon: Icons.picture_as_pdf_outlined,
                      label: l10n.periodicEvalUploadPdf,
                      onTap: _pickPdf,
                    )),
                  ]),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 32),

          PrimaryButton(
            labelWidget: _saving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : Text(l10n.periodicEvalSave, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            onTap: _saving ? null : _saveEvaluation,
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }
}

// ── Fila de medida ────────────────────────────────────────────
class _MedidaRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String unit;
  final List<String> unitOptions;
  final ValueChanged<String?> onUnitChanged;
  final bool isLast;
  const _MedidaRow({
    required this.label, required this.controller,
    required this.unit, required this.unitOptions,
    required this.onUnitChanged, this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Expanded(child: Text(label,
            style: TextStyle(color: theme.textSecondary, fontSize: 14))),
        // Campo numérico
        SizedBox(
          width: 72,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: theme.cardDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.border),
            ),
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
              style: TextStyle(color: theme.text,
                  fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  isDense: true, border: InputBorder.none,
                  contentPadding: EdgeInsets.zero),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Dropdown unidad
        SizedBox(
          width: 80,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: theme.cardDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: unit,
                dropdownColor: theme.card,
                isDense: true,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down,
                    color: theme.textMuted, size: 16),
                style: TextStyle(color: theme.text,
                    fontSize: 13, fontWeight: FontWeight.w600),
                items: unitOptions.map((u) => DropdownMenuItem(
                    value: u, child: Text(u.toLowerCase()))).toList(),
                onChanged: onUnitChanged,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Botón de subida ───────────────────────────────────────────
class _UploadButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _UploadButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: theme.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.border),
        ),
        child: Column(children: [
          Icon(icon, color: theme.primary, size: 28),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(
              color: theme.text, fontSize: 13, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}