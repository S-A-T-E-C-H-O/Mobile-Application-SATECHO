import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';

class InvoicesPage extends StatelessWidget {
  const InvoicesPage({required this.invoices, super.key});

  final List<Map<String, dynamic>> invoices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
              Text('Billing history',
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 24),
          if (invoices.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: Text('No invoices yet.',
                    style: TextStyle(color: AppColors.muted)),
              ),
            )
          else
            ...invoices.map((inv) => _InvoiceTile(invoice: inv)),
        ],
      ),
    );
  }
}

class _InvoiceTile extends StatelessWidget {
  const _InvoiceTile({required this.invoice});

  final Map<String, dynamic> invoice;

  @override
  Widget build(BuildContext context) {
    final amount =
        (invoice['amount'] as num?)?.toStringAsFixed(2) ?? '--';
    final currency = invoice['currency'] as String? ?? 'USD';
    final status = invoice['status'] as String? ?? '--';
    final description = invoice['description'] as String? ?? '';
    final dueDate = invoice['dueDate'] as String?;
    final paidAt = invoice['paidAt'] as String?;
    final isPaid = status == 'PAID';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isPaid
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isPaid ? Icons.check_circle_outline : Icons.schedule,
                    color: isPaid
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFE65100),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$currency $amount',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      if (description.isNotEmpty)
                        Text(
                          description,
                          style: const TextStyle(
                              color: AppColors.muted, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isPaid
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFE65100),
                    ),
                  ),
                ),
              ],
            ),
            if (dueDate != null || paidAt != null) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (dueDate != null) ...[
                    const Text('Due: ',
                        style: TextStyle(
                            color: AppColors.muted, fontSize: 12)),
                    Text(dueDate.substring(0, 10),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                  const Spacer(),
                  if (paidAt != null) ...[
                    const Text('Paid: ',
                        style: TextStyle(
                            color: AppColors.muted, fontSize: 12)),
                    Text(paidAt.substring(0, 10),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
