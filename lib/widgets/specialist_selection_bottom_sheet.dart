
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../models/specialist.dart';
import '../providers/specialist_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';

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

    final bool isEliteUser = (authProvider.user?.isElite == true) ||
        (profileProvider.planActivo?['nombre'] as String?)?.toLowerCase().contains('elite') == true;

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
          child: Text(
            'Solicitar Seguimiento',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialistDetails(Specialist specialist) {
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
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.border,
                backgroundImage: specialist.fotoUrl != null && specialist.fotoUrl!.isNotEmpty
                    ? NetworkImage(specialist.fotoUrl!)
                    : null,
                child: specialist.fotoUrl == null || specialist.fotoUrl!.isEmpty
                    ? Icon(Icons.person, color: AppColors.greyLight.withValues(alpha: 0.6), size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
                specialist.nombre,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                specialist.especialidad ?? 'Especialista General',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.orange,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            if (specialist.disciplinas.isNotEmpty)
              Center(
                child: Text(
                  specialist.disciplinas.join(' • '),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.greyLight,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            const SizedBox(height: 20),
            const Divider(color: AppColors.border),
            const SizedBox(height: 20),
            Text(
              'Sobre mí',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              specialist.bio ?? 'Este especialista no ha proporcionado una biografía detallada.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.greyLight,
                    fontSize: 14,
                    height: 1.6,
                  ),
            ),
            const SizedBox(height: 30),
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
                      _selectSpecialist();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(
                      'Elegir Especialista',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
