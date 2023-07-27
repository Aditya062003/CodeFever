import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({
    super.key,
    required this.isCCLoading,
    required this.ccranking,
    required this.ccstars,
    required this.isCFLoading,
    required this.cfranking,
    required this.isLCLoading,
    required this.lcrankingint,
    required this.noCC,
    required this.noCF,
    required this.noLC,
  });

  final bool isCCLoading;
  final int? ccranking;
  final String? ccstars;
  final bool isCFLoading;
  final int? cfranking;
  final bool isLCLoading;
  final int? lcrankingint;
  final bool noCC;
  final bool noCF;
  final bool noLC;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          children: const [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                    child: Text(
                  'CodeChef',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
                )),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                    child: Text(
                  'CodeForces',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
                )),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                    child: Text(
                  'LeetCode',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
                )),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: isCCLoading
                    ? CircularPercentIndicator(
                        radius: 8.0,
                        lineWidth: 2.0,
                        percent: 1.0,
                        progressColor: Colors.blue,
                      )
                    : Center(
                        child: ccranking != null
                            ? Text('$ccranking - $ccstars')
                            : noCC
                                ? const Text('-')
                                : const Text('Invalid User')),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: isCFLoading
                    ? CircularPercentIndicator(
                        radius: 8.0,
                        lineWidth: 2.0,
                        percent: 1.0,
                        progressColor: Colors.blue,
                      )
                    : Center(
                        child: cfranking != null
                            ? Text('$cfranking')
                            : noCF
                                ? const Text('-')
                                : const Text('Invalid User')),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: isLCLoading
                    ? CircularPercentIndicator(
                        radius: 8.0,
                        lineWidth: 2.0,
                        percent: 1.0,
                        progressColor: Colors.blue,
                      )
                    : Center(
                        child: lcrankingint != null
                            ? Text('$lcrankingint')
                            : noLC
                                ? const Text('-')
                                : const Text('Invalid User'),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
