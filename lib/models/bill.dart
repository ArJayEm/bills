import 'package:bills/models/bill_type.dart';
import 'package:bills/models/model_base.dart';
//import 'package:googleapis/content/v2_1.dart';
//import 'package:intl/intl.dart';

import 'package:json_annotation/json_annotation.dart';
//import 'package:bills/helpers/extensions/format_extension.dart';

part 'bill.g.dart';

@JsonSerializable()
class Bill extends ModelBase {
  @JsonKey(name: "bill_date")
  DateTime? billDate = DateTime.now();
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "amount")
  num? amount = 0.00;
  @JsonKey(name: "quantification")
  int? quantification = 1;
  @JsonKey(name: "payer_ids")
  List<String>? payerIds = [];
  @JsonKey(name: "payers_billtype")
  List<String>? payersBillType = [];
  @JsonKey(name: "bill_type")
  int? billTypeId = 0;
  @JsonKey(name: "client_members")
  int? clientMembers = 0;
  @JsonKey(name: "collector_members")
  int? collectorMembers = 0;

  @JsonKey(ignore: true)
  String? payerNames;
  @JsonKey(ignore: true)
  DateTime? lastModified = DateTime.now();
  @JsonKey(ignore: true)
  BillType? billType = BillType();

  @JsonKey(ignore: true)
  String computation = "";
  @JsonKey(ignore: true)
  int currentReading = 0;
  @JsonKey(ignore: true)
  num rate = 0.00;
  @JsonKey(ignore: true)
  num amountToPay = 0.00;

  Bill(
      {id,
      this.billDate,
      this.description,
      this.amount,
      this.quantification,
      this.payerIds,
      this.payersBillType,
      this.billTypeId,
      this.clientMembers,
      this.collectorMembers
      //this.lastModified= (modifiedOn ?? createdOn)
      });

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);
  Map<String, dynamic> toJson() => _$BillToJson(this);
}