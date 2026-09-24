import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/onboarding_router.dart'; // Added
import '../../providers/auth_provider.dart';
import '../../widgets/shared_widgets.dart';

class Step2ProfileScreen extends StatefulWidget {
  const Step2ProfileScreen({super.key});
  @override
  State<Step2ProfileScreen> createState() => _Step2ProfileScreenState();
}

class _Step2ProfileScreenState extends State<Step2ProfileScreen> {
  // Perfil básico
  DateTime? _birthDate;
  bool? _isMale;

  // Medidas corporales
  final _weightCtrl = TextEditingController();
  String _weightUnit = 'Kg';
  final _heightCtrl = TextEditingController();
  String _heightUnit = 'Cm';

  // Ciudad y altitud
  final _cityCtrl    = TextEditingController();
  final _altCtrl     = TextEditingController();
  String? _selectedCityId;
  String  _selectedCityName = '';
  List<Map<String, dynamic>> _citySuggestions = [];
  bool _searchingCity = false;

  // Ciclo menstrual (solo si femenino)
  bool _menstrualActive = false;
  DateTime? _cycleStart;
  DateTime? _cycleEnd;

  String _getMonthName(BuildContext context, int month) {
    final locale = Localizations.localeOf(context).languageCode;
    const monthsEs = ['', 'ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    const monthsEn = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return locale == 'es' ? monthsEs[month] : monthsEn[month];
  }

  String _fmtDate(BuildContext context, DateTime d) =>
      '${d.day} ${_getMonthName(context, d.month)} ${d.year}';

  String _fmtRange(BuildContext context, DateTime? s, DateTime? e) {
    final l10n = AppLocalizations.of(context);
    if (s == null || e == null) return l10n.onboardingProfileMenstrualSelectDates;
    return l10n.onboardingProfileMenstrualRange(s.day, e.day, _getMonthName(context, e.month));
  }

  @override
  void initState() {
    super.initState();
    _weightCtrl.addListener(() => setState(() {}));
    _heightCtrl.addListener(() => setState(() {}));
    _cityCtrl.addListener(() => setState(() {}));
    _altCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    _cityCtrl.dispose();
    _altCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.orange,
            surface: AppColors.card,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) setState(() => _birthDate = picked);
  }

  Future<void> _pickCycleDate(bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_cycleStart ?? now)
          : (_cycleEnd ?? (_cycleStart?.add(const Duration(days: 5)) ?? now)),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.orange,
            surface: AppColors.card,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isStart) { _cycleStart = picked; }
        else          { _cycleEnd   = picked; }
      });
    }
  }

  // Lat/lon de la ciudad seleccionada para Open Elevation
  bool _fetchingElevation = false;

  Future<void> _searchCity(String q) async {
    if (q.length < 2) {
      setState(() => _citySuggestions = []);
      return;
    }
    setState(() => _searchingCity = true);
    try {
      // Nominatim — filtra solo ciudades/pueblos para resultados más limpios
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q':              q,
        'format':         'json',
        'addressdetails': '1',
        'limit':          '6',
        'featuretype':    'city',
        'accept-language':'es',
      });
      final res = await http.get(uri, headers: {
        'User-Agent':  'FitnflaiApp/1.0 (contact@fitnflai.com)',
        'Accept':      'application/json',
      }).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        setState(() {
          _citySuggestions = list.map((e) {
            final addr  = e['address'] as Map<String, dynamic>? ?? {};
            final city  = addr['city']         ??
                          addr['town']          ??
                          addr['village']       ??
                          addr['municipality']  ??
                          addr['county']        ??
                          e['display_name']     ?? '';
            final state = addr['state'] ?? addr['region'] ?? addr['county'] ?? '';
            final country = addr['country'] ?? '';
            return {
              'nombre':  city.toString(),
              'estado':  state.toString(),
              'pais':    country.toString(),
              'lat':     double.tryParse(e['lat'].toString()) ?? 0.0,
              'lon':     double.tryParse(e['lon'].toString()) ?? 0.0,
            };
          }).where((c) => (c['nombre'] as String).isNotEmpty).toList();
        });
      }
    } catch (e) {
      debugPrint('CITY SEARCH ERROR: $e');
    } finally {
      setState(() => _searchingCity = false);
    }
  }

  Future<void> _fetchElevation(double lat, double lon) async {
    setState(() => _fetchingElevation = true);
    try {
      final uri = Uri.parse(
        'https://api.open-elevation.com/api/v1/lookup'
        '?locations=$lat,$lon',
      );
      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final results = data['results'] as List?;
        if (results != null && results.isNotEmpty) {
          final elevation = (results[0]['elevation'] as num).round();
          setState(() => _altCtrl.text = elevation.toString());
        }
      }
    } catch (e) {
      debugPrint('ELEVATION ERROR: $e');
    } finally {
      setState(() => _fetchingElevation = false);
    }
  }

  bool _loading = false;

  Future<void> _saveAndContinue() async {
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.token;
    final userId = authProvider.user?.id;
    setState(() => _loading = true);
    try {

      final body = <String, dynamic>{
        'adaptacion_ciclo_menstrual': (_isMale == false) && _menstrualActive,
        'altitud_msnm':               int.tryParse(_altCtrl.text) ?? 0,
        'altura':                     double.tryParse(_heightCtrl.text) ?? 0,
        'ciudad':                     _selectedCityName,
        'genero':                     _isMale == true ? 'Masculino' : 'Femenino',
        'peso':                       double.tryParse(_weightCtrl.text) ?? 0,
        'unidad_altura':              _heightUnit,
        'unidad_peso':                _weightUnit,
      };

      // Fecha nacimiento — solo si está seleccionada
      if (_birthDate != null) {
        body['fecha_nacimiento'] =
            '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2,'0')}-${_birthDate!.day.toString().padLeft(2,'0')}';
      }

      // Ciclo menstrual — solo si aplica
      if ((_isMale == false) && _menstrualActive) {
        if (_cycleStart != null) {
          body['fecha_inicio_periodo'] =
              '${_cycleStart!.year}-${_cycleStart!.month.toString().padLeft(2,'0')}-${_cycleStart!.day.toString().padLeft(2,'0')}';
        }
        if (_cycleEnd != null) {
          body['fecha_fin_periodo'] =
              '${_cycleEnd!.year}-${_cycleEnd!.month.toString().padLeft(2,'0')}-${_cycleEnd!.day.toString().padLeft(2,'0')}';
        }
      }

      debugPrint('STEP3 BODY: ${jsonEncode(body)}');
      final res = await http.post(
        Uri.parse('https://apifitnflai.com/onboarding/save-basic-profile-body-metrics-data'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      debugPrint('STEP3 RESPONSE: ${res.statusCode} ${res.body}');

      if (res.statusCode != 200 && res.statusCode != 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).onboardingSaveError(res.statusCode)),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      // Save completed step 2 after successful API response
      if (userId != null) {
        await OnboardingRouter.saveCompletedStep(userId, 2);
      }
    } catch (e) {
      debugPrint('STEP3 ERROR: $e');
      return;
    } finally {
      setState(() => _loading = false);
    }
    if (!mounted) return;
    Navigator.pushNamed(context, AppRoutes.step3Fitness);
  }

  bool get _isValid =>
      _birthDate != null &&
      _isMale != null &&
      _weightCtrl.text.isNotEmpty &&
      _heightCtrl.text.isNotEmpty &&
      _selectedCityId != null &&
      _altCtrl.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          const StepHeader(stepLabel: 'Paso 1 de 6'),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [

                // ── Perfil básico ─────────────────
                _Card(
                  title: l10n.onboardingProfileBasicTitle,
                  badge: _ObligatoryBadge(),
                  child: Column(children: [
                    _FieldRow(
                      label: l10n.onboardingProfileBirthdate,
                      field: Expanded(
                        child: GestureDetector(
                          onTap: _pickBirthDate,
                          child: _FullDropBox(
                            text: _birthDate != null
                                ? _fmtDate(context, _birthDate!)
                                : l10n.onboardingProfileBirthdateHint,
                            isEmpty: _birthDate == null,
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 24),
                    _FieldRow(
                      label: l10n.onboardingProfileGender,
                      field: Expanded(
                        child: Row(children: [
                          Expanded(child: _GenderBtn(
                            label: l10n.onboardingProfileGenderMale,
                            selected: _isMale == true,
                            onTap: () => setState(() => _isMale = true),
                          )),
                          const SizedBox(width: 8),
                          Expanded(child: _GenderBtn(
                            label: l10n.onboardingProfileGenderFemale,
                            selected: _isMale == false,
                            onTap: () => setState(() => _isMale = false),
                          )),
                        ]),
                      ),
                    ),
                  ]),
                ),

                // ── Medidas corporales ────────────
                _Card(
                  title: l10n.onboardingProfileMetricsTitle,
                  badge: _ObligatoryBadge(),
                  child: Column(children: [
                    _FieldRow(
                      label: l10n.onboardingProfileWeight,
                      field: Expanded(
                        child: _NumUnitField(
                          controller: _weightCtrl,
                          hint: _weightUnit.toLowerCase() == 'kg' ? '70.0' : '150.0',
                          unit: _weightUnit,
                          units: const ['Kg', 'Lb'],
                          onUnitChanged: (u) => setState(() => _weightUnit = u),
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 24),
                    _FieldRow(
                      label: l10n.onboardingProfileHeight,
                      field: Expanded(
                        child: _NumUnitField(
                          controller: _heightCtrl,
                          hint: _heightUnit.toLowerCase() == 'cm' ? '170' : '5.6',
                          unit: _heightUnit,
                          units: const ['Cm', 'Ft'],
                          onUnitChanged: (u) => setState(() => _heightUnit = u),
                        ),
                      ),
                    ),
                  ]),
                ),

                // ── Ciudad y altitud ──────────────
                _Card(
                  title: l10n.onboardingProfileCityTitle,
                  badge: _ObligatoryBadge(),
                  child: Column(children: [
                    _FieldRow(
                      label: l10n.onboardingProfileCity,
                      field: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _cityCtrl,
                              style: const TextStyle(color: AppColors.white, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: l10n.onboardingProfileCityHint,
                                hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
                                filled: true,
                                fillColor: AppColors.cardDark,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.orange, width: 1.5)),
                                suffixIcon: _searchingCity
                                    ? const SizedBox(width: 16, height: 16, child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.orange)))
                                    : _selectedCityId != null
                                        ? const Icon(Icons.check_circle, color: AppColors.greenText, size: 20)
                                        : null,
                              ),
                              onChanged: (v) {
                                setState(() => _selectedCityId = null);
                                _searchCity(v);
                              },
                            ),
                            if (_citySuggestions.isNotEmpty && _selectedCityId == null)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  children: _citySuggestions.take(5).map((c) => InkWell(
                                    onTap: () {
                                      final lat    = c['lat'] as double? ?? 0.0;
                                      final lon    = c['lon'] as double? ?? 0.0;
                                      final nombre = c['nombre'] as String? ?? '';
                                      final estado = c['estado'] as String? ?? '';
                                      setState(() {
                                        _selectedCityId   = '${lat}_$lon';
                                        _selectedCityName = nombre; // solo nombre sin estado
                                        _cityCtrl.text    = estado.isNotEmpty
                                            ? '$nombre, $estado' : nombre;
                                        _citySuggestions  = [];
                                      });
                                      if (lat != 0.0 || lon != 0.0) {
                                        _fetchElevation(lat, lon);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      child: Row(children: [
                                        const Icon(Icons.location_on_outlined, color: AppColors.grey, size: 16),
                                        const SizedBox(width: 8),
                                         Expanded(child: Text(
                                           c['estado'].toString().isNotEmpty
                                               ? '${c['nombre']}, ${c['estado']}'
                                               : c['nombre'].toString(),
                                           style: const TextStyle(color: AppColors.white, fontSize: 13),
                                           overflow: TextOverflow.ellipsis,
                                           maxLines: 1,
                                         )),
                                      ]),
                                    ),
                                  )).toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 24),
                    _FieldRow(
                      label: l10n.onboardingProfileAltitude,
                      field: Expanded(
                        child: _fetchingElevation
                            ? Row(children: [
                                const SizedBox(
                                  width: 18, height: 18,
                                  child: CircularProgressIndicator(
                                      color: AppColors.orange, strokeWidth: 2),
                                ),
                                const SizedBox(width: 10),
                                Text(l10n.onboardingProfileCitySearching,
                                    style: const TextStyle(color: AppColors.grey, fontSize: 13)),
                              ])
                            : _InputBox(
                                controller: _altCtrl,
                                hint: l10n.onboardingProfileAltitudeHint,
                                keyboardType: TextInputType.number,
                                suffix: 'm.s.n.m.',
                              ),
                      ),
                    ),
                  ]),
                ),

                // ── Altitud banner ────────────────
                if (_altCtrl.text.isNotEmpty) ...[
                  _AltitudeBanner(altitud: _altCtrl.text),
                  const SizedBox(height: 14),
                ],

                // ── Ciclo menstrual (solo femenino) ─
                if (_isMale == false)
                  _Card(
                    title: l10n.onboardingProfileMenstrualTitle,
                    badge: _OptionalBadge(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Toggle
                        Row(children: [
                          Expanded(
                            child: Text(l10n.onboardingProfileMenstrualToggle,
                                style: const TextStyle(
                                    color: AppColors.greyLight, fontSize: 14)),
                          ),
                          Switch(
                            value: _menstrualActive,
                            onChanged: (v) =>
                                setState(() => _menstrualActive = v),
                            activeThumbColor: AppColors.orange,
                            activeTrackColor: const Color(0xFF8B3A15),
                            inactiveThumbColor: AppColors.grey,
                            inactiveTrackColor: const Color(0xFF3A3A3A),
                          ),
                        ]),
                        Text(
                          l10n.onboardingProfileMenstrualDesc,
                          style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                              height: 1.5),
                        ),

                        // Fechas de ciclo (solo si switch activo)
                        if (_menstrualActive) ...[
                          const SizedBox(height: 16),
                          const Divider(color: AppColors.border, height: 0),
                          const SizedBox(height: 16),
                          Text(l10n.onboardingProfileMenstrualLastCycle,
                              style: const TextStyle(
                                  color: AppColors.greyLight,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                           Row(children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.onboardingProfileMenstrualCycleStart,
                                      style: const TextStyle(
                                          color: AppColors.grey, fontSize: 12)),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () => _pickCycleDate(true),
                                    child: _FullDropBox(
                                      text: _cycleStart != null
                                          ? _fmtDate(context, _cycleStart!)
                                          : l10n.onboardingProfileMenstrualSelect,
                                      isEmpty: _cycleStart == null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.onboardingProfileMenstrualCycleEnd,
                                      style: const TextStyle(
                                          color: AppColors.grey, fontSize: 12)),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () => _pickCycleDate(false),
                                    child: _FullDropBox(
                                      text: _cycleEnd != null
                                          ? _fmtDate(context, _cycleEnd!)
                                          : l10n.onboardingProfileMenstrualSelect,
                                      isEmpty: _cycleEnd == null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          if (_cycleStart != null && _cycleEnd != null) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A2A3A),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xFF3A5A8A)),
                              ),
                              child: Row(children: [
                                const Icon(Icons.calendar_today,
                                    color: AppColors.orange, size: 14),
                                const SizedBox(width: 8),
                                Text(
                                  _fmtRange(context, _cycleStart, _cycleEnd),
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),

                const SizedBox(height: 16),
              ]),
            ),
          ),

          // ── Continuar ────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.orange))
                : PrimaryButton(
                    labelWidget: Text(l10n.onboardingContinue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    enabled: _isValid,
                    onTap: _saveAndContinue,
                  ),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CARD
// ═══════════════════════════════════════════════════════════════
class _Card extends StatelessWidget {
  final String title;
  final Widget badge;
  final Widget child;
  const _Card({required this.title, required this.badge, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: AppColors.card, borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(title,
            style: const TextStyle(
                color: AppColors.orange,
                fontSize: 15,
                fontWeight: FontWeight.w700)),
        const Spacer(),
        badge,
      ]),
      const SizedBox(height: 14),
      child,
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// FIELD ROW — label ancho fijo + campo expandido
// ═══════════════════════════════════════════════════════════════
class _FieldRow extends StatelessWidget {
  final String label;
  final Widget field; // debe ser Expanded
  const _FieldRow({required this.label, required this.field});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: 110,
        child: Text(label,
            style: const TextStyle(
                color: AppColors.greyLight,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
      ),
      const SizedBox(width: 10),
      field,
    ],
  );
}

// ═══════════════════════════════════════════════════════════════
// FULL WIDTH DROP BOX (fecha)
// ═══════════════════════════════════════════════════════════════
class _FullDropBox extends StatelessWidget {
  final String text;
  final bool isEmpty;
  const _FullDropBox({required this.text, this.isEmpty = false});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(
      color: AppColors.cardDark,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(children: [
      Expanded(
        child: Text(text,
            style: TextStyle(
                color: isEmpty ? AppColors.grey : AppColors.white,
                fontSize: 14,
                fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w500)),
      ),
      const Icon(Icons.keyboard_arrow_down,
          color: AppColors.orange, size: 20),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// INPUT BOX — ancho completo
// ═══════════════════════════════════════════════════════════════
class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final String? suffix;
  const _InputBox({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    inputFormatters: keyboardType == TextInputType.number
        ? [FilteringTextInputFormatter.digitsOnly]
        : null,
    style: const TextStyle(color: AppColors.white, fontSize: 14),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
      suffixText: suffix,
      suffixStyle: const TextStyle(color: AppColors.grey, fontSize: 13),
      filled: true,
      fillColor: AppColors.cardDark,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.orange, width: 1.5)),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// NUM + UNIT FIELD — ancho completo, número expandido
// ═══════════════════════════════════════════════════════════════
class _NumUnitField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String unit;
  final List<String> units;
  final ValueChanged<String> onUnitChanged;
  const _NumUnitField({
    required this.controller,
    required this.hint,
    required this.unit,
    required this.units,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) => Row(children: [
    // Número — ocupa todo el espacio disponible
    Expanded(
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        ],
        style: const TextStyle(
            color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
          filled: true,
          fillColor: AppColors.cardDark,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.orange, width: 1.5)),
        ),
      ),
    ),
    const SizedBox(width: 10),
    // Unidad — ancho fijo simétrico
    GestureDetector(
      onTap: () => _showUnitPicker(context),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(unit.toLowerCase(),
              style: const TextStyle(
                  color: AppColors.greyLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down,
              color: AppColors.orange, size: 18),
        ]),
      ),
    ),
  ]);

  void _showUnitPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: units
              .map((u) => ListTile(
                    title: Text(u.toLowerCase(),
                        style: const TextStyle(
                            color: AppColors.white, fontSize: 15)),
                    trailing: u == unit
                        ? const Icon(Icons.check,
                            color: AppColors.orange)
                        : null,
                    onTap: () {
                      onUnitChanged(u);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// GENDER BUTTON
// ═══════════════════════════════════════════════════════════════
class _GenderBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _GenderBtn({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF3A1F0A) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: selected ? AppColors.orange : AppColors.border),
      ),
      child: Center(
        child: Text(label,
            style: TextStyle(
                color: selected ? AppColors.orange : AppColors.greyLight,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// ALTITUDE BANNER
// ═══════════════════════════════════════════════════════════════
class _AltitudeBanner extends StatelessWidget {
  final String altitud;
  const _AltitudeBanner({this.altitud = ''});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF1A1A3A),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF3A3A8A)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      const Row(children: [
        Text('🏔️', style: TextStyle(fontSize: 18)),
        SizedBox(width: 8),
        Text('Altitud inteligente activada',
            style: TextStyle(
                color: Color(0xFF9B9BFF),
                fontSize: 14,
                fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 4),
      Text(
        altitud.isNotEmpty
            ? 'Tu plan ajusta zonas FC, hidratación y recuperación para $altitud m s.n.m.'
            : 'Tu plan ajusta zonas FC, hidratación y recuperación según tu altitud.',
        style: const TextStyle(
            color: AppColors.greyLight, fontSize: 12, height: 1.4),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A5A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF5A5AB0)),
        ),
        child: Text(
          altitud.isNotEmpty
              ? '🏔️  $altitud m s.n.m. · Corrección activa'
              : '🏔️  Corrección activa',
          style: const TextStyle(
              color: Color(0xFF9B9BFF),
              fontSize: 11,
              fontWeight: FontWeight.w500)),
      ),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// BADGES
// ═══════════════════════════════════════════════════════════════
class _ObligatoryBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding:
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        color: const Color(0xFF3A1515),
        borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      const CircleAvatar(radius: 3, backgroundColor: AppColors.redText),
      const SizedBox(width: 5),
      Text(AppLocalizations.of(context).onboardingSportObligatory,
          style: const TextStyle(
              color: AppColors.redText,
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    ]),
  );
}

class _OptionalBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding:
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        color: AppColors.greenBg,
        borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      const CircleAvatar(radius: 3, backgroundColor: AppColors.greenText),
      const SizedBox(width: 5),
      Text(AppLocalizations.of(context).onboardingProfileOptional,
          style: const TextStyle(
              color: AppColors.greenText,
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    ]),
  );
}