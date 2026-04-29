// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateHash() => r'f89c621dcc3b56ebe4475cf05ff43e5c093751f0';

/// See also [authState].
@ProviderFor(authState)
final authStateProvider = AutoDisposeStreamProvider<User?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = AutoDisposeStreamProviderRef<User?>;
String _$userAuthStateHash() => r'1c7e28a9f38b67f671c737ee035e78b4c4d6f81d';

/// See also [userAuthState].
@ProviderFor(userAuthState)
final userAuthStateProvider = AutoDisposeStreamProvider<UserAuthState>.internal(
  userAuthState,
  name: r'userAuthStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userAuthStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserAuthStateRef = AutoDisposeStreamProviderRef<UserAuthState>;
String _$signInControllerHash() => r'd47550b08b1b096a6ad1d9e482bcbd442b25015f';

/// See also [SignInController].
@ProviderFor(SignInController)
final signInControllerProvider =
    AutoDisposeNotifierProvider<SignInController, AsyncValue<void>>.internal(
      SignInController.new,
      name: r'signInControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$signInControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SignInController = AutoDisposeNotifier<AsyncValue<void>>;
String _$registerControllerHash() =>
    r'84c2e8a6ffcb9526afeaadd16d72b78957042154';

/// See also [RegisterController].
@ProviderFor(RegisterController)
final registerControllerProvider =
    AutoDisposeNotifierProvider<RegisterController, AsyncValue<void>>.internal(
      RegisterController.new,
      name: r'registerControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$registerControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RegisterController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
