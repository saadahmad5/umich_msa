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
                icon: Image.asset("assets/images/icon64.png"),
                onPressed: () {}),
            iconTheme: IconThemeData(color: Colors.yellow),
            backgroundColor: const Color.fromARGB(255, 30, 48, 96),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.access_alarm_outlined)), // Widgets class
                Tab(icon: Icon(Icons.add_task_outlined)),
              ],
            ),
            title: const Text(
              'University of Michigan - MSA',
              style: TextStyle(color: Color.fromARGB(255, 252, 210, 12)),
            ),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.access_alarm_outlined),
              Icon(Icons.add_task_outlined)
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.white,
            selectedItemColor: Color.fromARGB(230, 252, 210, 12),
            backgroundColor: Color.fromARGB(255, 30, 48, 96),
            type: BottomNavigationBarType.fixed,
            currentIndex: 1, // this will be set when a new tab is tapped
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.access_alarm_outlined),
                label: 'Salah Time',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.announcement_outlined),
                label: 'Updates',
              ),
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
