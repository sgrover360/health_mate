import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_mate/components/extensions.dart';
import 'package:health_mate/views/user_prescriptions_page.dart';
import 'package:health_mate/models/chat_user.dart';
import 'package:health_mate/pages/chat_overview/chat_overview_page.dart';
import 'package:health_mate/views/profile_page.dart';
import 'package:health_mate/views/theme_provider.dart';
import 'package:provider/provider.dart';

import '../components/light_color.dart';
import '../components/text_styles.dart';
import '../components/theme.dart';
import '../models/data.dart';
import '../models/doctor.dart';

class HomePage extends StatefulWidget {
  //final User? user = FirebaseAuth.instance.currentUser;
  final ChatUser user;

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

enum SearchFilter { names, rating, location }

class _HomePageState extends State<HomePage> {
  //final User? user = FirebaseAuth.instance.currentUser;
  //final ChatUser user;
  late List<Doctor> doctorDataList;
  int _selectedIndex = 0;
  String _searchQuery = "";
  SearchFilter _searchFilter = SearchFilter.names;
  List<Doctor> doctorList = [];
  String selectedSortOrder = 'Sort by';

  @override
  void initState() {
    doctorDataList = doctorMapList.map((x) => Doctor.fromJson(x)).toList();
    doctorList = [...doctorDataList];
    _sortDoctors();
    super.initState();
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text("Health Mate"),
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
            // Navigator.pushNamed(context, '/profile');
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(currUser: widget.user)));
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
            Text("Shivam Grover", style: TextStyles.h1Style),
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
      child: Row(
        children: <Widget>[
          DropdownButton<SearchFilter>(
            value: _searchFilter,
            onChanged: (SearchFilter? newValue) {
              if (newValue != null) {
                setState(() {
                  _searchFilter = newValue;
                });
              }
            },
            items: SearchFilter.values.map((filter) {
              return DropdownMenuItem<SearchFilter>(
                value: filter,
                child: Text(filterToString(
                    filter)), // Helper function to convert enum to string
              );
            }).toList(),
          ),
          Expanded(
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
                hintText: "Search for doctor",
                hintStyle: TextStyles.body.subTitleColor,
                suffixIcon: SizedBox(
                  width: 50,
                  child: Icon(Icons.search,
                          color: Theme.of(context).primaryColor)
                      .alignCenter
                      .ripple(() {}, borderRadius: BorderRadius.circular(13)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String filterToString(SearchFilter filter) {
    switch (filter) {
      case SearchFilter.names:
        return "Name";
      case SearchFilter.rating:
        return "Rating";
      case SearchFilter.location:
        return "Location";
      default:
        return "";
    }
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
              _appointmentsCard("Doctor A", "Cardiologist",
                  color: LightColor.green, lightColor: LightColor.lightGreen),
              _appointmentsCard("Doctor B", "Psychiatrist",
                  color: LightColor.skyBlue, lightColor: LightColor.lightBlue),
              _appointmentsCard("Doctor C", "Urologist",
                  color: LightColor.orange, lightColor: LightColor.lightOrange),
              _appointmentsCard("Doctor D", "Dermatologist",
                  color: LightColor.green, lightColor: LightColor.lightGreen),
              _appointmentsCard("Doctor E", "Dentist",
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

  Widget _doctorsList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Top Doctors", style: TextStyles.title.bold),
              DropdownButton<String>(
                value: selectedSortOrder,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedSortOrder = newValue;
                      _sortDoctors();
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
          _getDoctorWidgetList()
        ],
      ),
    );
  }

  Widget _getDoctorWidgetList() {
    final filteredDoctors = doctorList.where((doctor) {
      switch (_searchFilter) {
        case SearchFilter.rating:
          return doctor.rating.toString().contains(_searchQuery.toLowerCase());
        case SearchFilter.names:
          return doctor.firstName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              doctor.lastName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
        case SearchFilter.location:
          return doctor.location
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

        default:
          return false;
      }
    });

    return Column(
      children: filteredDoctors.map((x) {
        return _doctorTile(x);
      }).toList(),
    );
  }

  void _sortDoctors() {
    setState(() {
      if (selectedSortOrder == 'A to Z') {
        doctorList.sort((a, b) => a.firstName.compareTo(b.firstName));
      } else {
        doctorList.sort((a, b) => b.firstName.compareTo(a.firstName));
      }
    });
  }

  Widget _doctorTile(Doctor doctor) {
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
                doctor.image,
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: Text("Dr. ${doctor.firstName} ${doctor.lastName}",
              style: TextStyles.title.bold),
          subtitle: Text(
            doctor.type,
            style: TextStyles.bodySm.subTitleColor.bold,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ).ripple(() {
        Navigator.pushNamed(context, "/DetailPage", arguments: doctor);
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
        selectedItemColor: Colors.white, // Changed to a contrasting color
        unselectedItemColor: Colors.grey, // Added for unselected items
        elevation: Theme.of(context).bottomNavigationBarTheme.elevation,
        onTap: _onItemTapped,
      ),
    );
  }

  _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;

      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserPrescriptionsPage(),
          ),
        );
      }
      if (index == 2) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatOverviewPage(widget.user)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
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
          _doctorsList()
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}
