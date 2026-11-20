import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_theme_extension.dart';
import '../../../../models/activity_detail.dart';

class ActivityMapHeader extends StatelessWidget {
  final ActivityDetail activity;
  final VoidCallback? onShare;

  const ActivityMapHeader({
    super.key,
    required this.activity,
    this.onShare,
  });

  String _formatDate(DateTime dt) {
    try {
      final formatter = DateFormat("d 'de' MMMM 'de' y, HH:mm", 'es');
      return formatter.format(dt);
    } catch (_) {
      return DateFormat('yyyy-MM-dd HH:mm').format(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final hasRoute = activity.routePoints.isNotEmpty;

    // Center map around first coordinate
    final initialPos = hasRoute
        ? LatLng(activity.routePoints.first.lat, activity.routePoints.first.lng)
        : const LatLng(-0.180653, -78.467834);

    final polylinePoints = activity.routePoints
        .map((p) => LatLng(p.lat, p.lng))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Map Container
        ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          child: SizedBox(
            height: 240,
            width: double.infinity,
            child: hasRoute
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(target: initialPos, zoom: 14),
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('activity_route'),
                        points: polylinePoints,
                        color: theme.primary,
                        width: 4,
                      ),
                    },
                    markers: {
                      if (polylinePoints.isNotEmpty)
                        Marker(
                          markerId: const MarkerId('start'),
                          position: polylinePoints.first,
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                        ),
                      if (polylinePoints.length > 1)
                        Marker(
                          markerId: const MarkerId('end'),
                          position: polylinePoints.last,
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                        ),
                    },
                  )
                : Container(
                    color: theme.cardDark,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.directions_run, size: 48, color: theme.primary.withValues(alpha: 0.5)),
                          const SizedBox(height: 8),
                          Text(
                            'Actividad sin datos GPS',
                            style: TextStyle(color: theme.textMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        // Title & metadata
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: theme.text,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      activity.workoutType.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: theme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(activity.summary.distanceMeters / 1000).toStringAsFixed(2)} km',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: theme.textMuted),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(activity.date),
                    style: TextStyle(fontSize: 12, color: theme.textMuted),
                  ),
                ],
              ),
              if (activity.locationName != null && activity.locationName!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.place_outlined, size: 14, color: theme.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      activity.locationName!,
                      style: TextStyle(fontSize: 12, color: theme.textMuted),
                    ),
                  ],
                ),
              ],
              if (activity.sources.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: activity.sources.map((src) {
                    final isGarmin = src.toLowerCase().contains('garmin');
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.cardDark,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.border.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isGarmin ? Icons.watch : Icons.cloud_done,
                            size: 14,
                            color: isGarmin ? Colors.blue : theme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            src.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: theme.text,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
              if (activity.description != null && activity.description!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.cardDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.border.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    activity.description!,
                    style: TextStyle(fontSize: 13, color: theme.textMuted, height: 1.4),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              // Compartir button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onShare,
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text('Compartir actividad'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.text,
                    side: BorderSide(color: theme.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
