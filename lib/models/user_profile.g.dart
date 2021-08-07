// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile()
    ..id = json['id'] as String?
    ..createdOn = DateTime.parse(json['created_on'] as String)
    ..modifiedOn = json['modified_on'] == null
        ? null
        : DateTime.parse(json['modified_on'] as String)
    ..displayName = json['display_name'] as String?
    ..userCode = json['user_code'] as String?
    ..email = json['email'] as String?
    ..photoUrl = json['photo_url'] as String?
    ..phoneNumber = json['phone_number'] as String?
    ..loggedIn = json['logged_in'] as bool?
    ..members = json['members'] as int?
    ..registeredUsing = json['registered_using'] as String?
    ..billingGenDate = json['billing_generation_date'] == null
        ? null
        : DateTime.parse(json['billing_generation_date'] as String)
    ..userType = json['user_type'] as String?
    ..pin = json['pin'] as String?;
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['created_on'] = instance.createdOn.toIso8601String();
  val['modified_on'] = instance.modifiedOn?.toIso8601String();
  val['display_name'] = instance.displayName;
  val['user_code'] = instance.userCode;
  val['email'] = instance.email;
  val['photo_url'] = instance.photoUrl;
  val['phone_number'] = instance.phoneNumber;
  val['logged_in'] = instance.loggedIn;
  val['members'] = instance.members;
  val['registered_using'] = instance.registeredUsing;
  val['billing_generation_date'] = instance.billingGenDate?.toIso8601String();
  val['user_type'] = instance.userType;
  val['pin'] = instance.pin;
  return val;
}

UserLogin _$UserLoginFromJson(Map<String, dynamic> json) {
  return UserLogin()
    ..id = json['id'] as String?
    ..createdOn = DateTime.parse(json['created_on'] as String)
    ..modifiedOn = json['modified_on'] == null
        ? null
        : DateTime.parse(json['modified_on'] as String)
    ..displayName = json['display_name'] as String?
    ..email = json['email'] as String?
    ..photoUrl = json['photo_url'] as String?
    ..phoneNumber = json['phone_number'] as String?
    ..loggedIn = json['logged_in'] as bool?
    ..pin = json['pin'] as String?
    ..registeredUsing = json['registered_using'] as String?;
}

Map<String, dynamic> _$UserLoginToJson(UserLogin instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['created_on'] = instance.createdOn.toIso8601String();
  val['modified_on'] = instance.modifiedOn?.toIso8601String();
  val['display_name'] = instance.displayName;
  val['email'] = instance.email;
  val['photo_url'] = instance.photoUrl;
  val['phone_number'] = instance.phoneNumber;
  val['logged_in'] = instance.loggedIn;
  val['pin'] = instance.pin;
  val['registered_using'] = instance.registeredUsing;
  return val;
}
