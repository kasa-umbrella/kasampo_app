import 'package:riverpod_annotation/riverpod_annotation.dart';
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
IWalkSessionRepository walkSessionRepository(Ref ref) =>
    FirestoreWalkSessionRepository();

@riverpod
ISpotRepository spotRepository(Ref ref) => FirestoreSpotRepository();

@riverpod
IStorageService storageService(Ref ref) => FirebaseStorageService();
