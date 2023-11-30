import 'package:flutter/material.dart';
import 'package:health_mate/components/extensions.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../components/light_color.dart';
import '../components/text_styles.dart';
import '../models/chat_user.dart';
import '../models/prescription.dart';
import '../models/prescription_data.dart';
import 'create_prescription.dart';
import 'doctor_home_page.dart';

class DoctorPrescriptionsPage extends StatefulWidget {
  final ChatUser user;

  const DoctorPrescriptionsPage({Key? key, required this.user}) : super(key: key);

  @override
  DoctorPrescriptionsPageState createState() => DoctorPrescriptionsPageState();
}

class DoctorPrescriptionsPageState extends State<DoctorPrescriptionsPage> {
  late final String? userFirstName;

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the page where the doctor can create a new prescription
          // Navigator.pushNamed(context, '/createPrescription');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreatePrescription(user: widget.user)));
        },
        child: const Icon(Icons.add),
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
    return Column(
        children: prescriptions.map((x) {
          return _prescriptionTile(x);
        }).toList());
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
                prescription.userImage,
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
              Text("Prescribed to:   ${prescription.userFirstName} ${prescription.userLastName}"),
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
          MaterialPageRoute(builder: (context) => PdfViewerPage(pdfUrl: prescription.prescriptionPdfUrl,)),
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
        title: const Text('PDF Viewer'),
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl,
        controller: _pdfViewerController,
      ),
    );
  }
}