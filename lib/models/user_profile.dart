import 'package:bills/models/members.dart';
import 'package:bills/models/model_base.dart';
import 'package:bills/models/pallette_swatch.dart';
import 'package:flutter/material.dart';

import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile extends ModelBase {
  @JsonKey(name: "name")
  String? name = "";
  @JsonKey(name: "name_separated")
  List<String>? nameseparated = [];
  @JsonKey(name: "user_code")
  String? userCode = "";
  @JsonKey(name: "email")
  String? email = "";
  @JsonKey(name: "photo_url")
  String? photoUrl = "";
  @JsonKey(name: "phone_number")
  String? phoneNumber = "";
  @JsonKey(name: "logged_in")
  bool? loggedIn = false;
  @JsonKey(name: "last_logged_in")
  DateTime? lastLoggedIn = DateTime.now();
  // @JsonKey(name: "members")
  // int members = 1;
  @JsonKey(name: "is_admin")
  bool? isAdmin = false;
  @JsonKey(name: "registered_using")
  String? registeredUsing = "";
  @JsonKey(name: "billing_date")
  DateTime? billingDate;
  @JsonKey(name: "user_type")
  String? userType = "";
  @JsonKey(name: "pin")
  String? pin = "";
  @JsonKey(name: "pallette_swatch")
  PalletteSwatch? palletteSwatch = PalletteSwatch();

  @JsonKey(name: "members")
  List<Map<String, dynamic>> members = [];
  // @JsonKey(name: "user_ids")
  // List<String?>? userIds = [];

  @JsonKey(ignore: true)
  List<UserProfile> users = [];
  @JsonKey(ignore: true)
  //@JsonKey(name: "membersArr")
  List<Members> membersArr = [];
  @JsonKey(ignore: true)
  ImageProvider userImage = const AssetImage("assets/icons/user.png");

  UserProfile();

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  //custom functions
  bool isNewUser() {
    return userType?.isEmpty ?? false;
  }

  mapMembers() {
    membersArr = List<Members>.from(members.map((e) {
      return Members.fromJson(e);
    }));
  }
}
