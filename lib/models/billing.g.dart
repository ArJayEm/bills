// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Billing _$BillingFromJson(Map<String, dynamic> json) {
  return Billing()
    ..id = json['id'] as String?
    ..createdOn = DateTime.parse(json['created_on'] as String)
    ..modifiedOn = json['modified_on'] == null
        ? null
        : DateTime.parse(json['modified_on'] as String)
    ..name = json['name'] as String?;
}

Map<String, dynamic> _$BillingToJson(Billing instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['created_on'] = instance.createdOn.toIso8601String();
  val['modified_on'] = instance.modifiedOn?.toIso8601String();
  val['name'] = instance.name;
  return val;
}
