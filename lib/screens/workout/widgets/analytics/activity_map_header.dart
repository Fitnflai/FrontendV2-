import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_theme_extension.dart';
import '../../../../models/activity_detail.dart';

class ActivityMapHeader extends StatelessWidget {
  final ActivityDetail activity;
  final VoidCallback? onShare;
  final List<RoutePoint>? highlightedPoints;
  final String? highlightedLapTitle;

  const ActivityMapHeader({
    super.key,
    required this.activity,
    this.onShare,
    this.highlightedPoints,
    this.highlightedLapTitle,
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
    final isLapHighlighted = highlightedPoints != null && highlightedPoints!.isNotEmpty;

    // Center map around first coordinate (or first coordinate of highlighted lap)
    final initialPos = isLapHighlighted
        ? LatLng(highlightedPoints!.first.lat, highlightedPoints!.first.lng)
        : (hasRoute
            ? LatLng(activity.routePoints.first.lat, activity.routePoints.first.lng)
            : const LatLng(-0.180653, -78.467834));

    final polylinePoints = activity.routePoints
        .map((p) => LatLng(p.lat, p.lng))
        .toList();

    final highlightedLatLngs = isLapHighlighted
        ? highlightedPoints!.map((p) => LatLng(p.lat, p.lng)).toList()
        : <LatLng>[];

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
                ? Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(target: initialPos, zoom: isLapHighlighted ? 15 : 14),
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        mapToolbarEnabled: false,
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId('activity_route'),
                            points: polylinePoints,
                            color: isLapHighlighted
                                ? Colors.grey.withValues(alpha: 0.4)
                                : theme.primary,
                            width: isLapHighlighted ? 3 : 4,
                          ),
                          if (isLapHighlighted)
                            Polyline(
                              polylineId: const PolylineId('highlighted_lap'),
                              points: highlightedLatLngs,
                              color: theme.primary,
                              width: 6,
                            ),
                        },
                        markers: {
                          if (isLapHighlighted) ...[
                            Marker(
                              markerId: const MarkerId('lap_start'),
                              position: highlightedLatLngs.first,
                              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                              infoWindow: InfoWindow(title: 'Inicio: ${highlightedLapTitle ?? "Tramo"}'),
                            ),
                            if (highlightedLatLngs.length > 1)
                              Marker(
                                markerId: const MarkerId('lap_end'),
                                position: highlightedLatLngs.last,
                                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                                infoWindow: InfoWindow(title: 'Fin: ${highlightedLapTitle ?? "Tramo"}'),
                              ),
                          ] else ...[
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
                          ],
                        },
                      ),
                      if (isLapHighlighted)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: theme.primary, width: 1.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: theme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  highlightedLapTitle ?? 'Tramo de intervalo',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
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
              if (activity.sources.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: activity.sources.map((src) {
                    final isGarmin = src.toLowerCase().contains('garmin');
                    final isStrava = src.toLowerCase().contains('strava');
                    return Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isGarmin
                            ? const Color(0xFF007DC3).withValues(alpha: 0.2)
                            : (isStrava
                                ? const Color(0xFFFC6100).withValues(alpha: 0.2)
                                : theme.cardDark),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isGarmin
                              ? const Color(0xFF007DC3)
                              : (isStrava ? const Color(0xFFFC6100) : theme.border),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        src.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isGarmin
                              ? const Color(0xFF007DC3)
                              : (isStrava ? const Color(0xFFFC6100) : theme.textMuted),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
