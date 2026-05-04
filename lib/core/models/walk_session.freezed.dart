// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walk_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalkSession {

 String get id; String get userId; DateTime get startedAt; DateTime? get endedAt; List<GeoPoint> get routePoints; double get distanceMeters; int get durationSeconds; bool get isPublic;
/// Create a copy of WalkSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalkSessionCopyWith<WalkSession> get copyWith => _$WalkSessionCopyWithImpl<WalkSession>(this as WalkSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalkSession&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&const DeepCollectionEquality().equals(other.routePoints, routePoints)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,startedAt,endedAt,const DeepCollectionEquality().hash(routePoints),distanceMeters,durationSeconds,isPublic);

@override
String toString() {
  return 'WalkSession(id: $id, userId: $userId, startedAt: $startedAt, endedAt: $endedAt, routePoints: $routePoints, distanceMeters: $distanceMeters, durationSeconds: $durationSeconds, isPublic: $isPublic)';
}


}

/// @nodoc
abstract mixin class $WalkSessionCopyWith<$Res>  {
  factory $WalkSessionCopyWith(WalkSession value, $Res Function(WalkSession) _then) = _$WalkSessionCopyWithImpl;
@useResult
$Res call({
 String id, String userId, DateTime startedAt, DateTime? endedAt, List<GeoPoint> routePoints, double distanceMeters, int durationSeconds, bool isPublic
});




}
/// @nodoc
class _$WalkSessionCopyWithImpl<$Res>
    implements $WalkSessionCopyWith<$Res> {
  _$WalkSessionCopyWithImpl(this._self, this._then);

  final WalkSession _self;
  final $Res Function(WalkSession) _then;

/// Create a copy of WalkSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? startedAt = null,Object? endedAt = freezed,Object? routePoints = null,Object? distanceMeters = null,Object? durationSeconds = null,Object? isPublic = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,routePoints: null == routePoints ? _self.routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<GeoPoint>,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WalkSession].
extension WalkSessionPatterns on WalkSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalkSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalkSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalkSession value)  $default,){
final _that = this;
switch (_that) {
case _WalkSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalkSession value)?  $default,){
final _that = this;
switch (_that) {
case _WalkSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime startedAt,  DateTime? endedAt,  List<GeoPoint> routePoints,  double distanceMeters,  int durationSeconds,  bool isPublic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalkSession() when $default != null:
return $default(_that.id,_that.userId,_that.startedAt,_that.endedAt,_that.routePoints,_that.distanceMeters,_that.durationSeconds,_that.isPublic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime startedAt,  DateTime? endedAt,  List<GeoPoint> routePoints,  double distanceMeters,  int durationSeconds,  bool isPublic)  $default,) {final _that = this;
switch (_that) {
case _WalkSession():
return $default(_that.id,_that.userId,_that.startedAt,_that.endedAt,_that.routePoints,_that.distanceMeters,_that.durationSeconds,_that.isPublic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  DateTime startedAt,  DateTime? endedAt,  List<GeoPoint> routePoints,  double distanceMeters,  int durationSeconds,  bool isPublic)?  $default,) {final _that = this;
switch (_that) {
case _WalkSession() when $default != null:
return $default(_that.id,_that.userId,_that.startedAt,_that.endedAt,_that.routePoints,_that.distanceMeters,_that.durationSeconds,_that.isPublic);case _:
  return null;

}
}

}

/// @nodoc


class _WalkSession extends WalkSession {
  const _WalkSession({required this.id, required this.userId, required this.startedAt, this.endedAt, required final  List<GeoPoint> routePoints, required this.distanceMeters, required this.durationSeconds, required this.isPublic}): _routePoints = routePoints,super._();
  

@override final  String id;
@override final  String userId;
@override final  DateTime startedAt;
@override final  DateTime? endedAt;
 final  List<GeoPoint> _routePoints;
@override List<GeoPoint> get routePoints {
  if (_routePoints is EqualUnmodifiableListView) return _routePoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routePoints);
}

@override final  double distanceMeters;
@override final  int durationSeconds;
@override final  bool isPublic;

/// Create a copy of WalkSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalkSessionCopyWith<_WalkSession> get copyWith => __$WalkSessionCopyWithImpl<_WalkSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalkSession&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&const DeepCollectionEquality().equals(other._routePoints, _routePoints)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,startedAt,endedAt,const DeepCollectionEquality().hash(_routePoints),distanceMeters,durationSeconds,isPublic);

@override
String toString() {
  return 'WalkSession(id: $id, userId: $userId, startedAt: $startedAt, endedAt: $endedAt, routePoints: $routePoints, distanceMeters: $distanceMeters, durationSeconds: $durationSeconds, isPublic: $isPublic)';
}


}

/// @nodoc
abstract mixin class _$WalkSessionCopyWith<$Res> implements $WalkSessionCopyWith<$Res> {
  factory _$WalkSessionCopyWith(_WalkSession value, $Res Function(_WalkSession) _then) = __$WalkSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, DateTime startedAt, DateTime? endedAt, List<GeoPoint> routePoints, double distanceMeters, int durationSeconds, bool isPublic
});




}
/// @nodoc
class __$WalkSessionCopyWithImpl<$Res>
    implements _$WalkSessionCopyWith<$Res> {
  __$WalkSessionCopyWithImpl(this._self, this._then);

  final _WalkSession _self;
  final $Res Function(_WalkSession) _then;

/// Create a copy of WalkSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? startedAt = null,Object? endedAt = freezed,Object? routePoints = null,Object? distanceMeters = null,Object? durationSeconds = null,Object? isPublic = null,}) {
  return _then(_WalkSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,routePoints: null == routePoints ? _self._routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<GeoPoint>,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
