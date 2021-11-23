import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livemeet/src/util/constants.dart';
import 'package:livemeet/src/widget/create_meeting.dart';
import 'package:livemeet/src/widget/join_meeting.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(kAppName),
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                _showAboutUs();
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.white,
            indicator: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white),
            tabs: const [
              Tab(
                text: 'Join Meeting',
                icon: Icon(Icons.group),
              ),
              Tab(
                text: 'Create Meeting',
                icon: Icon(Icons.add_circle),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            JoinMeeting(),
            CreateMeeting(),
          ],
        ),
      ),
    );
  }

  //
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tap again to leave"),
          duration: Duration(seconds: 2),
          //width: 280,
          margin: EdgeInsets.only(left: 50, right: 50, bottom: 40),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      );
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  //
  void _showAboutUs() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('About Us'),
            content: const Text(
                'Jitsi Meet is an open-source (Apache) WebRTC JavaScript application that uses Jitsi Videobridge to provide high quality, secure and scalable video conferences \n\n Developer \n Murali Kumar \n murali.a.kumar@gmail.com'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          );
        });
  }
  //
}
