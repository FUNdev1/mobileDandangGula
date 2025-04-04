// To parse this JSON data, do
//
//     final stockGroupModel = stockGroupModelFromJson(jsonString);

import 'dart:convert';

StockGroupModel stockGroupModelFromJson(String str) => StockGroupModel.fromJson(json.decode(str));

String stockGroupModelToJson(StockGroupModel data) => json.encode(data.toJson());

class StockGroupModel {
  String? id;
  String? branchId;
  String? groupName;
  String? items;

  StockGroupModel({
    this.id,
    this.branchId,
    this.groupName,
    this.items,
  });

  StockGroupModel copyWith({
    String? id,
    String? branchId,
    String? groupName,
    String? items,
  }) =>
      StockGroupModel(
        id: id ?? this.id,
        branchId: branchId ?? this.branchId,
        groupName: groupName ?? this.groupName,
        items: items ?? this.items,
      );

  factory StockGroupModel.fromJson(Map<String, dynamic> json) => StockGroupModel(
        id: json["id"],
        branchId: json["branch_id"],
        groupName: json["group_name"],
        items: json["items"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch_id": branchId,
        "group_name": groupName,
        "items": items,
      };
}
