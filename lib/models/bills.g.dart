// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bills.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bills _$BillsFromJson(Map<String, dynamic> json) {
  return Bills(
    json['id'],
    json['bill_date'] as int?,
    json['amount'] as num?,
    json['quantification'] as int?,
    json['payer_ids'] as List<dynamic>?,
  )
    ..createdOn = DateTime.parse(json['created_on'] as String)
    ..modifiedOn = json['modified_on'] == null
        ? null
        : DateTime.parse(json['modified_on'] as String);
}

Map<String, dynamic> _$BillsToJson(Bills instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['created_on'] = instance.createdOn.toIso8601String();
  val['modified_on'] = instance.modifiedOn?.toIso8601String();
  val['bill_date'] = instance.billdate;
  val['amount'] = instance.amount;
  val['quantification'] = instance.quantification;
  val['payer_ids'] = instance.payerIds;
  return val;
}
