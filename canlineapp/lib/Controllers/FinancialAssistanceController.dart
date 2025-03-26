import 'package:cancerline_companion/Data/Model/FinancialInstitutionModel.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Financialassistancecontroller extends ChangeNotifier {
  List<Financial_Institution_Model> financialInstitutions = [];

  bool isLoading = false;

  String _selectedInstitutionType = 'All';
  String get selectedInstitutionType => _selectedInstitutionType;
  List<String> _selectedPartyLists = ['All'];
  List<String> get selectedPartyLists => _selectedPartyLists;
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  /// Fetch a single financial institutions from the database, it also fetches details of the institution
  Future<Map<String, dynamic>?> getFinancialDetails(String id) async {
    try {
      final details = await Supabase.instance.client
          .from('Financial-Institution')
          .select()
          .eq('Financial_Institution_ID', id)
          .single();

      final institution = Financial_Institution_Model.fromJson({
        'Financial_Institution_ID': details['Financial_Institution_ID'],
        'Financial_Institution_Name':
            details['Financial_Institution_Name'] ?? '',
        'Financial_Institution_Desc':
            details['Financial_Institution_Desc'] ?? '',
        'Financial-Institution-Image-Url':
            details['Financial-Institution-Image-Url'],
        'Financial_Institution_Address':
            details['Financial_Institution_Address'] ?? '',
        'Financial_Institution_Latitude':
            details['Financial_Institution_Address_Lat'] ?? '',
        'Financial_Institution_Longitude':
            details['Financial_Institution_Address_Long'] ?? '',
        'Financial_Institution_Type': details['Financial_Institution_Type'],
        'Financial_Institution_Contact_Number':
            details['Financial_Institution_Contact_Number'] ?? '',
        'isverified': details['isverified'] ?? false,
        'Financial_Insitution_opening_hours': Map<String, String>.from(
            details['Financial_Insitution_opening_hours'] ?? {}),
        'Financial_Institution_Requirements': Map<String, String>.from(
            details['Financial_Institution_Requirements'] ?? {}),
        'Financial_Institution_Contact_Numbers': Map<String, String>.from(
            details['Financial_Institution_Contact_Numbers'] ?? {}),
      });

      debugPrint("Fetched financial details: ${institution.toJson()}");

      return institution.toJson();
    } catch (e) {
      debugPrint("Error fetching financial details: $e");
      return null;
    }
  }

  /// Fetch all financial institutions from the database
  /// This method also applies filters based on the selected institution type and party list
  Future<List<Financial_Institution_Model>> getFinancialData() async {
    isLoading = true;
    notifyListeners();
    try {
      var query =
          Supabase.instance.client.from('Financial-Institution').select();

      if (_selectedInstitutionType != 'All') {
        query =
            query.eq('Financial_Institution_Type', _selectedInstitutionType);
      }

      if (selectedPartyLists.isNotEmpty &&
          !selectedPartyLists.contains('All')) {
        query = query.eq('Party-List', selectedPartyLists.first);
      }

      final details = await query;

      List<Financial_Institution_Model> result = [];

      for (var institution in details) {
        if (institution['Financial_Institution_Name'] != null) {
          final fileName = "${institution['Financial_Institution_Name']}.png";
          final imageUrl = Supabase.instance.client.storage
              .from('Assets')
              .getPublicUrl("Financial-Institution/$fileName");

          institution['Financial-Institution-Image-Url'] = imageUrl;
          result.add(Financial_Institution_Model.fromJson(institution));
        }
      }

      // Apply search filtering AFTER fetching data
      if (searchQuery.isEmpty) {
        result = result;
      } else {
        result = result.where((institution) {
          return institution.Financial_Institution_Name.toLowerCase()
              .contains(searchQuery.toLowerCase());
        }).toList();
      }

      result.sort((a, b) =>
          a.Financial_Institution_Name.compareTo(b.Financial_Institution_Name));

      financialInstitutions = result;
      notifyListeners();
      return financialInstitutions;
    } catch (e) {
      debugPrint("Error fetching institutions: $e");
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// New method to fetch images from the database storage
  Future<String?> getImage(String fileName) async {
    try {
      // Ensure the file name is correctly formatted
      final encodedFileName = Uri.encodeFull(fileName);

      // Generate the public URL
      final imageUrl = Supabase.instance.client.storage
          .from('Assets')
          .getPublicUrl("Financial-Institution/$encodedFileName");

      // Debugging output
      debugPrint("Generated Image URL: $imageUrl");

      return imageUrl;
    } catch (error) {
      debugPrint("Error fetching image: $error");
      return null;
    }
  }

  /// Update the filters based on the selected institution type and party list
  void updateFilters({
    String? institutionType,
    List<String>? partyLists,
  }) {
    if (institutionType != null) {
      _selectedInstitutionType = institutionType;
    }
    if (partyLists != null) {
      _selectedPartyLists = partyLists;
    }

    notifyListeners(); // Notify listeners to update UI
    getFinancialData();
  }

  /// Clear all filters
  /// This method resets the selected institution type and party list
  void clearFilters() {
    _selectedInstitutionType = 'All';
    _selectedPartyLists = ['All'];

    notifyListeners(); // Ensure UI updates
    getFinancialData(); // Refresh data
  }

  /// Update the search query
  /// Similar to a setter method but with additional logic to fetch data
  void updateSearchQuery(String query) {
    _searchQuery = query;
    getFinancialData();
  }
}
