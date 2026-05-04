// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WalkSessionNotifier)
const walkSessionProvider = WalkSessionNotifierProvider._();

final class WalkSessionNotifierProvider
    extends $NotifierProvider<WalkSessionNotifier, WalkSessionState> {
  const WalkSessionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walkSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walkSessionNotifierHash();

  @$internal
  @override
  WalkSessionNotifier create() => WalkSessionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalkSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalkSessionState>(value),
    );
  }
}

String _$walkSessionNotifierHash() =>
    r'f5150ec2381d890757294d7ddb2ceae2a5074211';

abstract class _$WalkSessionNotifier extends $Notifier<WalkSessionState> {
  WalkSessionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WalkSessionState, WalkSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WalkSessionState, WalkSessionState>,
              WalkSessionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
