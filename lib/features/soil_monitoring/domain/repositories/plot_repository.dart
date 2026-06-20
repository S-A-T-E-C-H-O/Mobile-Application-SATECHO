import '../entities/plot.dart';

abstract class PlotRepository {
  Future<List<Plot>> getPlots();
  Future<Plot?> getPlotById(String plotId);
}
