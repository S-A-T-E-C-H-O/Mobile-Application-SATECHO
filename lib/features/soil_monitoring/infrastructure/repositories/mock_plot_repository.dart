import '../../domain/entities/plot.dart';
import '../../domain/entities/sensor_metric.dart';
import '../../domain/repositories/plot_repository.dart';
import '../../domain/value_objects/plot_status.dart';
import '../models/plot_model.dart';

class MockPlotRepository implements PlotRepository {
  final _plots = <Plot>[
    PlotModel.fromMock(
      id: 'plot-1',
      name: 'Plot 1 North',
      crop: 'Corn',
      lastActivityLabel: '3 days ago',
      status: PlotStatus.critical,
      metrics: const [
        SensorMetric(
          type: SensorMetricType.humidity,
          label: 'Humidity (FC28)',
          numericValue: 18,
          displayValue: '18%',
        ),
        SensorMetric(
          type: SensorMetricType.electricalConductivity,
          label: 'Salinity (HR202L)',
          numericValue: 5.8,
          displayValue: '5.8',
        ),
      ],
    ),
    PlotModel.fromMock(
      id: 'plot-2',
      name: 'Plot 2 Center',
      crop: 'Soybeans',
      lastActivityLabel: 'yesterday',
      status: PlotStatus.healthy,
      metrics: const [
        SensorMetric(
          type: SensorMetricType.humidity,
          label: 'Humidity (FC28)',
          numericValue: 68,
          displayValue: '68%',
        ),
        SensorMetric(
          type: SensorMetricType.temperature,
          label: 'Temp',
          numericValue: 23,
          displayValue: '23\u00B0',
        ),
        SensorMetric(
          type: SensorMetricType.electricalConductivity,
          label: 'Salinity (HR202L)',
          numericValue: 1.2,
          displayValue: '1.2',
        ),
      ],
    ),
    PlotModel.fromMock(
      id: 'lot-b',
      name: 'Lot B South',
      crop: 'Wheat',
      lastActivityLabel: '2 days ago',
      status: PlotStatus.warning,
      metrics: const [
        SensorMetric(
          type: SensorMetricType.humidity,
          label: 'Humidity (FC28)',
          numericValue: 55,
          displayValue: '55%',
        ),
        SensorMetric(
          type: SensorMetricType.electricalConductivity,
          label: 'Salinity (HR202L)',
          numericValue: 6.2,
          displayValue: '6.2',
        ),
      ],
    ),
    PlotModel.fromMock(
      id: 'plot-3',
      name: 'Plot 3 East',
      crop: 'Corn',
      lastActivityLabel: 'today 06:00',
      status: PlotStatus.healthy,
      metrics: const [
        SensorMetric(
          type: SensorMetricType.humidity,
          label: 'Humidity (FC28)',
          numericValue: 61,
          displayValue: '61%',
        ),
      ],
    ),
  ];

  @override
  Future<Plot?> getPlotById(String plotId) async {
    return _plots.where((plot) => plot.id == plotId).firstOrNull;
  }

  @override
  Future<List<Plot>> getPlots() async => _plots;
}
