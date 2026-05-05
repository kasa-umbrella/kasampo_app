// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locationService)
const locationServiceProvider = LocationServiceProvider._();

final class LocationServiceProvider
    extends
        $FunctionalProvider<LocationService, LocationService, LocationService>
    with $Provider<LocationService> {
  const LocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationServiceHash();

  @$internal
  @override
  $ProviderElement<LocationService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationService create(Ref ref) {
    return locationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationService>(value),
    );
  }
}

String _$locationServiceHash() => r'5c196f0dc11a166a14bfa4e9d1af43d8a9341442';

@ProviderFor(currentPosition)
const currentPositionProvider = CurrentPositionProvider._();

final class CurrentPositionProvider
    extends
        $FunctionalProvider<AsyncValue<Position>, Position, Stream<Position>>
    with $FutureModifier<Position>, $StreamProvider<Position> {
  const CurrentPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPositionHash();

  @$internal
  @override
  $StreamProviderElement<Position> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Position> create(Ref ref) {
    return currentPosition(ref);
  }
}

String _$currentPositionHash() => r'2a506cacbb3197e22c481637b9becf81b0dec1bf';

@ProviderFor(walkSessionRepository)
const walkSessionRepositoryProvider = WalkSessionRepositoryProvider._();

final class WalkSessionRepositoryProvider
    extends
        $FunctionalProvider<
          IWalkSessionRepository,
          IWalkSessionRepository,
          IWalkSessionRepository
        >
    with $Provider<IWalkSessionRepository> {
  const WalkSessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walkSessionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walkSessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<IWalkSessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IWalkSessionRepository create(Ref ref) {
    return walkSessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IWalkSessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IWalkSessionRepository>(value),
    );
  }
}

String _$walkSessionRepositoryHash() =>
    r'748ac3563eb5443a4943d6cd583190f7e0da67df';

@ProviderFor(spotRepository)
const spotRepositoryProvider = SpotRepositoryProvider._();

final class SpotRepositoryProvider
    extends
        $FunctionalProvider<ISpotRepository, ISpotRepository, ISpotRepository>
    with $Provider<ISpotRepository> {
  const SpotRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotRepositoryHash();

  @$internal
  @override
  $ProviderElement<ISpotRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ISpotRepository create(Ref ref) {
    return spotRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ISpotRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ISpotRepository>(value),
    );
  }
}

String _$spotRepositoryHash() => r'ca18954588107d0d8b07638f133ffb29f88ed908';

@ProviderFor(storageService)
const storageServiceProvider = StorageServiceProvider._();

final class StorageServiceProvider
    extends
        $FunctionalProvider<IStorageService, IStorageService, IStorageService>
    with $Provider<IStorageService> {
  const StorageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageServiceHash();

  @$internal
  @override
  $ProviderElement<IStorageService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IStorageService create(Ref ref) {
    return storageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IStorageService>(value),
    );
  }
}

String _$storageServiceHash() => r'98c435cd14d9434852315a98f7fb76b6111bc89d';
