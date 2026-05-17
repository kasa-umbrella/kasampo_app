// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heatmap_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(heatmapRepository)
const heatmapRepositoryProvider = HeatmapRepositoryProvider._();

final class HeatmapRepositoryProvider
    extends
        $FunctionalProvider<
          FirestoreHeatmapRepository,
          FirestoreHeatmapRepository,
          FirestoreHeatmapRepository
        >
    with $Provider<FirestoreHeatmapRepository> {
  const HeatmapRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'heatmapRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$heatmapRepositoryHash();

  @$internal
  @override
  $ProviderElement<FirestoreHeatmapRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirestoreHeatmapRepository create(Ref ref) {
    return heatmapRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirestoreHeatmapRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirestoreHeatmapRepository>(value),
    );
  }
}

String _$heatmapRepositoryHash() => r'aa7cfff50f5ca89d515767e2b954345ac5a670b2';

@ProviderFor(heatmapPoints)
const heatmapPointsProvider = HeatmapPointsProvider._();

final class HeatmapPointsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WeightedLatLng>>,
          List<WeightedLatLng>,
          FutureOr<List<WeightedLatLng>>
        >
    with
        $FutureModifier<List<WeightedLatLng>>,
        $FutureProvider<List<WeightedLatLng>> {
  const HeatmapPointsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'heatmapPointsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$heatmapPointsHash();

  @$internal
  @override
  $FutureProviderElement<List<WeightedLatLng>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeightedLatLng>> create(Ref ref) {
    return heatmapPoints(ref);
  }
}

String _$heatmapPointsHash() => r'f6baa9de41b444071490952a628684e64d1814ed';
