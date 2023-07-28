import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GithubHeatMap extends StatefulWidget {
  const GithubHeatMap(
      {super.key,
      required this.isGHLoading,
      required this.totalContributions,
      required this.heatmapData,
      required this.invalidGHUsername,
      required this.noGH});

  final bool isGHLoading;
  final int totalContributions;
  final Map<DateTime, int> heatmapData;
  final bool noGH;
  final bool invalidGHUsername;

  @override
  createState() => _GithubHeatMapState();
}

class _GithubHeatMapState extends State<GithubHeatMap> {
  @override
  Widget build(BuildContext context) {
    return widget.noGH
        ? const Center(
            child: Text('Please Provide your Github Username'),
          )
        : widget.invalidGHUsername
            ? const Center(
                child: Text('Please Provide a Valid Github Username'),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.isGHLoading
                      ? CircularPercentIndicator(
                          radius: 8.0,
                          lineWidth: 2.0,
                          percent: 1.0,
                          progressColor: Colors.blue,
                        )
                      : Text(
                          'Total Contributions: ${widget.totalContributions}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                  const SizedBox(
                    height: 16,
                  ),
                  widget.isGHLoading
                      ? Center(
                          child: CircularPercentIndicator(
                            radius: 16.0,
                            lineWidth: 2.0,
                            percent: 1.0,
                            progressColor: Colors.blue,
                          ),
                        )
                      : HeatMap(
                          datasets: widget.heatmapData,
                          startDate: DateTime.now()
                              .subtract(const Duration(days: 180)),
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
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "${widget.heatmapData[value]} contributions on $formattedDate"),
                              ),
                            );
                          },
                        ),
                ],
              );
  }
}
