import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../config/app_theme_extension.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/shared_widgets.dart';
import '../membership/membership_screen.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../services/cached_http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey    = GlobalKey<FormState>();
  late TextEditingController _apodoCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _ciudadCtrl;
  late TextEditingController _altitudCtrl;
  File?   _avatarFile;
  String? _avatarUrl;
  bool _dirty   = false;
  bool _loading = true;

  String? _selectedCityName;
  List<Map<String, dynamic>> _citySuggestions = [];
  bool _searchingCity     = false;
  bool _fetchingElevation = false;

  static const _base = 'https://apifitnflai.com';

  @override
  void initState() {
    super.initState();
    _apodoCtrl   = TextEditingController();
    _emailCtrl   = TextEditingController();
    _ciudadCtrl  = TextEditingController();
    _altitudCtrl = TextEditingController();
    for (final c in [_apodoCtrl, _emailCtrl, _ciudadCtrl, _altitudCtrl]) {
      c.addListener(() => setState(() => _dirty = true));
    }
    _ciudadCtrl.addListener(() {
      if (_selectedCityName != null && _ciudadCtrl.text != _selectedCityName) {
        _selectedCityName = null;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  @override
  void dispose() {
    _apodoCtrl.dispose();
    _emailCtrl.dispose();
    _ciudadCtrl.dispose();
    _altitudCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final res = await CachedHttp.get(
        Uri.parse('$_base/users/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final d = jsonDecode(res.body) as Map<String, dynamic>;
        _apodoCtrl.text   = d['apodo']  as String? ?? '';
        _emailCtrl.text   = d['email']  as String? ?? '';
        _ciudadCtrl.text  = d['ciudad'] as String? ?? '';
        _selectedCityName = _ciudadCtrl.text.isNotEmpty ? _ciudadCtrl.text : null;
        _altitudCtrl.text = (d['altitud'] as num?)?.toString() ?? '';
        _avatarUrl        = d['foto_avatar_url'] as String?;
      }
    } catch (e) {
      debugPrint('LOAD PROFILE ERROR: $e');
    } finally {
      if (mounted) setState(() { _loading = false; _dirty = false; });
    }
  }

  Future<void> _searchCity(String q) async {
    if (q.length < 2) { setState(() => _citySuggestions = []); return; }
    setState(() => _searchingCity = true);
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': q, 'format': 'json', 'addressdetails': '1',
        'limit': '6', 'featuretype': 'city', 'accept-language': 'es',
      });
      final res = await CachedHttp.get(uri, headers: {
        'User-Agent': 'FitnflaiApp/1.0 (contact@fitnflai.com)',
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        setState(() {
          _citySuggestions = list.map((e) {
            final addr    = e['address'] as Map<String, dynamic>? ?? {};
            final city    = addr['city'] ?? addr['town'] ?? addr['village'] ??
                            addr['municipality'] ?? addr['county'] ?? e['display_name'] ?? '';
            final state   = addr['state'] ?? addr['region'] ?? addr['county'] ?? '';
            final country = addr['country'] ?? '';
            return {
              'nombre': city.toString(), 'estado': state.toString(),
              'pais':   country.toString(),
              'lat':    double.tryParse(e['lat'].toString()) ?? 0.0,
              'lon':    double.tryParse(e['lon'].toString()) ?? 0.0,
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
      final res = await CachedHttp.get(
        Uri.parse('https://api.open-elevation.com/api/v1/lookup?locations=$lat,$lon'),
      ).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data    = jsonDecode(res.body) as Map<String, dynamic>;
        final results = data['results'] as List?;
        if (results != null && results.isNotEmpty) {
          final elevation = (results[0]['elevation'] as num).round();
          setState(() { _altitudCtrl.text = elevation.toString(); _dirty = true; });
        }
      }
    } catch (e) {
      debugPrint('ELEVATION ERROR: $e');
    } finally {
      setState(() => _fetchingElevation = false);
    }
  }

  Future<void> _pickAvatar() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.themeColors.card,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: context.themeColors.border,
                  borderRadius: BorderRadius.circular(2))),
          Text(AppLocalizations.of(context).editProfileChangePhoto,
              style: TextStyle(color: context.themeColors.text, fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _PickOption(
            icon: Icons.photo_camera_outlined,
            label: AppLocalizations.of(context).editProfileTakePhoto,
            onTap: () async {
              Navigator.pop(context);
              final img = await ImagePicker()
                  .pickImage(source: ImageSource.camera, imageQuality: 80);
              if (img != null) setState(() { _avatarFile = File(img.path); _dirty = true; });
            },
          ),
          const SizedBox(height: 8),
          _PickOption(
            icon: Icons.photo_library_outlined,
            label: AppLocalizations.of(context).editProfileChooseGallery,
            onTap: () async {
              Navigator.pop(context);
              final img = await ImagePicker()
                  .pickImage(source: ImageSource.gallery, imageQuality: 80);
              if (img != null) setState(() { _avatarFile = File(img.path); _dirty = true; });
            },
          ),
          if (_avatarFile != null) ...[
            const SizedBox(height: 8),
            _PickOption(
              icon: Icons.delete_outline,
              label: AppLocalizations.of(context).editProfileDeletePhoto,
              color: context.themeColors.errorText,
              onTap: () {
                Navigator.pop(context);
                setState(() { _avatarFile = null; _dirty = true; });
              },
            ),
          ],
        ]),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    try {
      final patchRes = await CachedHttp.patch(
        Uri.parse('$_base/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'apodo':   _apodoCtrl.text.trim(),
          'email':   _emailCtrl.text.trim(),
          'ciudad':  _selectedCityName ?? _ciudadCtrl.text.trim(),
          'altitud': int.tryParse(_altitudCtrl.text.trim()) ?? 0,
        }),
      );
      debugPrint('PATCH STATUS: ${patchRes.statusCode}');
      debugPrint('PATCH BODY: ${patchRes.body}');
      if (patchRes.statusCode != 200) throw Exception('PATCH ${patchRes.statusCode}');

      if (_avatarFile != null) {
        final req = http.MultipartRequest('POST', Uri.parse('$_base/users/me/avatar'))
          ..headers['Authorization'] = 'Bearer $token'
          ..files.add(await http.MultipartFile.fromPath('file', _avatarFile!.path));
        final avatarRes = await req.send();
        debugPrint('AVATAR STATUS: ${avatarRes.statusCode}');
        if (avatarRes.statusCode != 200) throw Exception('AVATAR ${avatarRes.statusCode}');
        // Explicitly clear cache after avatar upload for consistency
        CachedHttp.clearCache();
      }

      if (!mounted) return;
      await context.read<ProfileProvider>().saveProfile(token, nombre: _apodoCtrl.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).editProfileSuccess),
        backgroundColor: context.themeColors.successBorder,
      ));
      Navigator.pop(context);
    } catch (e) {
      debugPrint('SAVE PROFILE ERROR: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).editProfileError),
        backgroundColor: context.themeColors.errorText,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final isSaving = context.watch<ProfileProvider>().isSaving;
    final user     = context.watch<AuthProvider>().user;
    final nombre   = user?.nombre ?? '';
    final initials = nombre.trim().isNotEmpty
        ? nombre.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : '?';

    if (_loading) {
      return Scaffold(
        backgroundColor: theme.bg,
        appBar: FitnflaiAppBar(title: AppLocalizations.of(context).editProfileTitle),
        body: Center(child: CircularProgressIndicator(color: theme.primary)),
      );
    }

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: FitnflaiAppBar(title: AppLocalizations.of(context).editProfileTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Center(
              child: GestureDetector(
                onTap: _pickAvatar,
                child: Stack(alignment: Alignment.bottomRight, children: [
                  Container(
                    width: 88, height: 88,
                    decoration: BoxDecoration(
                      color: theme.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.primary, width: 2.5),
                      image: _avatarFile != null
                          ? DecorationImage(image: FileImage(_avatarFile!), fit: BoxFit.cover)
                          : (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                              ? DecorationImage(image: NetworkImage(_avatarUrl!), fit: BoxFit.cover)
                              : null,
                    ),
                    child: (_avatarFile == null && (_avatarUrl == null || _avatarUrl!.isEmpty))
                        ? Center(child: Text(initials,
                            style: TextStyle(color: theme.primary,
                                fontSize: 28, fontWeight: FontWeight.w800)))
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.bg, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 14),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 6),
            Center(child: Text(AppLocalizations.of(context).editProfileTapToChange,
                style: TextStyle(color: theme.textMuted, fontSize: 12))),
            const SizedBox(height: 28),

            FieldLabel(text: AppLocalizations.of(context).editProfileUsername),
            const SizedBox(height: 8),
            AppTextField(
              hint: AppLocalizations.of(context).editProfileUsernameHint,
              controller: _apodoCtrl,
              prefixIcon: Icon(Icons.alternate_email, color: theme.textMuted, size: 20),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? AppLocalizations.of(context).editProfileUsernameError : null,
            ),
            const SizedBox(height: 20),

            FieldLabel(text: AppLocalizations.of(context).editProfileEmail),
            const SizedBox(height: 8),
            AppTextField(
              hint: AppLocalizations.of(context).editProfileEmailHint,
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(Icons.email_outlined, color: theme.textMuted, size: 20),
              validator: (v) {
                if (v == null || v.isEmpty) return AppLocalizations.of(context).editProfileEmailEmpty;
                final regex = RegExp(r'^[\w\.\-\+]+@[\w\-]+\.[\w\-\.]*[a-zA-Z]{2,}$');
                if (!regex.hasMatch(v)) return AppLocalizations.of(context).editProfileEmailInvalid;
                return null;
              },
            ),
            const SizedBox(height: 20),

            FieldLabel(text: AppLocalizations.of(context).editProfileCity),
            const SizedBox(height: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextField(
                controller: _ciudadCtrl,
                onChanged: _searchCity,
                style: TextStyle(color: theme.text, fontSize: 14),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).editProfileCitySearchHint,
                  hintStyle: TextStyle(color: theme.textMuted, fontSize: 14),
                  filled: true,
                  fillColor: theme.cardDark,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  prefixIcon: _searchingCity
                      ? SizedBox(width: 20, height: 20,
                          child: Padding(padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2,
                                color: theme.primary)))
                      : Icon(Icons.location_on_outlined, color: theme.textMuted, size: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.border)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.border)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.primary, width: 1.5)),
                ),
              ),
              if (_citySuggestions.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: theme.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.border),
                  ),
                  child: Column(
                    children: _citySuggestions.asMap().entries.map((entry) {
                      final i      = entry.key;
                      final s      = entry.value;
                      final isLast = i == _citySuggestions.length - 1;
                      final label  = [s['nombre'], s['estado'], s['pais']]
                          .where((v) => (v as String).isNotEmpty).join(', ');
                      return Column(children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCityName = s['nombre'] as String;
                              _ciudadCtrl.text  = label;
                              _citySuggestions  = [];
                              _dirty = true;
                            });
                            _fetchElevation(s['lat'] as double, s['lon'] as double);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(children: [
                              Icon(Icons.location_city_outlined,
                                  color: theme.textMuted, size: 16),
                              const SizedBox(width: 10),
                              Expanded(child: Text(label,
                                  style: TextStyle(color: theme.text, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1)),
                            ]),
                          ),
                        ),
                        if (!isLast) Divider(
                            color: theme.border, height: 1, indent: 42),
                      ]);
                    }).toList(),
                  ),
                ),
            ]),
            const SizedBox(height: 20),

            FieldLabel(text: AppLocalizations.of(context).editProfileAltitude),
            const SizedBox(height: 8),
            AppTextField(
              hint: AppLocalizations.of(context).editProfileAltitudeHint,
              controller: _altitudCtrl,
              keyboardType: TextInputType.number,
              prefixIcon: _fetchingElevation
                  ? SizedBox(width: 20, height: 20,
                      child: Padding(padding: EdgeInsets.all(2),
                        child: CircularProgressIndicator(strokeWidth: 2,
                            color: theme.primary)))
                  : Icon(Icons.terrain_outlined, color: theme.textMuted, size: 20),
            ),
            const SizedBox(height: 20),

            FieldLabel(text: AppLocalizations.of(context).editProfileMembership),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MembershipScreen())),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: theme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.border),
                ),
                child: Row(children: [
                  Icon(Icons.workspace_premium_outlined,
                      color: theme.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(AppLocalizations.of(context).editProfileMembershipPlan,
                          style: TextStyle(color: theme.text,
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(AppLocalizations.of(context).editProfileMembershipDays,
                          style: TextStyle(color: theme.textMuted, fontSize: 12)),
                    ]),
                  ),
                  Text(AppLocalizations.of(context).editProfileMembershipChange,
                      style: TextStyle(color: theme.primary,
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: theme.primary, size: 18),
                ]),
              ),
            ),
            const SizedBox(height: 32),

            PrimaryButton(
              labelWidget: isSaving
                  ? const Center(child: SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    ))
                  : Text(AppLocalizations.of(context).editProfileSave, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              enabled: _dirty && !isSaving,
              onTap: _save,
            ),
          ]),
        ),
      ),
    );
  }
}

class _PickOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  const _PickOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.border),
        ),
        child: Row(children: [
          Icon(icon, color: color ?? theme.textSecondary, size: 20),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: color ?? theme.text, fontSize: 14)),
        ]),
      ),
    );
  }
}