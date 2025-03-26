import 'package:cancerline_companion/Controllers/FinancialAssistanceController.dart';
import 'package:cancerline_companion/Data/Model/FinancialInstitutionModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons_flutter/test_icons.dart';
import 'package:readmore/readmore.dart';

class PartylistDetails extends StatefulWidget {
  final String partylistid;
  const PartylistDetails({super.key, required this.partylistid});

  @override
  State<PartylistDetails> createState() => _PartylistDetailsState();
}

class _PartylistDetailsState extends State<PartylistDetails> {
  late Future<Map<String, dynamic>?> detailsFuture;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    detailsFuture =
        Financialassistancecontroller().getFinancialDetails(widget.partylistid);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      detailsFuture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go('/Financial-Institution'),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found.'));
          }

          Financial_Institution_Model data =
              Financial_Institution_Model.fromJson(snapshot.data!);
          return ListView(
            children: [
              FutureBuilder(
                future: Financialassistancecontroller()
                    .getImage('${data.Financial_Institution_Name}.png'),
                builder: (context, snapshot) {
                  return Image.network(
                    snapshot.data.toString(),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint("Error loading image: $error");
                      return const Icon(Icons.image_not_supported, size: 100);
                    },
                  );
                },
              ),

              // ! READ ME BEFORE YOU PROCEED:
              /// The code below is for the partylist details structured and design as maintainable as possible
              /// it shows that before the data is being showed in the UI it checks first if the data is null or not
              /// if the data is null it will not show the data in the UI

              // This portion of the code is for the name and type of the Financial Insitution [Partylist]
              data.Financial_Institution_Name == null
                  ? const SizedBox()
                  : ListTile(
                      subtitle: data.Financial_Institution_Type == null
                          ? const SizedBox()
                          : Text(
                              data.Financial_Institution_Type,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      title: Text(
                        data.Financial_Institution_Name,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff5B50A0),
                        ),
                      ),
                    ),

              /// This portion of the code is for the description of the Financial Insitution [Partylist]
              data.Financial_Institution_Desc == null ||
                      data.Financial_Institution_Desc.isEmpty ||
                      data.Financial_Institution_Desc == 'none'
                  ? const SizedBox()
                  : ListTile(
                      subtitle: ReadMoreText(
                        data.Financial_Institution_Desc,
                        trimLines: 6,
                        colorClickableText: const Color(0xff5B50A0),
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
              // This portion is for the operational hours of the Financial Insitution [Partylist]
              data.Financial_Insitution_opening_hours.isEmpty
                  ? const SizedBox()
                  :
                  // ! NOTE: You can change the ListTile to any other widget you want
                  ListTile(
                      title: Text(
                        'Opening Hours',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff5B50A0),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.Financial_Insitution_opening_hours.entries
                                .map((entry) => '${entry.key}:  ${entry.value}')
                                .join('\n'),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Disclaimer: The schedule may differ depending on the number of people arriving. It is best to arrive early.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              // This portion is for the address of the Financial Insitution [Partylist]
              data.Financial_Institution_Address == null
                  ? const SizedBox()
                  : ListTile(
                      title: Text(
                        'Address',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff5B50A0),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.Financial_Institution_Address,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          // This portion is for the map of the Financial Insitution [Partylist]
                          SizedBox(
                            height: 300,
                            width: 500,
                            child: GoogleMap(
                              onMapCreated: (GoogleMapController controller) {
                                mapController = controller;
                              },
                              liteModeEnabled: true,
                              zoomControlsEnabled: true,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  data.Financial_Institution_Latitude ?? 0.0,
                                  data.Financial_Institution_Longitude ?? 0.0,
                                ),
                                zoom: 18.0,
                              ),
                              markers: {
                                Marker(
                                  markerId: MarkerId(
                                    data.Financial_Institution_Name,
                                  ),
                                  icon: BitmapDescriptor.defaultMarker,
                                  position: LatLng(
                                    data.Financial_Institution_Latitude ?? 0.0,
                                    data.Financial_Institution_Longitude ?? 0.0,
                                  ),
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

              // This portion is for the requirements of the Financial Insitution [Partylist]
              data.Financial_Institution_Requirements!.isEmpty
                  ? const SizedBox()
                  :
                  // ! NOTE: You can change the ListTile to any other widget you want
                  ListTile(
                      title: data.Financial_Institution_Requirements!.isEmpty
                          ? null
                          : Text(
                              'Requirements',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff5B50A0),
                              ),
                            ),
                      subtitle: Column(
                        children: [
                          ...data.Financial_Institution_Requirements!.entries
                              .map((entry) {
                            return Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '• ${entry.key}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: entry.value == '' ||
                                                  entry.value == null ||
                                                  entry.value == 'none'
                                              ? ''
                                              : ': ${entry.value}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Color.fromARGB(255, 0, 89, 255)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Disclaimer: If all requirements are complete and correct, you can submit them to the partylist. Double-check everything before submitting.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color:
                                        const Color.fromARGB(255, 0, 89, 255),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

              // This portion is for the contact number of the Financial Insitution [Partylist]
              data.Financial_Institution_Contact_Numbers!.isEmpty
                  ? const SizedBox()
                  : ListTile(
                      title: Text(
                        'Contact Number',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff5B50A0),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data
                            .Financial_Institution_Contact_Numbers!.entries
                            .map((entry) {
                          return Row(
                            children: [
                              entry.key == "email"
                                  ? const Icon(Icons.email)
                                  : const Icon(Icons.phone),
                              const SizedBox(width: 8),
                              Text(
                                entry.value,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
