import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_mate/components/extensions.dart';
import 'package:health_mate/pages/chat_overview/chat_overview_page.dart';
import 'package:health_mate/views/user_prescriptions_page.dart';
import 'package:health_mate/views/theme_provider.dart';
import 'package:provider/provider.dart';

import '../components/light_color.dart';
import '../components/text_styles.dart';
import '../components/theme.dart';
import '../models/chat_user.dart';
import '../models/data.dart';
import '../models/doctor.dart';
// import '../models/user_data.dart';
import 'doctor_prescriptions_page.dart';

class DoctorHomePage extends StatefulWidget {
  final ChatUser user;
  const DoctorHomePage({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => DoctorHomePageState();
}

class DoctorHomePageState extends State<DoctorHomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  late List<dynamic> patientDataList;
  int _selectedIndex = 0;
  String _searchQuery = "";
  String selectedSortOrder = 'Sort by';
  List<ChatUser> patientList = [];

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    // patientDataList = patientMapList.map((x) => UserData(email: user!.email!).fromPatientJson(x)).toList();
    patientDataList = patientMapList
        .map((x) => ChatUser(email: widget.user.email).fromPatientJson(x))
        .toList();
    patientList = [...patientDataList];
    super.initState();
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text("Health Mate"),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.brightness_6),
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ],
    );
  }

  Widget _header() {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Hello,", style: TextStyles.title.subTitleColor),
            Text("Dr. Shivam Grover", style: TextStyles.h1Style),
          ],
        ));
  }

  Widget _searchField() {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: LightColor.grey.withOpacity(.3),
            blurRadius: 15,
            offset: const Offset(5, 5),
          )
        ],
      ),
      child: TextField(
        onChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          hintText: "Search for patient",
          hintStyle: TextStyles.body.subTitleColor,
          suffixIcon: SizedBox(
              width: 50,
              child: Icon(Icons.search, color: Theme.of(context).primaryColor)
                  .alignCenter
                  .ripple(() {}, borderRadius: BorderRadius.circular(13))),
        ),
      ),
    );
  }

  Widget _upcomingAppointments() {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Upcoming Appointments", style: TextStyles.title.bold),
              Text(
                "See All",
                style: TextStyles.titleNormal,
              ).p(8).ripple(() {})
            ],
          ),
        ),
        SizedBox(
          height: AppTheme.fullHeight(context) * .28,
          width: AppTheme.fullWidth(context),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _appointmentsCard("Patient A", "Nov 23, 10:00am - 10:30am",
                  color: LightColor.green, lightColor: LightColor.lightGreen),
              _appointmentsCard("Patient B", "Nov 23, 11:00am - 11:30am",
                  color: LightColor.skyBlue, lightColor: LightColor.lightBlue),
              _appointmentsCard("Patient C", "Nov 23, 12:00am - 12:30pm",
                  color: LightColor.orange, lightColor: LightColor.lightOrange),
              _appointmentsCard("Patient D", "Nov 23, 01:00pm - 01:30pm",
                  color: LightColor.green, lightColor: LightColor.lightGreen),
              _appointmentsCard("Patient E", "Nov 23, 02:00pm - 02:30pm",
                  color: LightColor.skyBlue, lightColor: LightColor.lightBlue)
            ],
          ),
        ),
      ],
    );
  }

  Widget _appointmentsCard(String title, String subtitle,
      {required Color color, required Color lightColor}) {
    TextStyle titleStyle = TextStyles.title.bold.white;
    TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 392) {
      titleStyle = TextStyles.body.bold.white;
      subtitleStyle = TextStyles.bodySm.bold.white;
    }
    return AspectRatio(
      aspectRatio: 6 / 8,
      child: Container(
        height: 280,
        width: AppTheme.fullWidth(context) * .3,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: const Offset(4, 4),
              blurRadius: 10,
              color: lightColor.withOpacity(.8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -20,
                left: -20,
                child: CircleAvatar(
                  backgroundColor: lightColor,
                  radius: 60,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    child: Text(title, style: titleStyle).hP8,
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: Text(
                      subtitle,
                      style: subtitleStyle,
                    ).hP8,
                  ),
                ],
              ).p16
            ],
          ),
        ).ripple(() {},
            borderRadius: const BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Widget _patientsList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("My Patients", style: TextStyles.title.bold),
              // .p(12).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
              DropdownButton<String>(
                value: selectedSortOrder,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedSortOrder = newValue;
                      _sortPatients();
                    });
                  }
                },
                items:
                    <String>['Sort by', 'A to Z', 'Z to A'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ).hP16,
          _getPatientWidgetList()
        ],
      ),
    );
  }

  Widget _getPatientWidgetList() {
    final filteredDoctors = patientList.where((patient) =>
        patient.fname.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        patient.lname.toLowerCase().contains(_searchQuery.toLowerCase()));

    return Column(
      children: filteredDoctors.map((x) {
        return _patientTile(x);
      }).toList(),
    );
  }

  void _sortPatients() {
    setState(() {
      if (selectedSortOrder == 'A to Z') {
        patientList.sort((a, b) => a.fname.compareTo(b.fname));
      } else {
        patientList.sort((a, b) => b.fname.compareTo(a.fname));
      }
    });
  }

  Widget _patientTile(ChatUser patient) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(4, 4),
            blurRadius: 10,
            color: LightColor.grey.withOpacity(.2),
          ),
          BoxShadow(
            offset: const Offset(-3, 0),
            blurRadius: 15,
            color: LightColor.grey.withOpacity(.1),
          )
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).primaryColorLight,
              ),
              child: Image.asset(
                patient.photoUri!,
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: Text("${patient.fname} ${patient.lname}",
              style: TextStyles.title.bold),
          subtitle: Text(
            "Sex - ${patient.sex}",
            style: TextStyles.bodySm.subTitleColor.bold,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ).ripple(() {
        Navigator.pushNamed(context, "/DetailPage", arguments: patient);
      }, borderRadius: const BorderRadius.all(Radius.circular(20))),
    );
  }

  Widget _bottomNavigationBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add),
            label: 'Prescriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        elevation: Theme.of(context).bottomNavigationBarTheme.elevation,
        onTap: _onItemTapped,
      ),
    );
  }

  _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 600),
          curve: Curves.fastEaseInToSlowEaseOut);
      // if (index == 1) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => DoctorPrescriptionsPage(user: widget.user),
      //     ),
      //   );
      // }
    });
  }

  Future<bool> _exitApp() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            content: const Text('Would you like to sign-out before you leave?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async => await FirebaseAuth.instance
                    .signOut()
                    .whenComplete(() => Navigator.of(context).pop(true)),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _selectedIndex == 0
            ? _exitApp
            : () async {
                setState(() {
                  _selectedIndex = 0;
                  pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut);
                });
                return false;
              },
        child: Scaffold(
          appBar: _selectedIndex == 0 ? _appBar(context) : null,
          backgroundColor: Theme.of(context).colorScheme.background,
          body: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _header(),
                        _searchField(),
                        _upcomingAppointments(),
                      ],
                    ),
                  ),
                  _patientsList()
                ],
              ),
              DoctorPrescriptionsPage(user: widget.user)
            ],
          ),
          bottomNavigationBar: _bottomNavigationBar(),
        ));
  }
}
