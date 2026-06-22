import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/advisory/presentation/pages/new_recommendation_page.dart';
import 'package:satecho_mobile/features/field_visits/presentation/pages/field_visit_page.dart';
import 'package:satecho_mobile/features/quick_reports/presentation/pages/quick_reports_page.dart';
import 'package:satecho_mobile/features/zones/presentation/pages/threshold_adjustment_page.dart';
import 'package:satecho_mobile/features/zones/presentation/pages/zone_analysis_page.dart';
import 'package:satecho_mobile/features/farms/presentation/controllers/estate_detail_controller.dart';

class EstateDetailPage extends StatefulWidget {
  const EstateDetailPage({required this.farmId, super.key});

  final String farmId;

  @override
  State<EstateDetailPage> createState() => _EstateDetailPageState();
}

class _EstateDetailPageState extends State<EstateDetailPage> {
  late final EstateDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AppDependenciesScope.of(context).createEstateDetailController();
    _controller.load(widget.farmId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final client = _controller.client;
          final farm = client?.farm;
          return ListView(
            padding: const EdgeInsets.fromLTRB(26, 24, 26, 34),
            children: [
              if (_controller.isLoading || client == null || farm == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Wrap(
                        spacing: 8,
                        children: [
                          _MiniBadge(
                              label: 'ASSET', color: AppColors.primarySoft),
                          _MiniBadge(
                              label: 'SCHEDULED IRRIGATION',
                              color: AppColors.dangerSoft),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        farm.name,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Owner: ${farm.ownerName}',
                          style: const TextStyle(
                              color: AppColors.muted, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(farm.hectaresLabel,
                          style: const TextStyle(
                              color: AppColors.muted, fontSize: 16)),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const FieldVisitPage()),
                              ),
                              icon: const Icon(Icons.event_available),
                              label: const Text('Schedule a visit'),
                              style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF80A482)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const QuickReportsPage()),
                              ),
                              icon: const Icon(Icons.description_outlined),
                              label: const Text('View report'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _MetricBand(
                    title: 'AVERAGE HUMIDITY',
                    value: '${farm.soilHumidity ?? 0}%',
                    detail: 'Optimum (25-35%)',
                    color: AppColors.primary),
                const SizedBox(height: 18),
                _MetricBand(
                    title: 'SOIL TEMP.',
                    value: '${farm.temperature ?? 0}°C',
                    detail: '+2°C since yesterday',
                    color: const Color(0xFF9B5A3E)),
                const SizedBox(height: 18),
                _MetricBand(
                    title: 'AVERAGE NDVI',
                    value: farm.ndvi.toStringAsFixed(2),
                    detail: 'Healthy',
                    color: AppColors.muted),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text('Parcelas',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.map_outlined, size: 16),
                      label: const Text('View map'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (final zone in client.zones)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => ZoneAnalysisPage(zoneId: zone.id)),
                      ),
                      child: AppCard(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.neutralTile,
                              child: Text(
                                  zone.name.split(' ').first.substring(0, 1),
                                  style: const TextStyle(
                                      color: AppColors.primary)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(zone.name,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                  Text('${zone.crop} • ${zone.areaLabel}',
                                      style: const TextStyle(
                                          color: AppColors.muted)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${zone.humidity}%\nHumidity',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        color: AppColors.primary)),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ThresholdAdjustmentPage(
                                        zoneId: zone.id,
                                        zoneName: zone.name,
                                        cropType: zone.crop,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Thresholds',
                                    style: TextStyle(
                                        color: AppColors.muted,
                                        fontSize: 11,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                const Text('Alerts',
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                const _AlertSnippet(
                    title: 'Water stress in Lote Sur',
                    body:
                        'Soil moisture has dropped below 20%. It is recommended to begin an irrigation cycle.'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Recommendations pending',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w800)),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const NewRecommendationPage()),
                      ),
                      child: const Text('+ New'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const AppCard(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF80A482)),
                      SizedBox(width: 10),
                      Text('No pending recommendations'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text('Visit history',
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final visit in client.visitHistory)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.circle,
                                  color: Color(0xFF80A482), size: 12),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(visit.title,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700)),
                                    Text(visit.dateLabel,
                                        style: const TextStyle(
                                            color: AppColors.muted,
                                            fontSize: 12)),
                                    const SizedBox(height: 8),
                                    Text(visit.description,
                                        style: const TextStyle(
                                            color: AppColors.muted)),
                                    if (visit.recommendation != null) ...[
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.neutralTile,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                            'Recommendation:\n${visit.recommendation!}'),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      child: Text(label,
          style: const TextStyle(
              fontSize: 11,
              color: AppColors.primary,
              fontWeight: FontWeight.w700)),
    );
  }
}

class _MetricBand extends StatelessWidget {
  const _MetricBand({
    required this.title,
    required this.value,
    required this.detail,
    required this.color,
  });

  final String title;
  final String value;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: color, fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Text.rich(
            TextSpan(
              text: value,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text),
              children: [
                TextSpan(
                    text: ' / $detail',
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.muted,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
                value: .68,
                minHeight: 6,
                color: color,
                backgroundColor: AppColors.border),
          ),
        ],
      ),
    );
  }
}

class _AlertSnippet extends StatelessWidget {
  const _AlertSnippet({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F5),
        border: Border.all(color: const Color(0xFFFFC9C3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning, color: AppColors.danger),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(body, style: const TextStyle(color: AppColors.muted)),
                const SizedBox(height: 8),
                const Text('VIEW DETAILS',
                    style: TextStyle(
                        color: AppColors.danger,
                        fontWeight: FontWeight.w800,
                        fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
