import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/billing/presentation/controllers/billing_controller.dart';
import 'invoices_page.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  late final BillingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context).createBillingController();
    _controller.load();
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
          return ListView(
            padding: const EdgeInsets.fromLTRB(28, 34, 28, 112),
            children: [
              Row(
                children: [
                  Material(
                    color: AppColors.surface,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.chevron_left, size: 30),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text('Subscription',
                      style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
              const SizedBox(height: 26),
              if (_controller.isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                if (_controller.subscription != null) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _controller.subscription!.planName
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.check_circle,
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 4),
                            const Text('Active',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Current plan',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _controller.subscription!.planName,
                          style: const TextStyle(
                              color: AppColors.muted, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _controller.isMutating
                                ? null
                                : () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title:
                                            const Text('Cancel subscription?'),
                                        content: const Text(
                                            'Your plan stays active until the end of the current period, then downgrades to Free.'),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text('Keep plan')),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Cancel plan')),
                                        ],
                                      ),
                                    );
                                    if (confirmed == true) {
                                      await _controller.cancelSubscription();
                                    }
                                  },
                            child: const Text('Cancel subscription'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _BenefitTile(
                          icon: Icons.sensors,
                          label: 'Up to 10 IoT sensors',
                        ),
                        _BenefitTile(
                          icon: Icons.water_drop_outlined,
                          label: 'Automated irrigation control',
                        ),
                        _BenefitTile(
                          icon: Icons.security_outlined,
                          label: 'Perimeter security monitoring',
                        ),
                        _BenefitTile(
                          icon: Icons.analytics_outlined,
                          label: 'Real-time analytics',
                        ),
                        _BenefitTile(
                          icon: Icons.support_agent,
                          label: 'Agronomist support',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  AppCard(
                    child: Column(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.muted, size: 40),
                        const SizedBox(height: 12),
                        Text('No active subscription',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        const Text(
                          'Contact your administrator to activate a plan.',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: AppColors.muted, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
                if (_controller.invoices.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Billing history',
                          style: Theme.of(context).textTheme.titleMedium),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => InvoicesPage(
                              invoices: _controller.invoices,
                            ),
                          ),
                        ),
                        child: const Text('View all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._controller.invoices.take(3).map((inv) {
                    final amount =
                        (inv['amount'] as num?)?.toStringAsFixed(2) ?? '--';
                    final currency = inv['currency'] as String? ?? 'USD';
                    final status = inv['status'] as String? ?? '--';
                    final dueDate = inv['dueDate'] as String?;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppCard(
                        child: Row(
                          children: [
                            const Icon(Icons.receipt_outlined,
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$currency $amount',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
                                  ),
                                  if (dueDate != null)
                                    Text(
                                      dueDate.substring(0, 10),
                                      style: const TextStyle(
                                          color: AppColors.muted, fontSize: 12),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: status == 'PAID'
                                    ? const Color(0xFFE8F5E9)
                                    : const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: status == 'PAID'
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFE65100),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
                if (_controller.plans.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text('Available plans',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ..._controller.plans.map((plan) {
                    final name = plan['name'] as String? ?? 'Plan';
                    final tier = plan['tier'] as String?;
                    final price = (plan['price'] as num?)?.toStringAsFixed(2) ??
                        (plan['pricePerHaPerMonth'] as num?)
                            ?.toStringAsFixed(2) ??
                        '--';
                    final features =
                        (plan['features'] as List<dynamic>?)?.cast<String>() ??
                            const [];
                    final isCurrentPlan = _controller.subscription != null &&
                        tier != null &&
                        _controller.subscription!.planName
                            .toUpperCase()
                            .contains(tier.toUpperCase());
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(name.toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15)),
                                const Spacer(),
                                Text('\$$price/ha/mo',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary)),
                              ],
                            ),
                            if (features.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              ...features.take(3).map(
                                    (f) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.check_circle_outline,
                                              color: AppColors.primary,
                                              size: 16),
                                          const SizedBox(width: 8),
                                          Expanded(
                                              child: Text(f,
                                                  style: const TextStyle(
                                                      fontSize: 13))),
                                        ],
                                      ),
                                    ),
                                  ),
                            ],
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: isCurrentPlan
                                  ? const Chip(label: Text('Current plan'))
                                  : FilledButton(
                                      onPressed: tier == null ||
                                              _controller.isMutating
                                          ? null
                                          : () => _controller.subscribe(tier),
                                      style: FilledButton.styleFrom(
                                          backgroundColor: AppColors.primary),
                                      child: Text(
                                          _controller.subscription == null
                                              ? 'Select plan'
                                              : 'Switch to this plan'),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
                if (_controller.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(_controller.errorMessage!,
                      style: const TextStyle(color: AppColors.danger)),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  const _BenefitTile({
    required this.icon,
    required this.label,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.primary, size: 20),
          title: Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.check, color: AppColors.primary, size: 18),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        ),
        if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
