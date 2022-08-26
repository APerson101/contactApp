import 'dart:convert';

import 'package:contactapp/homepage.dart';
import 'package:flutter/foundation.dart';

class ContactInfo {
  String? title;
  String firstName;
  String lastName;
  String? organizationName;
  String? positionTitle;
  List<PhoneInfo>? phones;
  List<EmailInfo>? emails;
  List<String>? addresses;
  List<String>? websites;
  String? id;
  String email;
  DateTime? birthday;
  bool approved;
  String? notes;
  String? pictureURL;
  String? picType;
  ContactInfo(
      {this.id,
      this.notes,
      this.title,
      this.birthday,
      this.approved = false,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.organizationName,
      this.positionTitle,
      this.phones,
      this.emails,
      this.addresses,
      this.websites,
      this.pictureURL,
      this.picType});

  ContactInfo copyWith(
      {String? title,
      String? id,
      String? notes,
      bool? approved,
      DateTime? birthday,
      String? firstName,
      String? lastName,
      String? organizationName,
      String? positionTitle,
      List<PhoneInfo>? phones,
      List<EmailInfo>? emails,
      List<String>? addresses,
      List<String>? websites,
      String? email,
      String? pictureURL,
      String? picType}) {
    return ContactInfo(
        title: title ?? this.title,
        notes: notes ?? this.notes,
        birthday: birthday ?? this.birthday,
        firstName: firstName ?? this.firstName,
        pictureURL: pictureURL ?? this.pictureURL,
        lastName: lastName ?? this.lastName,
        approved: approved ?? this.approved,
        email: email ?? this.email,
        organizationName: organizationName ?? this.organizationName,
        positionTitle: positionTitle ?? this.positionTitle,
        phones: phones ?? this.phones,
        emails: emails ?? this.emails,
        addresses: addresses ?? this.addresses,
        websites: websites ?? this.websites,
        picType: picType ?? this.picType,
        id: id ?? this.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'firstName': firstName,
      'notes': notes,
      'birthday': birthday?.microsecondsSinceEpoch,
      'lastName': lastName,
      'pictureURL': pictureURL,
      'email': email,
      'organizationName': organizationName,
      'positionTitle': positionTitle,
      'phones': phones?.map((x) => x.toMap()).toList(),
      'emails': emails,
      'addresses': addresses,
      'websites': websites,
      'id': id,
      'picType': picType,
      'approved': approved
    };
  }

  factory ContactInfo.fromMap(Map<String, dynamic> map) {
    return ContactInfo(
      title: map['title'],
      notes: map['notes'],
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      id: map['id'],
      email: map['email'],
      pictureURL: map['pictureURL'],
      approved: map['approved'] ?? false,
      picType: map['picType'],
      birthday: map['birthday'] != null
          ? DateTime.fromMicrosecondsSinceEpoch(map['birthday'])
          : null,
      organizationName: map['organizationName'],
      positionTitle: map['positionTitle'],
      phones: map['phones'] != null
          ? List<PhoneInfo>.from(
              map['phones']?.map((x) => PhoneInfo.fromMap(x)))
          : null,
      emails: map['emails'] != null
          ? List<EmailInfo>.from(
              map['emails']?.map((x) => EmailInfo.fromMap(x)))
          : null,
      addresses:
          map['addresses'] != null ? List<String>.from(map['addresses']) : null,
      websites:
          map['websites'] != null ? List<String>.from(map['websites']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactInfo.fromJson(String source) =>
      ContactInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ContactInfo(title: $title, firstName: $firstName, lastName: $lastName, organizationName: $organizationName, positionTitle: $positionTitle, phones: $phones, emails: $emails, addresses: $addresses, websites: $websites)';
  }
}

class EmailInfo {
  emailTypes type;
  String value;
  EmailInfo({
    required this.type,
    required this.value,
  });

  EmailInfo copyWith({
    emailTypes? type,
    String? value,
  }) {
    return EmailInfo(
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': describeEnum(type),
      'value': value,
    };
  }

  factory EmailInfo.fromMap(Map<String, dynamic> map) {
    return EmailInfo(
      type: emailTypes.values
          .firstWhere((element) => describeEnum(element) == map['type']),
      value: map['value'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EmailInfo.fromJson(String source) =>
      EmailInfo.fromMap(json.decode(source));

  @override
  String toString() => 'EmailInfo(type: $type, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmailInfo && other.type == type && other.value == value;
  }

  @override
  int get hashCode => type.hashCode ^ value.hashCode;
}

class PhoneInfo {
  phoneTypes type;
  String value;
  PhoneInfo({
    required this.type,
    required this.value,
  });

  PhoneInfo copyWith({
    phoneTypes? type,
    String? value,
  }) {
    return PhoneInfo(
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': describeEnum(type),
      'value': value,
    };
  }

  factory PhoneInfo.fromMap(Map<String, dynamic> map) {
    return PhoneInfo(
      type: phoneTypes.values
          .where((element) => describeEnum(element) == map['type'])
          .first,
      value: map['value'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PhoneInfo.fromJson(String source) =>
      PhoneInfo.fromMap(json.decode(source));

  @override
  String toString() => 'PhoneInfo(type: $type, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhoneInfo && other.type == type && other.value == value;
  }

  @override
  int get hashCode => type.hashCode ^ value.hashCode;
}
