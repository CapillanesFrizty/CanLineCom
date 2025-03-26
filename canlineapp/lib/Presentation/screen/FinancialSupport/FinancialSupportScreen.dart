import 'package:cancerline_companion/Controllers/Utils/Utilities.dart';
import 'package:cancerline_companion/Data/Model/FinancialInstitutionModel.dart';
import 'package:cancerline_companion/Presentation/widgets/Card/CardDesign1.dart';
import 'package:cancerline_companion/Presentation/widgets/InputField/Search_Inputfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cancerline_companion/Controllers/FinancialAssistanceController.dart';
import 'package:provider/provider.dart';

class FinancialSupportScreen extends StatefulWidget {
  const FinancialSupportScreen({super.key});

  @override
  State<FinancialSupportScreen> createState() => _FinancialSupportScreenState();
}

class _FinancialSupportScreenState extends State<FinancialSupportScreen> {
  List<Financial_Institution_Model> financialInstitutions = [];

  // Constants
  static const _primaryColor = Color(0xFF5B50A0);
  static const _secondaryColor = Color(0xFFF3EBFF);
  static const double _cardHeight = 200.0;

  // Styles
  final _titleStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 30.0,
      color: _primaryColor,
    ),
  );

  final _sectionTitleStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 18.0, // Match font size to BlogsScreen
      fontWeight: FontWeight.bold,
      color: _primaryColor,
    ),
  );

  final int _currentCategoryIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Financialassistancecontroller>().getFinancialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final financialController =
        Provider.of<Financialassistancecontroller>(context, listen: false);

    final Utils = Provider.of<Utilities>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: Utils.Refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  SearchInputfield(
                    onSearch: (query) =>
                        financialController.updateSearchQuery(query),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Consumer<Financialassistancecontroller>(
                      builder: (context, financialController, child) {
                        if (financialController.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (financialController.financialInstitutions.isEmpty) {
                          return const Center(child: Text("No data available"));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          itemCount:
                              financialController.financialInstitutions.length,
                          itemBuilder: (context, index) {
                            Financial_Institution_Model data =
                                financialController
                                    .financialInstitutions[index];
                            return CardDesign1(
                              goto: () {
                                if (data.Financial_Institution_Type ==
                                    "Partylist") {
                                  GoRouter.of(context).push(
                                      '/Financial-Institution/partylist/${data.Financial_Institution_ID}');
                                } else {
                                  GoRouter.of(context).push(
                                      '/Financial-Institution/${data.Financial_Institution_ID}');
                                }
                              },
                              image: data.FinancialImage_URL,
                              title: data.Financial_Institution_Name,
                              subtitle: data.Financial_Institution_Type,
                              location: data.Financial_Institution_Address,
                              isVerified: data.isverified,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
