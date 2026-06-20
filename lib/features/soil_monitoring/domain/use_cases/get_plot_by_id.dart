import 'package:satecho_mobile/features/soil_monitoring/domain/plot.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/plot_repository.dart';

class GetPlotById {
  const GetPlotById(this._repository);

  final PlotRepository _repository;

  Future<Plot?> call(String plotId) => _repository.getPlotById(plotId);
}
