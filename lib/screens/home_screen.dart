import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umich_msa/screens/splash_screen.dart';
import 'package:umich_msa/screens/widgets/events_widget.dart';
import 'package:umich_msa/screens/widgets/map_widget.dart';
import 'package:umich_msa/screens/widgets/moreinfo_widget.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/icons/mosque_icons.dart';

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
  int selectedIndex = 0;
  static const List<BottomNavigationBarItem> navBarItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
    BottomNavigationBarItem(
        icon: Icon(Mosque.mosque_black_outlined), label: 'Ref. Rooms'),
    BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today_outlined), label: 'MSA Calendar'),
    BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'More Info'),
  ];
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'About',
      style: TextStyle(
        fontSize: 24,
      ),
    ),
    MapWidget(),
    EventsWidget(),
    MoreInfoWidget()
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Image.asset("assets/images/icon64.png"),
            onPressed: () {
              MsaRouter.instance.pushAndRemoveUntil(SplashScreen.route());
            }),
        iconTheme: IconThemeData(color: Colors.yellow),
        backgroundColor: const Color.fromARGB(255, 30, 48, 96),
        title: const Text(
          'UMICH Muslim Students\' Association',
          style: TextStyle(
              color: Color.fromARGB(255, 252, 210, 12),
              fontFamily: "Cronos-Pro",
              fontSize: 16.0),
        ),
      ),
      body: _widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        selectedItemColor: Color.fromARGB(230, 252, 210, 12),
        backgroundColor: Color.fromARGB(255, 30, 48, 96),
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        items: navBarItems,
      ),
    );
  }
}
