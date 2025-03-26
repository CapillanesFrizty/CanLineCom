// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:cancerline_companion/Controllers/FinancialAssistanceController.dart';

Financial_Institution_Model financialInstitutionModelFromJson(String str) =>
    Financial_Institution_Model.fromJson(json.decode(str));

String financialInstitutionModelToJson(Financial_Institution_Model data) =>
    json.encode(data.toJson());

class Financial_Institution_Model {
  /// [id] is the unique identifier for the Financial Institution
  final int Financial_Institution_ID;

  /// [name] is the name of the Financial Institution
  final String Financial_Institution_Name;

  /// [desc] is the description of the Financial Institution
  final String Financial_Institution_Desc;

  /// [address] is the address of the Financial Institution
  final String Financial_Institution_Address;
  final double? Financial_Institution_Latitude;
  final double? Financial_Institution_Longitude;

  /// [type] is the type of the Financial Institution
  final String Financial_Institution_Type;
  
  /// [contact] is the contact number of the Financial Institution
  final String Financial_Institution_Contact_Number;

  /// [Financial_Insitution_opening_hours] is the opening hours of the Financial Institution
  /*
    ------------------------------
    ? Data Structure:
    ? {
    ?   'contact1': '09123123123',
    ?   'contact2': '09123123123', 
    ?   'email1': 'dasdasd@asda.com',
    ? }
    ------------------------------
  */
  /// This is a Map of String to String
  final Map<String, String>? Financial_Institution_Contact_Numbers;

  /// [isverified] is the verification status of the Financial Institution
  final bool isverified;

  /// [Financial_Insitution_opening_hours] is the opening hours of the Financial Institution
  /*
    ------------------------------
    ? Data Structure:
    ? {
    ?   'day1': 'Opening Hours 1',
    ?   'day2': 'Opening Hours 2', 
    ?   'day3': 'Opening Hours 3',
    ? }
    ------------------------------
  */
  /// This is a Map of String to String
  final Map<String, String> Financial_Insitution_opening_hours;

  /// [Financial_Institution_Requirements] is the requirements of the Financial Institution
  /*
    ------------------------------
    ? Data Structure:
    ? {
    ?   'req1': 'Requirement 1',
    ?   'req2': 'Requirement 2', 
    ?   'req3': 'Requirement 3',
    ? }
    ------------------------------
  */
  /// This is a Map of String to String

  final Map<String, String>? Financial_Institution_Requirements;

  /// Use [Financialassistancecontroller.getImage] in the Controller instead
  @Deprecated(
      'Use Financialassistancecontroller.getImage in the Controller instead')
  final String FinancialImage_URL;

  /// A model class representing a financial institution.
  ///
  /// Contains detailed information about a financial institution including its
  /// identification, contact details, operational information, and verification status.
  ///
  /// Parameters:
  /// - [Financial_Institution_ID]: Unique identifier for the financial institution
  /// - [Financial_Institution_Name]: Official name of the financial institution
  /// - [Financial_Institution_Desc]: Detailed description of the financial institution
  /// - [Financial_Institution_Address]: Physical location address
  /// - [Financial_Institution_Type]: Type or category of the financial institution
  /// - [Financial_Institution_Contact_Number]: Contact phone number
  /// - [isverified]: Verification status of the institution
  /// - [Financial_Insitution_opening_hours]: Operating hours
  /// - [FinancialImage_URL]: URL to the institution's image
  /// - [Financial_Institution_Requirements]: Optional list of requirements for customers
  /// - [Financial_Institution_Latitude]: Optional latitude coordinate
  /// - [Financial_Institution_Longitude]: Optional longitude coordinate
  /// - [Financial_Institution_Contact_Numbers]: Optional list of contact numbers
  /// Creates a new instance of [Financial_Institution_Model]

  Financial_Institution_Model({
    required this.Financial_Institution_ID,
    required this.Financial_Institution_Name,
    required this.Financial_Institution_Desc,
    required this.Financial_Institution_Address,
    required this.Financial_Institution_Type,
    required this.Financial_Institution_Contact_Number,
    required this.isverified,
    required this.Financial_Insitution_opening_hours,
    required this.FinancialImage_URL,
    this.Financial_Institution_Requirements,
    this.Financial_Institution_Latitude,
    this.Financial_Institution_Longitude,
    this.Financial_Institution_Contact_Numbers,
  });

  /// Creates a [Financial_Institution_Model] instance from a JSON map.
  ///
  /// The factory constructor accepts a [json] map containing the following fields:
  /// * `Financial_Institution_ID`: Unique identifier for the institution
  /// * `Financial_Institution_Name`: Name of the financial institution (defaults to empty string)
  /// * `Financial_Institution_Desc`: Description of the institution (defaults to empty string)
  /// * `Financial_Institution_Address`: Physical address of the institution (defaults to empty string)
  /// * `Financial_Institution_Type`: Type/category of the institution (defaults to empty string)
  /// * `Financial_Institution_Contact_Number`: Contact information (defaults to empty string)
  /// * `isverified`: Verification status of the institution (defaults to false)
  /// * `Financial_Insitution_opening_hours`: Map of operating hours (defaults to empty map)
  /// * `Financial_Institution_Requirements`: Map of requirements (defaults to empty map)
  /// * `Financial-Institution-Image-Url`: URL for the institution's image (defaults to empty string)
  /// * `Financial_Institution_Latitude`: Latitude coordinate (defaults to null)
  /// * `Financial_Institution_Longitude`: Longitude coordinate (defaults to null)
  /// * `Financial_Institution_Contact_Numbers`: Map of contact numbers (defaults to empty map)
  ///
  /// Returns a new instance of [Financial_Institution_Model] with the parsed data.

  factory Financial_Institution_Model.fromJson(Map<String, dynamic> json) =>
      Financial_Institution_Model(
        Financial_Institution_ID: json['Financial_Institution_ID'],
        Financial_Institution_Name: json['Financial_Institution_Name'] ?? '',
        Financial_Institution_Desc: json['Financial_Institution_Desc'] ?? '',
        Financial_Institution_Address:
            json['Financial_Institution_Address'] ?? '',
        Financial_Institution_Latitude: json['Financial_Institution_Latitude'],
        Financial_Institution_Longitude:
            json['Financial_Institution_Longitude'],
        Financial_Institution_Type: json['Financial_Institution_Type'] ?? '',
        Financial_Institution_Contact_Number:
            json['Financial_Institution_Contact_Number'] ?? '',
        isverified: json['isverified'] ?? false,
        Financial_Insitution_opening_hours: Map<String, String>.from(
            json['Financial_Insitution_opening_hours'] ?? {}),
        Financial_Institution_Requirements: Map<String, String>.from(
            json['Financial_Institution_Requirements'] ?? {}),
        Financial_Institution_Contact_Numbers: Map<String, String>.from(
            json['Financial_Institution_Contact_Numbers'] ?? {}),
        FinancialImage_URL: json['Financial-Institution-Image-Url'] ?? '',
      );

  /// A built-in converter to [json], it converts the Financial Institution Model to a JSON object
  Map<String, dynamic> toJson() => {
        "Financial_Institution_ID": Financial_Institution_ID,
        "Financial_Institution_Name": Financial_Institution_Name,
        "Financial_Institution_Desc": Financial_Institution_Desc,
        "Financial_Institution_Address": Financial_Institution_Address,
        "Financial_Institution_Latitude": Financial_Institution_Latitude,
        "Financial_Institution_Longitude": Financial_Institution_Longitude,
        "Financial_Institution_Type": Financial_Institution_Type,
        "Financial_Institution_Contact_Number":
            Financial_Institution_Contact_Number,
        "isverified": isverified,
        "Financial_Insitution_opening_hours":
            Financial_Insitution_opening_hours,
        "Financial_Institution_Requirements":
            Financial_Institution_Requirements,
        "Financial_Institution_Contact_Numbers":
            Financial_Institution_Contact_Numbers,
        "FinancialImage_URL": FinancialImage_URL,
      };
}
