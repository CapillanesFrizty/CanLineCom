import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_charts/charts.dart';
// For permissions

const Color _primaryColor = Color(0xFF5B50A0);

class AnalyticsJournal extends StatefulWidget {
  const AnalyticsJournal({super.key});

  @override
  State<AnalyticsJournal> createState() => _AnalyticsJournalState();
}

class _AnalyticsJournalState extends State<AnalyticsJournal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    Directory dir;

    if (Platform.isAndroid) {
      // For Android: get the download folder path
      dir = (await getExternalStorageDirectory())!;
      String downloadFolderPath =
          "${dir.path}/Download"; // Append 'Download' folder
      Directory(downloadFolderPath)
          .createSync(recursive: true); // Create folder if it doesn't exist
    } else {
      // For iOS, still saving to Documents folder
      dir = await getApplicationDocumentsDirectory();
    }

    debugPrint("Download Directory: $dir");

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Title
              pw.Container(
                child: pw.Text(
                  "Journal Summary Report",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              // Summation of Entries
              pw.SizedBox(height: 20),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  // Total Entries
                  pw.Container(
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Column(children: [
                      pw.Text(
                        textAlign: pw.TextAlign.center,
                        'Total\nJournals',
                        style: pw.TextStyle(
                          fontSize: 20,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        '5',
                        style: pw.TextStyle(
                          fontSize: 20,
                          color: PdfColors.black,
                        ),
                      ),
                    ]),
                  ),
                  pw.SizedBox(width: 10),
                  // Positive Emotions
                  pw.Container(
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Column(children: [
                      pw.Text(
                        textAlign: pw.TextAlign.center,
                        'Positive\nEmotions',
                        style: pw.TextStyle(
                          fontSize: 20,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        '1',
                        style: pw.TextStyle(
                          fontSize: 20,
                          color: PdfColors.black,
                        ),
                      ),
                    ]),
                  ),
                  pw.SizedBox(width: 10),
                  // Negative Emotions
                  pw.Container(
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Column(children: [
                      pw.Text(
                        textAlign: pw.TextAlign.center,
                        'Negative\nEmotions',
                        style: pw.TextStyle(
                          fontSize: 20,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        '4',
                        style: pw.TextStyle(
                          fontSize: 20,
                          color: PdfColors.black,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),

              // Table 1.1: Emotions Distribution\
              pw.SizedBox(height: 20),
              pw.Text("Table 1.1: Emotions Distribution",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Table(
                border: pw.TableBorder.all(width: 1.0),
                children: [
                  pw.TableRow(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey300,
                      child: pw.Text('Emotions'),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey300,
                      child: pw.Text('Number of Intances'),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('Awesome'),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('5'),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('Happy'),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('3'),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('Okay'),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('7'),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('Sad'),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('1'),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('Terrible'),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('1'),
                    ),
                  ]),
                ],
              ),

              //Table 1.2: Changes in Emotions
              pw.SizedBox(height: 20),
              pw.Text(
                'Table 1.2: Weekly Positive Emotions',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.Table(
                border: pw.TableBorder.all(width: 1.0),
                children: [
                  pw.TableRow(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey300,
                      child: pw.Text('Day'),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey300,
                      child: pw.Text('Number Emotions'),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('Monday'),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('5'),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('Teusday'),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('3'),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('Wednesday'),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('7'),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('Thursday'),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('1'),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('Friday'),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      color: PdfColors.grey100,
                      child: pw.Text('1'),
                    ),
                  ]),
                ],
              ),
            ],
          );
        },
      ),
    );

    String filePath = "${dir.path}/example.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    debugPrint("PDF saved at: $filePath");
  }

  @override
  Widget build(BuildContext context) {
    // Weekly emotion data
    final List<ChartData> weeklyData = [
      ChartData('Week 1', '😁', Emotion.awesome),
      ChartData('Week 2', '😄', Emotion.happy),
      ChartData('Week 3', '😊', Emotion.neutral),
      ChartData('Week 4', '😢', Emotion.sad),
      ChartData('Week 5', '😣', Emotion.terrible),
    ];

    // Monthly emotion data
    final List<ChartData> monthlyData = [
      ChartData('Jan', '😁', Emotion.awesome),
      ChartData('Feb', '😄', Emotion.happy),
      ChartData('Mar', '😊', Emotion.neutral),
      ChartData('Apr', '😢', Emotion.sad),
      ChartData('May', '😣', Emotion.terrible),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {
              generatePdf();
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        title: const Text('Journal Analytics',
            style: TextStyle(color: _primaryColor)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: _primaryColor,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 15.0),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Weekly'),
                Tab(text: 'Monthly'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAnalyticsView(weeklyData),
                _buildAnalyticsView(monthlyData),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsView(List<ChartData> chartData) {
    final int totalEntries = chartData.length;
    // final int positiveMoods = chartData
    //     .where((data) =>
    //         data.emotion == Emotion.awesome || data.emotion == Emotion.happy)
    //     .length;
    final int negativeMoods = chartData
        .where((data) =>
            data.emotion == Emotion.sad || data.emotion == Emotion.terrible)
        .length;

    final int awesomeCount =
        chartData.where((data) => data.emotion == Emotion.awesome).length;
    final int happyCount =
        chartData.where((data) => data.emotion == Emotion.happy).length;
    final int neutralCount =
        chartData.where((data) => data.emotion == Emotion.neutral).length;
    final int sadCount =
        chartData.where((data) => data.emotion == Emotion.sad).length;
    final int terribleCount =
        chartData.where((data) => data.emotion == Emotion.terrible).length;

    final List<EmotionData> emotionData = [
      EmotionData('😁', awesomeCount, Colors.blue),
      EmotionData('😄', happyCount, Colors.green),
      EmotionData('😊', neutralCount, Colors.orange),
      EmotionData('😢', sadCount, Colors.red),
      EmotionData('😣', terribleCount, Colors.purple),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300, // Fixed height for the first chart
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SfCartesianChart(
                    title: ChartTitle(
                        text: 'Emotion Trend',
                        textStyle: const TextStyle(
                            fontSize: 16, color: _primaryColor)),
                    series: <CartesianSeries>[
                      SplineSeries<ChartData, String>(
                        color: _primaryColor,
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.emotion.index,
                        markerSettings: const MarkerSettings(isVisible: true),
                      )
                    ],
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      axisLine: const AxisLine(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      axisLine: const AxisLine(width: 0),
                      labelFormat: '{value}',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              color: _primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        '$totalEntries',
                        style:
                            const TextStyle(fontSize: 70, color: Colors.white),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Total Journal Entries:',
                        style:
                            const TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              '$happyCount',
                              style: const TextStyle(
                                  fontSize: 60, color: Colors.white),
                            ),
                            Text(
                              'Positive Moods',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Card(
                    color: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              '$negativeMoods',
                              style: const TextStyle(
                                  fontSize: 60, color: Colors.white),
                            ),
                            Text(
                              'Negative Moods',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Emotion Distribution',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 4, // Adds shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(12.0), // Adds spacing inside the card
                child: SizedBox(
                  height: 300, // Fixed height for the second chart
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                      isVisible: false,
                    ),
                    series: <CartesianSeries>[
                      StackedColumnSeries<EmotionData, String>(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30.0)),
                        dataSource: emotionData,
                        xValueMapper: (EmotionData data, _) => data.emotion,
                        yValueMapper: (EmotionData data, _) => data.count,
                        pointColorMapper: (EmotionData data, _) => data.color,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmotionData {
  EmotionData(this.emotion, this.count, this.color);
  final String emotion;
  final int count;
  final Color color;
}

enum Emotion { awesome, happy, neutral, sad, terrible }

extension EmotionExtension on Emotion {
  String get emoji {
    switch (this) {
      case Emotion.awesome:
        return '😁';
      case Emotion.happy:
        return '😄';
      case Emotion.neutral:
        return '😊';
      case Emotion.sad:
        return '😢';
      case Emotion.terrible:
        return '😣';
    }
  }
}

class ChartData {
  ChartData(this.x, this.y, this.emotion);
  final String x;
  final String y;
  final Emotion emotion;
}
