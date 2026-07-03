import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/farms/presentation/controllers/clients_controller.dart';
import 'package:satecho_mobile/features/farms/presentation/widgets/client_card.dart';
import 'package:satecho_mobile/features/parcel_comparison/presentation/pages/parcel_comparison_page.dart';
import 'package:satecho_mobile/features/priority_cases/presentation/pages/priority_cases_page.dart';
import 'agronomist_filters_page.dart';
import 'estate_detail_page.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  late final ClientsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context).createClientsController();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(28, 34, 28, 118),
          children: [
            const Text(
              'Good morning, Roberto',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Agricultural Engineer',
              style: TextStyle(color: AppColors.muted, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const PriorityCasesPage()),
                    ),
                    icon: const Icon(Icons.priority_high,
                        color: AppColors.danger),
                    label: const Text('Priority cases'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const ParcelComparisonPage()),
                    ),
                    icon: const Icon(Icons.compare_arrows),
                    label: const Text('Compare'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Clients',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    )),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const AgronomistFiltersPage()),
                  ),
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              onChanged: _controller.search,
              decoration: InputDecoration(
                hintText: 'Search clients, farms, or crops...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.muted),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.muted),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_controller.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_controller.visibleClients.isEmpty)
              const Text('No clients found')
            else
              ..._controller.visibleClients.map(
                (client) => Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: ClientCard(
                    client: client,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            EstateDetailPage(farmId: client.farm.id),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
