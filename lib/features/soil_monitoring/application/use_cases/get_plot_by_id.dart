import '../../domain/entities/plot.dart';
import '../../domain/repositories/plot_repository.dart';

class GetPlotById {
  const GetPlotById(this._repository);

  final PlotRepository _repository;

  Future<Plot?> call(String plotId) => _repository.getPlotById(plotId);
}
