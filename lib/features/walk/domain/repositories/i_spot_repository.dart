import '../../../../core/models/spot.dart';

abstract class ISpotRepository {
  Future<String> create(Spot spot);
  Stream<List<Spot>> watchBySession(String sessionId);
}
