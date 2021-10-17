import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = 'homeScreen';
  static Route<HomeScreen> route() {
    return MaterialPageRoute<HomeScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const HomeScreen(),
    );
  }

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Image.asset("assets/images/icon64.png"), onPressed: null),
            iconTheme: IconThemeData(color: Colors.yellow),
            backgroundColor: const Color.fromARGB(255, 30, 48, 96),
            // bottom: const TabBar(
            //   tabs: [
            //     Tab(icon: Icon(Icons.access_alarm_outlined)), // Widgets class
            //     Tab(icon: Icon(Icons.add_task_outlined)),
            //   ],
            // ),
            title: const Text(
              'UMICH Muslim Students\' Association',
              style: TextStyle(
                  color: Color.fromARGB(255, 252, 210, 12),
                  fontFamily: "Cronos-Pro"),
            ),
          ),
          body: Column(
            children: [
              Container(
                child: Text(
                  "Reflection Rooms",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontFamily: "Cronos-Pro",
                      fontSize: 24.0),
                ),
                alignment: AlignmentGeometry.lerp(
                    Alignment.center, Alignment.center, 0),
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
            ],
          ),
          // const TabBarView(
          //   children: [
          //     Icon(Icons.access_alarm_outlined),
          //     Icon(Icons.add_task_outlined)
          //   ],
          // ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.white,
            selectedItemColor: Color.fromARGB(230, 252, 210, 12),
            backgroundColor: Color.fromARGB(255, 30, 48, 96),
            type: BottomNavigationBarType.fixed,
            currentIndex: 0, // this will be set when a new tab is tapped
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Icons.space_dashboard_outlined), label: 'Salah'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined), label: 'Events'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.info_outline), label: 'About'),
            ],
          ),
        ),
      ),
    );
  }
}
