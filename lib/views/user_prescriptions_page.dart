import 'package:flutter/material.dart';
import 'package:health_mate/components/extensions.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../components/light_color.dart';
import '../components/text_styles.dart';
import '../models/data.dart';
import '../models/prescription.dart';

class UserPrescriptionsPage extends StatefulWidget {
  const UserPrescriptionsPage({super.key});

  @override
  UserPrescriptionsPageState createState() => UserPrescriptionsPageState();
}

class UserPrescriptionsPageState extends State<UserPrescriptionsPage> {
  late final String? userFirstName;
  String _searchQuery = "";

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
          hintText: "Search for prescription",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescriptions'),
        automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _searchField(),
              ],
            ),
          ),
          _prescriptionsList(),
        ],
      ),
    );
  }

  Widget _prescriptionsList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Text("Prescriptions", style: TextStyles.title.bold),
          //     IconButton(
          //         icon: Icon(
          //           Icons.sort,
          //           color: Theme.of(context).primaryColor,
          //         ),
          //         onPressed: () {})
          //     .p(12).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
          //   ],
          // ).hP16,
          _getPrescriptionsWidgetList()
        ],
      ),
    );
  }

  Widget _getPrescriptionsWidgetList() {
    final filteredPrescriptions = prescriptions.where((prescription) {
      return prescription.medicineName
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    print(
        "Filtered Prescriptions: $filteredPrescriptions"); // Add this line to check the filtered list

    return Column(
      children: filteredPrescriptions.map((x) {
        return _prescriptionTile(x);
      }).toList(),
    );
  }

  Widget _prescriptionTile(Prescription prescription) {
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
                prescription.doctorImage,
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: Text(prescription.medicineName, style: TextStyles.title.bold),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Prescribed by:   Dr. ${prescription.doctorFirstName} ${prescription.doctorLastName}"),
              Text("Prescribed on:   ${prescription.date}"),
            ],
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ).ripple(() {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PdfViewerPage(
                    pdfUrl: prescription.prescriptionPdfUrl,
                  )),
        );
      }, borderRadius: const BorderRadius.all(Radius.circular(20))),
    );
  }
}

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerPage({super.key, required this.pdfUrl});

  @override
  PdfViewerPageState createState() => PdfViewerPageState();
}

class PdfViewerPageState extends State<PdfViewerPage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription'),
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl,
        controller: _pdfViewerController,
      ),
    );
  }
}
