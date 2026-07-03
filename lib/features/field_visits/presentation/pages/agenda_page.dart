import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/field_visits/presentation/controllers/agenda_controller.dart';
import 'field_visit_page.dart';
import 'schedule_visit_sheet.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late final AgendaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context).createAgendaController();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openScheduleSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ScheduleVisitSheet(controller: _controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(28, 34, 28, 118),
              children: [
                const Text('Agenda',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    )),
                const SizedBox(height: 6),
                const Text('You have 5 visits scheduled for this week.',
                    style: TextStyle(color: AppColors.muted, fontSize: 14)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('THIS WEEK',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    IconButton.filledTonal(
                        onPressed: () {}, icon: const Icon(Icons.filter_list)),
                  ],
                ),
                if (_controller.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ..._controller.visits.map(
                    (visit) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: AppCard(
                        border: visit.urgent
                            ? Border.all(color: AppColors.dangerSoft)
                            : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Chip(
                                    label: Text(
                                      visit.tag,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    backgroundColor: visit.urgent
                                        ? AppColors.dangerSoft
                                        : const Color(0xFFE4EAF8),
                                    side: BorderSide.none,
                                    labelStyle: TextStyle(
                                        color: visit.urgent
                                            ? AppColors.danger
                                            : AppColors.muted),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Chip(
                                    label: Text(
                                      visit.dateLabel,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    side: BorderSide.none,
                                    backgroundColor: AppColors.neutralTile,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(visit.farmName,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text(visit.ownerName,
                                style: const TextStyle(
                                    color: AppColors.muted, fontSize: 14)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppColors.neutralTile,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  const Icon(Icons.science_outlined,
                                      color: AppColors.primary, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${visit.noteTitle}\n${visit.noteBody}',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (visit.urgent)
                              Row(
                                children: [
                                  Expanded(
                                      child: OutlinedButton(
                                          onPressed: () {},
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            textStyle:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          child: const Text('Reschedule'))),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (_) => FieldVisitPage(
                                                  visitId: visit.id))),
                                      style: FilledButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF80A482),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          textStyle:
                                              const TextStyle(fontSize: 14)),
                                      child: const Text('Start Visit'),
                                    ),
                                  ),
                                ],
                              )
                            else
                              OutlinedButton(
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            FieldVisitPage(visitId: visit.id))),
                                style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(40),
                                    textStyle: const TextStyle(fontSize: 14)),
                                child: const Text('View Details'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Positioned(
              bottom: 28,
              right: 28,
              child: FloatingActionButton.extended(
                onPressed: _controller.isScheduling ? null : _openScheduleSheet,
                backgroundColor: AppColors.primary,
                icon: _controller.isScheduling
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.add, color: Colors.white),
                label: const Text('Schedule visit',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }
}
