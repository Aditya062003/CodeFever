import 'package:codefever/services/networkhelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';

class GithubHeatMap extends StatefulWidget {
  const GithubHeatMap({Key? key}) : super(key: key);

  @override
  createState() => _GithubHeatMapState();
}

class _GithubHeatMapState extends State<GithubHeatMap> {
  int _totalContributions = 0;
  Map<DateTime, int> heatmapData = {};

  @override
  void initState() {
    super.initState();
    _getTotalContributions();
  }

  void _getTotalContributions() async {
    DateTime currentDate = DateTime.now();
    DateTime threeMonthsAgo = currentDate.subtract(const Duration(days: 180));
    var url = Uri.parse(
        'https://github-contributions-api.jogruber.de/v4/Aditya062003?y=2023');
    NetWorkHelper netWorkHelper = NetWorkHelper(url);
    var response = await netWorkHelper.getData();
    var totalContributions = response['total']['2023'];
    var contributions = response['contributions'];
    for (var contribution in contributions) {
      var date = DateTime.parse(contribution['date']);
      if (date.isAfter(threeMonthsAgo) && date.isBefore(currentDate)) {
        int count = contribution['count'];
        heatmapData[date] = count;
      }
    }
    setState(() {
      _totalContributions = totalContributions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Total Contributions: $_totalContributions',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 16,
        ),
        HeatMap(
          datasets: heatmapData,
          startDate: DateTime.now().subtract(const Duration(days: 180)),
          colorMode: ColorMode.color,
          showText: false,
          scrollable: true,
          colorsets: {
            1: Colors.green[200]!,
            2: Colors.green[300]!,
            3: Colors.green[400]!,
            7: Colors.green,
            10: Colors.green[600]!,
            15: Colors.green[700]!,
            20: Colors.green[800]!,
          },
          onClick: (value) {
            String datetimestring = value.toString();
            String date = datetimestring.substring(0, 10);
            DateTime dateTime = DateTime.parse(date);
            final formatter = DateFormat('MMMM d, y');
            String formattedDate = formatter.format(dateTime);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "${heatmapData[value]} contributions on $formattedDate"),
              ),
            );
          },
        ),
      ],
    );
  }
}
