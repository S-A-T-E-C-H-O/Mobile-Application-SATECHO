import '../../domain/entities/plot.dart';
import '../../domain/repositories/plot_repository.dart';

class GetPlots {
  const GetPlots(this._repository);

  final PlotRepository _repository;

  Future<List<Plot>> call() => _repository.getPlots();
}
