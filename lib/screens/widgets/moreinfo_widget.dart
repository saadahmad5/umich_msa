import 'package:flutter/material.dart';

class MoreInfoWidget extends StatefulWidget {
  const MoreInfoWidget({Key? key}) : super(key: key);

  @override
  _MoreInfoWidgetState createState() => _MoreInfoWidgetState();
}

class _MoreInfoWidgetState extends State<MoreInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            labelColor: Color.fromARGB(255, 30, 48, 96),
            tabs: [
              Tab(icon: Icon(Icons.info_outline)),
              Tab(icon: Icon(Icons.people_alt_outlined)),
            ],
          ),
          body: TabBarView(
            children: [
              Icon(Icons.info_rounded),
              Icon(Icons.people_alt_rounded)
            ],
          ),
        ),
      ),
    );
  }
}
