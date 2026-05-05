// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walk_session_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalkSessionState {

 String? get sessionId; DateTime? get startedAt; List<GeoPoint> get routePoints; double get distanceMeters; bool get isActive; bool get isPaused; int get pausedDurationSeconds; String? get error;
/// Create a copy of WalkSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalkSessionStateCopyWith<WalkSessionState> get copyWith => _$WalkSessionStateCopyWithImpl<WalkSessionState>(this as WalkSessionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalkSessionState&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&const DeepCollectionEquality().equals(other.routePoints, routePoints)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.pausedDurationSeconds, pausedDurationSeconds) || other.pausedDurationSeconds == pausedDurationSeconds)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,startedAt,const DeepCollectionEquality().hash(routePoints),distanceMeters,isActive,isPaused,pausedDurationSeconds,error);

@override
String toString() {
  return 'WalkSessionState(sessionId: $sessionId, startedAt: $startedAt, routePoints: $routePoints, distanceMeters: $distanceMeters, isActive: $isActive, isPaused: $isPaused, pausedDurationSeconds: $pausedDurationSeconds, error: $error)';
}


}

/// @nodoc
abstract mixin class $WalkSessionStateCopyWith<$Res>  {
  factory $WalkSessionStateCopyWith(WalkSessionState value, $Res Function(WalkSessionState) _then) = _$WalkSessionStateCopyWithImpl;
@useResult
$Res call({
 String? sessionId, DateTime? startedAt, List<GeoPoint> routePoints, double distanceMeters, bool isActive, bool isPaused, int pausedDurationSeconds, String? error
});




}
/// @nodoc
class _$WalkSessionStateCopyWithImpl<$Res>
    implements $WalkSessionStateCopyWith<$Res> {
  _$WalkSessionStateCopyWithImpl(this._self, this._then);

  final WalkSessionState _self;
  final $Res Function(WalkSessionState) _then;

/// Create a copy of WalkSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = freezed,Object? startedAt = freezed,Object? routePoints = null,Object? distanceMeters = null,Object? isActive = null,Object? isPaused = null,Object? pausedDurationSeconds = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,routePoints: null == routePoints ? _self.routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<GeoPoint>,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,pausedDurationSeconds: null == pausedDurationSeconds ? _self.pausedDurationSeconds : pausedDurationSeconds // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WalkSessionState].
extension WalkSessionStatePatterns on WalkSessionState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalkSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalkSessionState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalkSessionState value)  $default,){
final _that = this;
switch (_that) {
case _WalkSessionState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalkSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _WalkSessionState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? sessionId,  DateTime? startedAt,  List<GeoPoint> routePoints,  double distanceMeters,  bool isActive,  bool isPaused,  int pausedDurationSeconds,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalkSessionState() when $default != null:
return $default(_that.sessionId,_that.startedAt,_that.routePoints,_that.distanceMeters,_that.isActive,_that.isPaused,_that.pausedDurationSeconds,_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? sessionId,  DateTime? startedAt,  List<GeoPoint> routePoints,  double distanceMeters,  bool isActive,  bool isPaused,  int pausedDurationSeconds,  String? error)  $default,) {final _that = this;
switch (_that) {
case _WalkSessionState():
return $default(_that.sessionId,_that.startedAt,_that.routePoints,_that.distanceMeters,_that.isActive,_that.isPaused,_that.pausedDurationSeconds,_that.error);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? sessionId,  DateTime? startedAt,  List<GeoPoint> routePoints,  double distanceMeters,  bool isActive,  bool isPaused,  int pausedDurationSeconds,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _WalkSessionState() when $default != null:
return $default(_that.sessionId,_that.startedAt,_that.routePoints,_that.distanceMeters,_that.isActive,_that.isPaused,_that.pausedDurationSeconds,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _WalkSessionState implements WalkSessionState {
  const _WalkSessionState({this.sessionId, this.startedAt, final  List<GeoPoint> routePoints = const [], this.distanceMeters = 0.0, this.isActive = false, this.isPaused = false, this.pausedDurationSeconds = 0, this.error}): _routePoints = routePoints;
  

@override final  String? sessionId;
@override final  DateTime? startedAt;
 final  List<GeoPoint> _routePoints;
@override@JsonKey() List<GeoPoint> get routePoints {
  if (_routePoints is EqualUnmodifiableListView) return _routePoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routePoints);
}

@override@JsonKey() final  double distanceMeters;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  bool isPaused;
@override@JsonKey() final  int pausedDurationSeconds;
@override final  String? error;

/// Create a copy of WalkSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalkSessionStateCopyWith<_WalkSessionState> get copyWith => __$WalkSessionStateCopyWithImpl<_WalkSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalkSessionState&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&const DeepCollectionEquality().equals(other._routePoints, _routePoints)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.pausedDurationSeconds, pausedDurationSeconds) || other.pausedDurationSeconds == pausedDurationSeconds)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,startedAt,const DeepCollectionEquality().hash(_routePoints),distanceMeters,isActive,isPaused,pausedDurationSeconds,error);

@override
String toString() {
  return 'WalkSessionState(sessionId: $sessionId, startedAt: $startedAt, routePoints: $routePoints, distanceMeters: $distanceMeters, isActive: $isActive, isPaused: $isPaused, pausedDurationSeconds: $pausedDurationSeconds, error: $error)';
}


}

/// @nodoc
abstract mixin class _$WalkSessionStateCopyWith<$Res> implements $WalkSessionStateCopyWith<$Res> {
  factory _$WalkSessionStateCopyWith(_WalkSessionState value, $Res Function(_WalkSessionState) _then) = __$WalkSessionStateCopyWithImpl;
@override @useResult
$Res call({
 String? sessionId, DateTime? startedAt, List<GeoPoint> routePoints, double distanceMeters, bool isActive, bool isPaused, int pausedDurationSeconds, String? error
});




}
/// @nodoc
class __$WalkSessionStateCopyWithImpl<$Res>
    implements _$WalkSessionStateCopyWith<$Res> {
  __$WalkSessionStateCopyWithImpl(this._self, this._then);

  final _WalkSessionState _self;
  final $Res Function(_WalkSessionState) _then;

/// Create a copy of WalkSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = freezed,Object? startedAt = freezed,Object? routePoints = null,Object? distanceMeters = null,Object? isActive = null,Object? isPaused = null,Object? pausedDurationSeconds = null,Object? error = freezed,}) {
  return _then(_WalkSessionState(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,routePoints: null == routePoints ? _self._routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<GeoPoint>,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,pausedDurationSeconds: null == pausedDurationSeconds ? _self.pausedDurationSeconds : pausedDurationSeconds // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
