import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/features/advisory/presentation/controllers/recommendations_controller.dart';
import 'package:satecho_mobile/features/advisory/presentation/widgets/recommendation_card.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  late final RecommendationsController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AppDependenciesScope.of(context).createRecommendationsController();
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
      appBar: AppBar(
        title: const Text(
          'Recommendations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final mq = MediaQuery.of(context);
          return ListView(
            padding: EdgeInsets.fromLTRB(20, 10, 20, mq.padding.bottom + 80),
            children: [
              if (_controller.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ..._controller.recommendations.map(
                  (recommendation) => Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: RecommendationCard(
                      recommendation: recommendation,
                      onCompleted: () => _controller.complete(recommendation.id),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
