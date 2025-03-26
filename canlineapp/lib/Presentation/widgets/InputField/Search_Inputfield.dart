import 'package:cancerline_companion/Controllers/FinancialAssistanceController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchInputfield extends StatelessWidget {
  final Function(String query) onSearch;
  const SearchInputfield({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search here...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF5B50A0)),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF5B50A0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF5B50A0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF5B50A0)),
          ),
        ),
        onChanged: onSearch,
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final financialController =
        Provider.of<Financialassistancecontroller>(context, listen: false);

    final List<Map<String, List<String>>> filterCategories = [
      {
        'Institution Types': [
          'All',
          'Private Institution',
          'Government Institution',
          'Partylist',
        ],
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filter Institutions',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5B50A0),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Filter List
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: filterCategories.length,
                          itemBuilder: (context, index) {
                            final category = filterCategories[index];
                            final title = category.keys.first;
                            final options = category.values.first;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF5B50A0),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...options.map((type) {
                                  return RadioListTile<String>(
                                    title: Text(
                                      type,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                    value: type,
                                    groupValue: financialController
                                        .selectedInstitutionType,
                                    onChanged: (String? value) {
                                      setState(() {
                                        if (value != null) {
                                          financialController.updateFilters(
                                              institutionType: value);
                                        }
                                      });
                                    },
                                    activeColor: Color(0xFF5B50A0),
                                  );
                                }),
                                const SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                      ),

                      // Buttons (Clear & Apply)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  financialController.clearFilters();
                                  Navigator.pop(context);
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Color(0xFF5B50A0)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Clear All',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF5B50A0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF5B50A0),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Apply Filters',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
