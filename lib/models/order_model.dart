import 'dart:convert';

import 'package:flutter/material.dart';

// ignore_for_file: sort_constructors_first

/// The model that represent the common app state.
@immutable
class OrderModel {
  /// The model that represent the common app state.
  const OrderModel({
    required this.id,
    required this.name,
    required this.address,
    required this.zipCode,
    required this.city,
  });

  /// The id of this order.
  final int id;

  /// The name of the person that created this order.
  final String name;

  /// The address of this order.
  final String address;

  /// The zip code of this order.
  final String zipCode;

  /// The city of this order.
  final String city;

  /// Converting [OrderModel] to map with string keys.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'zipCode': zipCode,
      'city': city,
    };
  }

  /// Converting map with string keys to [OrderModel].
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      zipCode: map['zipCode'],
      city: map['city'],
    );
  }

  /// Converting [OrderModel] to encoded object.
  String toJson() => json.encode(toMap());

  /// Converting encoded object to [OrderModel].
  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  /// [OrderModel] copying.
  OrderModel copyWith({
    int? id,
    String? name,
    String? address,
    String? zipCode,
    String? city,
  }) {
    return OrderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is OrderModel &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.zipCode == zipCode &&
        other.city == city;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        address.hashCode ^
        zipCode.hashCode ^
        city.hashCode;
  }

  @override
  String toString() {
    return '''OrderModel(id: $id, name: $name, address: $address, zipCode: $zipCode, city: $city)''';
  }
}
