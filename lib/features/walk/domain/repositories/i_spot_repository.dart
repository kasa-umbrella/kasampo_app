import '../../../../core/models/spot.dart';

abstract class ISpotRepository {
  Future<String> create(Spot spot);
  Future<void> delete(String spotId);
  Stream<List<Spot>> watchBySession(String sessionId);
  Stream<List<Spot>> watchByUser(String userId);
}
