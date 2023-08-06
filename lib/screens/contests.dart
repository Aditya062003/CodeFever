import 'package:codefever/services/networkhelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class ContestScreen extends StatefulWidget {
  const ContestScreen({super.key});

  @override
  State<ContestScreen> createState() => _ContestScreenState();
}

class _ContestScreenState extends State<ContestScreen> {
  List ccContests = [];
  List cfContests = [];
  List lcContests = [];
  bool _isLoading = false;
  var time = 15;

  @override
  void initState() {
    super.initState();
    _fetchContests();
  }

  Future<void> _fetchContests() async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('https://kontests.net/api/v1/all');
    NetWorkHelper netWorkHelper = NetWorkHelper(url);
    var contests = await netWorkHelper.getData();
    for (var contest in contests) {
      if (contest['site'] == 'CodeChef') {
        ccContests.add(contest);
      } else if (contest['site'] == 'CodeForces') {
        cfContests.add(contest);
      } else if (contest['site'] == 'LeetCode') {
        lcContests.add(contest);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  String formatDate(String inputDateTime) {
    final DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss 'UTC'");
    final DateFormat outputFormat = DateFormat("dd MMMM, yyyy h:mma");

    DateTime dateTime = inputFormat.parse(inputDateTime).toLocal();
    String formattedDate = outputFormat.format(dateTime);
    return formattedDate;
  }

  String formatDateLC(String inputDateTime) {
    final DateFormat formatter = DateFormat("dd MMMM, yyyy h:mma");
    DateTime dateTime = DateTime.parse(inputDateTime);
    String formattedDate = formatter.format(dateTime.toLocal());
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Contests'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'CodeChef Contests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ccContests.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(ccContests[index]['name']),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ccContests[index]['url']),
                              Row(
                                children: [
                                  const Icon(CupertinoIcons.time),
                                  Text(
                                    'Starts on ${formatDate(ccContests[index]['start_time'])}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(CupertinoIcons.bell),
                            onPressed: () {
                              showMaterialNumberPicker(
                                context: context,
                                title: 'Set Reminder',
                                maxLongSide: 300,
                                maxShortSide: 100,
                                maxNumber: 30,
                                step: 5,
                                minNumber: 5,
                                selectedNumber: time,
                                onChanged: (value) =>
                                    setState(() => time = value),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'CodeForces Contests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cfContests.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(cfContests[index]['name']),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cfContests[index]['url']),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.time),
                                  Text(
                                    'Starts on ${formatDateLC(cfContests[index]['start_time'])}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(CupertinoIcons.bell),
                            onPressed: () {
                              showMaterialNumberPicker(
                                context: context,
                                title: 'Set Reminder',
                                maxLongSide: 300,
                                maxShortSide: 100,
                                maxNumber: 30,
                                step: 5,
                                minNumber: 5,
                                selectedNumber: time,
                                onChanged: (value) =>
                                    setState(() => time = value),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'LeetCode Contests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lcContests.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(lcContests[index]['name']),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lcContests[index]['url']),
                              Row(
                                children: [
                                  const Icon(CupertinoIcons.time),
                                  Text(
                                    'Starts on ${formatDateLC(lcContests[index]['start_time'])}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(CupertinoIcons.bell),
                            onPressed: () {
                              showMaterialNumberPicker(
                                context: context,
                                title: 'Set Reminder',
                                maxLongSide: 300,
                                maxShortSide: 100,
                                maxNumber: 30,
                                step: 5,
                                minNumber: 5,
                                selectedNumber: time,
                                onChanged: (value) =>
                                    setState(() => time = value),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
