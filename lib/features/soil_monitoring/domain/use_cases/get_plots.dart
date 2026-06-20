import 'package:satecho_mobile/features/soil_monitoring/domain/plot.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/plot_repository.dart';

class GetPlots {
  const GetPlots(this._repository);

  final PlotRepository _repository;

  Future<List<Plot>> call() => _repository.getPlots();
}
