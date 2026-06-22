import 'package:satecho_mobile/features/zones/domain/zone.dart';
import 'package:satecho_mobile/features/zones/domain/zone_repository.dart';
import 'package:satecho_mobile/features/farms/domain/assigned_client.dart';
import 'package:satecho_mobile/features/farms/domain/farm.dart';
import 'package:satecho_mobile/features/farms/domain/visit_history_item.dart';
import 'package:satecho_mobile/features/farms/domain/farm_repository.dart';

class MockFarmRepository implements FarmRepository {
  MockFarmRepository(this._zoneRepository);

  final ZoneRepository _zoneRepository;

  final List<Farm> _farms = const [
    Farm(
      id: 'farm-1',
      name: 'Estate El Recuerdo',
      ownerName: 'Carlos Mendoza',
      crop: 'Avocado',
      zoneLabel: 'Northern Zone',
      hectaresLabel: '45.5 Total Hectares',
      status: '1 Alert',
      alertCount: 1,
      soilHumidity: 42,
      temperature: 32,
      ec: 1.2,
      ndvi: 0.78,
    ),
    Farm(
      id: 'farm-2',
      name: 'Ranch Las Rosas',
      ownerName: 'Maria Elena Ruiz',
      crop: 'Coffee',
      zoneLabel: 'Southern Zone',
      hectaresLabel: '280 ha',
      status: 'Optimal',
      alertCount: 0,
      soilHumidity: 58,
      temperature: 24,
      ec: 0.8,
      ndvi: 0.84,
    ),
    Farm(
      id: 'farm-3',
      name: 'Valle Verde',
      ownerName: 'Jorge Silva',
      crop: 'Corn',
      zoneLabel: 'East Zone',
      hectaresLabel: '180 ha',
      status: 'Updating',
      alertCount: 0,
      soilHumidity: null,
      temperature: null,
      ec: null,
      ndvi: 0.64,
    ),
  ];

  @override
  Future<List<AssignedClient>> getAssignedClients() async {
    final clients = <AssignedClient>[];
    for (final farm in _farms) {
      final zones = await _zoneRepository.getZonesByFarm(farm.id);
      clients.add(_client(farm, zones));
    }
    return clients;
  }

  @override
  Future<AssignedClient?> getAssignedClientByFarmId(String farmId) async {
    final farm = _farms.where((item) => item.id == farmId).firstOrNull;
    if (farm == null) return null;
    final zones = await _zoneRepository.getZonesByFarm(farm.id);
    return _client(farm, zones);
  }

  AssignedClient _client(Farm farm, List<Zone> zones) {
    return AssignedClient(
      farm: farm,
      zones: zones,
      visitHistory: const [
        VisitHistoryItem(
          title: 'Routine inspection',
          dateLabel: '12 Oct 2023',
          description:
              'General review of the phenological stage of the corn. Soil samples were taken in the North Plot.',
          recommendation:
              'Apply nitrogen fertilizer (40kg/ha) before the next rain.',
        ),
        VisitHistoryItem(
          title: 'Irrigation assessment',
          dateLabel: '28 Sep 2023',
          description:
              'Sprinkler adjustment in the South Lot due to low uniformity detected in sensors.',
        ),
      ],
    );
  }
}
