import 'package:cancerline_companion/Controllers/FinancialAssistanceController.dart';
import 'package:cancerline_companion/Data/Model/FinancialInstitutionModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:readmore/readmore.dart';

class PartylistDetails extends StatefulWidget {
  final String partylistid;
  const PartylistDetails({super.key, required this.partylistid});

  @override
  State<PartylistDetails> createState() => _PartylistDetailsState();
}

class _PartylistDetailsState extends State<PartylistDetails> {
  final EdgeInsetsGeometry _TempPadding =
      EdgeInsets.symmetric(horizontal: 30.0);
  late Future<Map<String, dynamic>?> detailsFuture;
  late GoogleMapController mapController;

  Widget _buildDividerWithSpacing() {
    return Column(
      children: const [
        SizedBox(height: 20),
        Divider(
          color: Colors.black,
        ),
        SizedBox(height: 20),
      ],
    );
  }

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
                      contentPadding: _TempPadding,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            data.Financial_Institution_Name,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff5B50A0),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          )
                        ],
                      ),
                      subtitle: data.Financial_Institution_Type == null
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.Financial_Institution_Type,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                _buildDividerWithSpacing(),
                              ],
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
                      contentPadding: _TempPadding,
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
                          SizedBox(
                            height: 10,
                          ),
                          ...data.Financial_Insitution_opening_hours.entries
                              .map((openhours) {
                            return Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: openhours.key,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: openhours.value == '' ||
                                                  openhours.value == null ||
                                                  openhours.value == 'none'
                                              ? ''
                                              : ': ${openhours.value}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 28,
                                )
                              ],
                            );
                          }),
                          SizedBox(
                            height: 20,
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
                          _buildDividerWithSpacing(),
                        ],
                      ),
                    ),

              // This portion is for the requirements of the Financial Insitution [Partylist]
              data.Financial_Institution_Requirements!.isEmpty
                  ? const SizedBox()
                  :
                  // ! NOTE: You can change the ListTile to any other widget you want
                  ListTile(
                      contentPadding: _TempPadding,
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
                          SizedBox(
                            height: 10,
                          ),
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
                                const SizedBox(
                                  height: 28,
                                )
                              ],
                            );
                          }),
                          SizedBox(
                            height: 10,
                          ),
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
                          _buildDividerWithSpacing(),
                        ],
                      ),
                    ),

              // This portion is for the address of the Financial Insitution [Partylist]
              data.Financial_Institution_Address == null
                  ? const SizedBox()
                  : ListTile(
                      contentPadding: _TempPadding,
                      title: Text(
                        textAlign: TextAlign.center,
                        'Where we are?',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff5B50A0),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            data.Financial_Institution_Address,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                          SizedBox(
                            height: 20,
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

              // TODO Add the report this listing
            ],
          );
        },
      ),
    );
  }
}
