
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../models/specialist.dart';
import '../providers/specialist_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../l10n/app_localizations.dart';

class SpecialistSelectionBottomSheet extends StatefulWidget {
  final Specialist? initialSpecialist;

  const SpecialistSelectionBottomSheet({super.key, this.initialSpecialist});

  @override
  State<SpecialistSelectionBottomSheet> createState() =>
      _SpecialistSelectionBottomSheetState();
}

class _SpecialistSelectionBottomSheetState
    extends State<SpecialistSelectionBottomSheet> {
  Specialist? _viewingSpecialist;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadSpecialists();
      if (widget.initialSpecialist != null) {
        if (!mounted) return;
        context.read<SpecialistProvider>().setSelectedSpecialist(widget.initialSpecialist);
      }
    });
  }

  Future<void> _loadSpecialists() async {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final specialistProvider = context.read<SpecialistProvider>();

    final token = authProvider.token;
    final userDiscipline = profileProvider.profileData?['nombreDisciplina'] as String?;

    final activePlanName = (profileProvider.planActivo?['nombre'] as String?)?.toLowerCase() ?? '';
    final bool isEliteUser = (authProvider.user?.isElite == true) ||
        activePlanName.contains('elite') || activePlanName.contains('élite');

    if (token == null || token.isEmpty) {
      // Handle error, maybe pop the sheet with an error message
      if (mounted) {
        Navigator.of(context).pop(false); // Indicate failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Token de autenticación no encontrado.')),
        );
      }
      return;
    }
    await specialistProvider.loadAndFilter(token, isEliteUser ? null : userDiscipline);
  }

  Future<void> _selectSpecialist() async {
    final authProvider = context.read<AuthProvider>();
    final specialistProvider = context.read<SpecialistProvider>();

    final token = authProvider.token;
    final selectedSpecialist = specialistProvider.selectedSpecialist;

    if (token == null || token.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Token de autenticación no encontrado.')),
        );
      }
      return;
    }

    if (selectedSpecialist == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona un especialista.')),
        );
      }
      return;
    }

    try {
      await specialistProvider.elegirEspecialista(token, selectedSpecialist.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Especialista seleccionado correctamente!')),
        );
        Navigator.of(context).pop(true); // Indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al solicitar seguimiento: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent system back button/swipe closure
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9, // Almost full screen
        decoration: const BoxDecoration(
          color: AppColors.bg, // Use background color
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Consumer<SpecialistProvider>(
          builder: (context, specialistProvider, child) {
            if (specialistProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.orange),
              );
            }

            if (specialistProvider.errorMessage != null) {
              return _buildErrorState(specialistProvider.errorMessage!);
            }

            if (specialistProvider.filteredSpecialists.isEmpty) {
              return _buildEmptyState();
            }

            if (_viewingSpecialist != null) {
              return _buildSpecialistDetails(_viewingSpecialist!);
            }
            return Column(
              children: [
                _buildDragHandle(),
                _buildHeader(),
                Expanded(
                  child: ListView.builder(
                    itemCount: specialistProvider.filteredSpecialists.length,
                    itemBuilder: (context, index) {
                      final specialist =
                          specialistProvider.filteredSpecialists[index];
                      final isSelected =
                          specialistProvider.selectedSpecialist?.id ==
                              specialist.id;
                      return SpecialistCard(
                        specialist: specialist,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _viewingSpecialist = specialist;
                          });
                        },
                      );
                    },
                  ),
                ),
                _buildConfirmButton(specialistProvider.selectedSpecialist != null),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 5,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Text(
            'Elige a tu Especialista',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Para tu plan Elite, selecciona un especialista que te brindará seguimiento personalizado.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.greyLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.white),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Icon(Icons.sentiment_dissatisfied, size: 60, color: AppColors.orange),
          const SizedBox(height: 20),
          Text(
            'No encontramos especialistas para tu disciplina.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Por favor, contacta a soporte para que podamos asignarte un especialista adecuado.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.greyLight,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: AppColors.redText),
          const SizedBox(height: 20),
          Text(
            'Ocurrió un error',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.greyLight,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadSpecialists,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isEnabled ? _selectSpecialist : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: const Text(
            'Elegir Especialista',
            style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildCompactExperienceCard({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.workspace_premium_outlined, color: AppColors.orange, size: 16),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.orange, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildCertificateTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_outlined, color: AppColors.orange, size: 14),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaborItem({required String puesto, required String empresa, required String periodo}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.work_outline, color: AppColors.orange, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (puesto.isNotEmpty)
                  Text(puesto, style: const TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                if (empresa.isNotEmpty)
                  Text(empresa, style: const TextStyle(color: AppColors.grey, fontSize: 11, fontWeight: FontWeight.w600)),
                if (periodo.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(periodo, style: const TextStyle(color: AppColors.orange, fontSize: 10, fontWeight: FontWeight.w700)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialistDetails(Specialist specialist) {
    final l10n = AppLocalizations.of(context);
    final isEs = l10n.localeName == 'es';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDragHandle(),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: () {
                    setState(() {
                      _viewingSpecialist = null;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'Detalle del Especialista',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(width: 48), // To balance the back button
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.border,
                  backgroundImage: specialist.fotoUrl != null && specialist.fotoUrl!.isNotEmpty
                      ? NetworkImage(specialist.fotoUrl!)
                      : null,
                  child: specialist.fotoUrl == null || specialist.fotoUrl!.isEmpty
                      ? const Icon(Icons.person, color: AppColors.greyLight, size: 40)
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        specialist.nombre,
                        style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        specialist.especialidad ?? (isEs ? 'Especialista General' : 'General Specialist'),
                        style: const TextStyle(color: AppColors.orange, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      if (specialist.ciudad != null && specialist.ciudad!.isNotEmpty && specialist.ciudad != 'N/A') ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: AppColors.grey, size: 12),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${specialist.ciudad}, ${specialist.pais ?? 'N/A'}',
                                style: const TextStyle(color: AppColors.grey, fontSize: 11, fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _buildCompactExperienceCard(
                  label: isEs ? 'Experiencia' : 'Experience',
                  value: '${specialist.aniosExperiencia ?? 0} ${isEs ? 'años' : 'years'}',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(isEs ? 'Acerca de' : 'About'),
            const SizedBox(height: 8),
            Text(
              specialist.bio != null && specialist.bio!.trim().isNotEmpty
                  ? specialist.bio!
                  : (isEs
                      ? 'Este especialista no ha proporcionado una biografía detallada.'
                      : 'This specialist has not provided a detailed biography.'),
              style: const TextStyle(color: AppColors.greyLight, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),
            if (specialist.disciplinas.isNotEmpty) ...[
              _buildSectionHeader(isEs ? 'Disciplinas Asociadas' : 'Associated Disciplines'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                children: specialist.disciplinas.map((d) => _buildTag(d)).toList(),
              ),
              const SizedBox(height: 24),
            ],
            _buildSectionHeader(isEs ? 'Certificaciones' : 'Certificates'),
            const SizedBox(height: 12),
            if (specialist.certificados != null && specialist.certificados!.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                children: specialist.certificados!.map((c) => _buildCertificateTag(c.toString())).toList(),
              ),
              const SizedBox(height: 24),
            ] else ...[
              Text(
                isEs
                    ? 'No se registran certificaciones adicionales.'
                    : 'No registered certifications.',
                style: const TextStyle(color: AppColors.grey, fontSize: 12, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
            ],
            if (specialist.historialLaboral != null && specialist.historialLaboral!.isNotEmpty) ...[
              _buildSectionHeader(isEs ? 'Trayectoria Profesional' : 'Professional Background'),
              const SizedBox(height: 12),
              ...specialist.historialLaboral!.map((item) {
                final puesto = item['puesto']?.toString() ?? '';
                final empresa = item['empresa']?.toString() ?? '';
                final periodo = item['periodo']?.toString() ?? '';
                return _buildLaborItem(puesto: puesto, empresa: empresa, periodo: periodo);
              }),
              const SizedBox(height: 24),
            ],
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _viewingSpecialist = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.orange,
                      side: const BorderSide(color: AppColors.orange),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(
                      'Cerrar',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<SpecialistProvider>().setSelectedSpecialist(specialist);
                      setState(() {
                        _viewingSpecialist = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text(
                      'Seleccionar',
                      style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SpecialistCard extends StatelessWidget {
  final Specialist specialist;
  final bool isSelected;
  final VoidCallback onTap;

  const SpecialistCard({
    super.key,
    required this.specialist,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.orange : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.orange.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Specialist Image
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.border,
              backgroundImage: specialist.fotoUrl != null && specialist.fotoUrl!.isNotEmpty
                  ? NetworkImage(specialist.fotoUrl!)
                  : null,
              child: specialist.fotoUrl == null || specialist.fotoUrl!.isEmpty
                  ? Icon(Icons.person, color: AppColors.greyLight.withValues(alpha: 0.6), size: 30)
                  : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    specialist.nombre,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    specialist.especialidad ?? 'Especialista General',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.greyLight,
                    ),
                  ),
                  if (specialist.disciplinas.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      specialist.disciplinas.join(', '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.orange, size: 24),
          ],
        ),
      ),
    );
  }
}
