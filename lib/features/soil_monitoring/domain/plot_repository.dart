import 'package:satecho_mobile/features/soil_monitoring/domain/plot.dart';

abstract class PlotRepository {
  Future<List<Plot>> getPlots();
  Future<Plot?> getPlotById(String plotId);
}
