import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/spot.dart';
import '../../../core/services/firebase_storage_service.dart';
import '../../../core/services/i_storage_service.dart';
import '../../../core/services/location_service.dart';
import '../data/repositories/firestore_spot_repository.dart';
import '../data/repositories/firestore_walk_session_repository.dart';
import '../domain/repositories/i_spot_repository.dart';
import '../domain/repositories/i_walk_session_repository.dart';

part 'walk_providers.g.dart';

@riverpod
LocationService locationService(Ref ref) => LocationService();

@riverpod
Stream<Position> currentPosition(Ref ref) {
  return ref.watch(locationServiceProvider).watchPosition();
}

@riverpod
IWalkSessionRepository walkSessionRepository(Ref ref) =>
    FirestoreWalkSessionRepository();

@Riverpod(keepAlive: true)
ISpotRepository spotRepository(Ref ref) => FirestoreSpotRepository();

@riverpod
IStorageService storageService(Ref ref) => FirebaseStorageService();

@riverpod
String? currentUid(Ref ref) => FirebaseAuth.instance.currentUser?.uid;

@Riverpod(keepAlive: true)
Stream<List<Spot>> userSpots(Ref ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(spotRepositoryProvider).watchByUser(uid);
}
