// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Spot {

 String get id; String get sessionId; String get userId; GeoPoint get location; String get photoUrl; String get description; DateTime get createdAt;
/// Create a copy of Spot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpotCopyWith<Spot> get copyWith => _$SpotCopyWithImpl<Spot>(this as Spot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Spot&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.location, location) || other.location == location)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,userId,location,photoUrl,description,createdAt);

@override
String toString() {
  return 'Spot(id: $id, sessionId: $sessionId, userId: $userId, location: $location, photoUrl: $photoUrl, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SpotCopyWith<$Res>  {
  factory $SpotCopyWith(Spot value, $Res Function(Spot) _then) = _$SpotCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, String userId, GeoPoint location, String photoUrl, String description, DateTime createdAt
});




}
/// @nodoc
class _$SpotCopyWithImpl<$Res>
    implements $SpotCopyWith<$Res> {
  _$SpotCopyWithImpl(this._self, this._then);

  final Spot _self;
  final $Res Function(Spot) _then;

/// Create a copy of Spot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? userId = null,Object? location = null,Object? photoUrl = null,Object? description = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Spot].
extension SpotPatterns on Spot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Spot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Spot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Spot value)  $default,){
final _that = this;
switch (_that) {
case _Spot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Spot value)?  $default,){
final _that = this;
switch (_that) {
case _Spot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  String userId,  GeoPoint location,  String photoUrl,  String description,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Spot() when $default != null:
return $default(_that.id,_that.sessionId,_that.userId,_that.location,_that.photoUrl,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  String userId,  GeoPoint location,  String photoUrl,  String description,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Spot():
return $default(_that.id,_that.sessionId,_that.userId,_that.location,_that.photoUrl,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  String userId,  GeoPoint location,  String photoUrl,  String description,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Spot() when $default != null:
return $default(_that.id,_that.sessionId,_that.userId,_that.location,_that.photoUrl,_that.description,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _Spot extends Spot {
  const _Spot({required this.id, required this.sessionId, required this.userId, required this.location, required this.photoUrl, required this.description, required this.createdAt}): super._();
  

@override final  String id;
@override final  String sessionId;
@override final  String userId;
@override final  GeoPoint location;
@override final  String photoUrl;
@override final  String description;
@override final  DateTime createdAt;

/// Create a copy of Spot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpotCopyWith<_Spot> get copyWith => __$SpotCopyWithImpl<_Spot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Spot&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.location, location) || other.location == location)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,userId,location,photoUrl,description,createdAt);

@override
String toString() {
  return 'Spot(id: $id, sessionId: $sessionId, userId: $userId, location: $location, photoUrl: $photoUrl, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SpotCopyWith<$Res> implements $SpotCopyWith<$Res> {
  factory _$SpotCopyWith(_Spot value, $Res Function(_Spot) _then) = __$SpotCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, String userId, GeoPoint location, String photoUrl, String description, DateTime createdAt
});




}
/// @nodoc
class __$SpotCopyWithImpl<$Res>
    implements _$SpotCopyWith<$Res> {
  __$SpotCopyWithImpl(this._self, this._then);

  final _Spot _self;
  final $Res Function(_Spot) _then;

/// Create a copy of Spot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? userId = null,Object? location = null,Object? photoUrl = null,Object? description = null,Object? createdAt = null,}) {
  return _then(_Spot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
