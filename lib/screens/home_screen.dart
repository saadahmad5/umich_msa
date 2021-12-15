import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umich_msa/screens/splash_screen.dart';
import 'package:umich_msa/screens/widgets/map_widget.dart';
import '../msa_router.dart';
import '../icons/mosque_icons.dart';

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
      title: "UMICH MSA",
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Image.asset("assets/images/icon64.png"),
                onPressed: () {
                  MsaRouter.instance.pushAndRemoveUntil(SplashScreen.route());
                }),
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
                  fontFamily: "Cronos-Pro",
                  fontSize: 16.0),
            ),
          ),
          body: MapWidget(),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.white,
            selectedItemColor: Color.fromARGB(230, 252, 210, 12),
            backgroundColor: Color.fromARGB(255, 30, 48, 96),
            type: BottomNavigationBarType.fixed,
            currentIndex: 0, // this will be set when a new tab is tapped
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Mosque.mosque_black_outlined), label: 'Map'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined), label: 'Calendar'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.info_outline), label: 'About'),
            ],
          ),
        ),
      ),
    );
  }
}
