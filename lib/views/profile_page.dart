// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// import 'package:firebase_ui_auth/src/screens/profile_screen.dart';
// import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';

// import '../models/user_data.dart';
// import '../views/auth_gate.dart';
// import '../views/theme_provider.dart';
// import '../controllers/profile_page_service.dart';

// class ProfilePage extends StatefulWidget {
//   UserData? currUser;
//   ProfilePage({Key? key, this.currUser}) : super(key: key);
//   @override
//   State<ProfilePage> createState() => ProfilePageState();
// }

// class ProfilePageState extends State<ProfilePage> {
//   var auth = FirebaseAuth.instance;
//   var providers = AuthGate().providers;
//   User? user = FirebaseAuth.instance.currentUser;
//   ThemeProvider themeProvider = ThemeProvider();
//   final _formKey = GlobalKey<FormState>();
//   final _userDataService = UserDataService();
//   final ImagePicker picker = ImagePicker();
//   String fname = '';
//   String lname = '';
//   DateTime? dob = DateTime(DateTime.now().year, DateTime.now().month,
//       DateTime.now().day); //need change
//   String sex = 'Male';
//   String addr_line1 = '';
//   String addr_line2 = '';
//   String post = '';
//   String city = '';
//   String? country = 'CA';
//   String? province = 'Newfoundland\nand Labrador';
//   String hairCol = '';
//   String bloodType = '';
//   String eyeCol = '';
//   String skinTone = '';
//   String email = '';
//   String phone_primary = '';
//   String phone_secondary = '';
//   String? photoUri = '';
//   XFile? selectedImage;
//   bool is_doctor = false;
//   bool editProfile = false;
//   bool editProfilePic = false;
//   List<String> genders = ['Male', 'Female'];
//   List<String> bloodTypes = [
//     '',
//     'A+',
//     'A-',
//     'B+',
//     'B-',
//     'AB+',
//     'AB-',
//     'O+',
//     'O-'
//   ];
//   List<String> country_lst = ['USA', 'CA'];
//   List<String> can_lst = [
//     'Ontario',
//     'Quebec',
//     'Nova Scotia',
//     'New Brunswick',
//     'Manitoba',
//     'British Columbia',
//     'Prince Edward\nIsland',
//     'Saskatchewan',
//     'Alberta',
//     'Newfoundland\nand Labrador'
//   ];
//   List<String> usa_lst = [
//     'Alabama',
//     'Alaska',
//     'Arizona',
//     'Arkansas',
//     'California',
//     'Colorado',
//     'Connecticut',
//     'Delaware',
//     'Florida',
//     'Georgia',
//     'Hawaii',
//     'Idaho',
//     'Illinois',
//     'Indiana',
//     'Iowa',
//     'Kansas',
//     'Kentucky',
//     'Lousiana',
//     'Maine',
//     'Maryland',
//     'Massachusetts',
//     'Michigan',
//     'Minnesota',
//     'Mississippi',
//     'Missouri',
//     'Montana',
//     'Nebraska',
//     'Nevada',
//     'New Hampshire',
//     'New Jersey',
//     'New Mexico',
//     'New York',
//     'North Carolina',
//     'North Dakota',
//     'Ohio',
//     'Oklahoma',
//     'Oregon',
//     'Pennsylvania',
//     'Rhode Island',
//     'South Carolina',
//     'South Dakota',
//     'Tennessee',
//     'Texas',
//     'Utah',
//     'Vermont',
//     'Virginia',
//     'Washington',
//     'West Virginia',
//     'Wisconsin',
//     'Wyoming'
//   ];

//   Future<bool> _reauthenticate(BuildContext context) {
//     // final l = FirebaseUILocalizations.labelsOf(context);
//     return showReauthenticateDialog(
//       context: context,
//       providers: providers,
//       auth: auth,
//       onSignedIn: () {
//         user!.delete();
//         Navigator.of(context).pop();
//       },
//       // actionButtonLabelOverride: l.deleteAccount,
//       actionButtonLabelOverride: 'Delete Account',
//     );
//   }

//   Future<void> selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: dob!,
//       firstDate: DateTime(1940),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != dob) {
//       setState(() {
//         dob = picked;
//       });
//     }
//   }

//   Future<void> pickImageFromGallery() async {
//     final XFile? chosen = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       selectedImage = chosen;
//     });
//     print(selectedImage);
//   }

//   Future<void> pickImageFromCamera() async {
//     final XFile? chosen = await picker.pickImage(source: ImageSource.camera);
//     setState(() {
//       selectedImage = chosen;
//     });
//   }

//   static void preload(BuildContext context, String? path) {
//     final configuration = createLocalImageConfiguration(context);
//     NetworkImage(path!).resolve(configuration);
//   }

//   Future<void> saveCurrUser() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//     }
//     // widget.currUser ??= UserData(id: user!.uid, email: user!.email!);
//     widget.currUser?.fname = fname.isNotEmpty ? fname : '';
//     widget.currUser?.lname = lname.isNotEmpty ? lname : 'Guest';
//     widget.currUser?.dob = dob;
//     widget.currUser?.sex = sex;
//     widget.currUser?.addr = '$addr_line1, $addr_line2';
//     widget.currUser?.post = post;
//     widget.currUser?.city = city;
//     widget.currUser?.province = province!;
//     widget.currUser?.hairCol = hairCol;
//     widget.currUser?.eyeCol = eyeCol;
//     widget.currUser?.bloodType = bloodType;
//     widget.currUser?.skinTone = skinTone;
//     widget.currUser?.phone =
//         phone_primary.isNotEmpty ? phone_primary : phone_secondary;
//     widget.currUser?.photoUri = photoUri;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (user!.photoURL != null) {
//       preload(context, user!.photoURL);
//     }
//     widget.currUser ??= UserData(id: user!.uid, email: user!.email!);
//     return Scaffold(
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           children: <Widget>[
//             Container(
//               height: 225,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color.fromARGB(255, 255, 171, 175),
//                     Color.fromARGB(255, 251, 145, 145)
//                   ],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                   stops: [0.5, 0.9],
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: <Widget>[
//                       CircleAvatar(
//                         backgroundColor: Colors.white70,
//                         minRadius: 60.0,
//                         child: CircleAvatar(
//                           radius: 50,
//                           backgroundImage: user!.photoURL == null
//                               ? AssetImage('assets/person-icon.png')
//                               : NetworkImage(user!.photoURL!) as ImageProvider,
//                           child: Visibility(
//                             visible: editProfile,
//                             child: Stack(children: [
//                               Align(
//                                   alignment: Alignment(1.5, 1.2),
//                                   child: CircleAvatar(
//                                     radius: 17,
//                                     backgroundColor:
//                                         Color.fromARGB(255, 254, 166, 169),
//                                     child: CircleAvatar(
//                                       radius: 13,
//                                       backgroundColor: Colors.white70,
//                                       child: IconButton(
//                                         padding: EdgeInsets.only(left: 2),
//                                         iconSize: 22,
//                                         icon: const Icon(Icons.edit),
//                                         color: Colors.blueGrey,
//                                         onPressed:
//                                             () {}, //need to implement image picker soon
//                                       ),
//                                     ),
//                                   ))
//                             ]),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Stack(
//                     children: [
//                       Center(
//                         child: Text(
//                           user?.displayName ??
//                               '${widget.currUser?.fname ?? ''} ${widget.currUser?.lname ?? 'Guest'}',
//                           style: const TextStyle(
//                             fontSize: 35,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: AlignmentDirectional.bottomEnd,
//                         heightFactor: 2,
//                         child: Container(
//                           height: 40,
//                           width: 120,
//                           padding: const EdgeInsets.only(right: 10),
//                           child: FloatingActionButton.extended(
//                               foregroundColor: editProfile
//                                   ? Colors.cyan.shade400
//                                   : Colors.white,
//                               backgroundColor: Color.fromARGB(110, 95, 87, 108),
//                               onPressed: () {
//                                 if (editProfile == false) {
//                                   saveCurrUser();
//                                 }
//                                 setState(() {
//                                   editProfile = !editProfile;
//                                 });
//                               },
//                               icon: const Icon(Icons.edit_note_rounded),
//                               label: const Text(
//                                 'Edit Profile',
//                                 style: TextStyle(
//                                     fontSize: 12, fontWeight: FontWeight.w600),
//                               )),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             Column(
//               children: [
//                 ListTile(
//                   title: const Padding(
//                     padding: EdgeInsets.only(bottom: 10),
//                     child: Text(
//                       'Email',
//                       style: TextStyle(
//                         color: Colors.deepOrange,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   subtitle: Padding(
//                     padding: EdgeInsets.only(left: 10),
//                     child: Text(
//                       user!.email!,
//                       style: const TextStyle(
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Divider(),
//                 ListTile(
//                     title: const Text(
//                       'Phone',
//                       style: TextStyle(
//                         color: Colors.deepOrange,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: Row(
//                       children: [
//                         Container(
//                           width: 85,
//                           child: IgnorePointer(
//                             ignoring: !editProfile,
//                             child: DropdownButtonHideUnderline(
//                                 child: ButtonTheme(
//                               alignedDropdown: true,
//                               layoutBehavior:
//                                   ButtonBarLayoutBehavior.constrained,
//                               child: DropdownButtonFormField<String>(
//                                 isDense: true,
//                                 menuMaxHeight: 115,
//                                 alignment: AlignmentDirectional.centerStart,
//                                 padding: EdgeInsets.only(top: 10, left: 10),
//                                 borderRadius: BorderRadius.circular(10),
//                                 focusColor: Colors.transparent,
//                                 decoration: const InputDecoration(
//                                     contentPadding: EdgeInsets.zero,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors.transparent)),
//                                     labelText: 'Country'),
//                                 value: country,
//                                 items: country_lst
//                                     .map((label) => DropdownMenuItem(
//                                           alignment:
//                                               AlignmentDirectional.center,
//                                           child: Text(label),
//                                           value: label,
//                                         ))
//                                     .toList(),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     country = value!;
//                                     province = country == 'CA'
//                                         ? 'Newfoundland\nand Labrador'
//                                         : 'New York';
//                                   });
//                                 },
//                               ),
//                             )),
//                           ),
//                         ),
//                         SizedBox(width: 25),
//                         Container(
//                             width: 125,
//                             child: TextFormField(
//                               enabled: editProfile,
//                               keyboardType: TextInputType.number,
//                               maxLength: 10,
//                               style: TextStyle(fontSize: 18),
//                               decoration: const InputDecoration(
//                                   prefixText: '+1',
//                                   hintText: 'xxx-xxxxxxx',
//                                   labelText: 'Primary',
//                                   counterText: ''),
//                               inputFormatters: <TextInputFormatter>[
//                                 FilteringTextInputFormatter.allow(
//                                     RegExp(r'[0-9]')),
//                                 FilteringTextInputFormatter.digitsOnly
//                               ],
//                               validator: ((value) {
//                                 if (value!.length > 0 && value!.length < 10) {
//                                   return 'Enter valid phone number';
//                                 }
//                                 return null;
//                               }),
//                               onSaved: (value) {
//                                 // setState(() {
//                                 phone_primary = value!;
//                                 // });
//                               },
//                             )),
//                         SizedBox(width: 60),
//                         Container(
//                             width: 125,
//                             child: TextFormField(
//                               enabled: editProfile,
//                               keyboardType: TextInputType.number,
//                               maxLength: 10,
//                               style: TextStyle(fontSize: 18),
//                               decoration: const InputDecoration(
//                                   prefixText: '+1',
//                                   hintText: 'xxx-xxxxxxx',
//                                   labelText: 'Secondary',
//                                   counterText: ''),
//                               inputFormatters: <TextInputFormatter>[
//                                 FilteringTextInputFormatter.allow(
//                                     RegExp(r'[0-9]')),
//                                 FilteringTextInputFormatter.digitsOnly
//                               ],
//                               validator: ((value) {
//                                 if (value!.length > 0 && value!.length < 10) {
//                                   return 'Enter valid phone number';
//                                 }
//                                 return null;
//                               }),
//                               onSaved: (value) {
//                                 setState(() {
//                                   phone_secondary = value!;
//                                 });
//                               },
//                             )),
//                       ],
//                     )),
//                 Divider(),
//                 ListTile(
//                   title: const Text(
//                     'Address',
//                     style: TextStyle(
//                       color: Colors.deepOrange,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                           width: 360,
//                           padding: EdgeInsets.only(left: 10),
//                           child: TextFormField(
//                             enabled: editProfile,
//                             keyboardType: TextInputType.text,
//                             textCapitalization: TextCapitalization.words,
//                             maxLength: 50,
//                             style: TextStyle(fontSize: 18),
//                             decoration: const InputDecoration(
//                                 labelText: 'Address line 1', counterText: ''),
//                             onSaved: (value) {
//                               setState(() {
//                                 addr_line1 = value!;
//                               });
//                             },
//                           )),
//                       Container(
//                           width: 360,
//                           padding: EdgeInsets.only(left: 10),
//                           child: TextFormField(
//                             enabled: editProfile,
//                             keyboardType: TextInputType.text,
//                             textCapitalization: TextCapitalization.words,
//                             maxLength: 50,
//                             style: TextStyle(fontSize: 18),
//                             decoration: const InputDecoration(
//                                 labelText: 'Address line 2', counterText: ''),
//                             onSaved: (value) {
//                               setState(() {
//                                 addr_line2 = value!;
//                               });
//                             },
//                           )),
//                       const SizedBox(height: 5),
//                       Row(
//                         children: [
//                           Container(
//                               width: 150,
//                               padding: EdgeInsets.only(left: 10),
//                               child: TextFormField(
//                                 enabled: editProfile,
//                                 keyboardType: TextInputType.text,
//                                 textCapitalization: TextCapitalization.words,
//                                 maxLength: 30,
//                                 style: TextStyle(fontSize: 18),
//                                 decoration: const InputDecoration(
//                                     labelText: 'City', counterText: ''),
//                                 inputFormatters: <TextInputFormatter>[
//                                   FilteringTextInputFormatter.allow(
//                                       RegExp(r'[a-zA-Z ]')),
//                                 ],
//                                 onSaved: (value) {
//                                   setState(() {
//                                     city = value!;
//                                   });
//                                 },
//                               )),
//                           Container(
//                               width: 140,
//                               padding: EdgeInsets.only(left: 30),
//                               child: TextFormField(
//                                 enabled: editProfile,
//                                 keyboardType: TextInputType.text,
//                                 maxLength: 6,
//                                 textCapitalization:
//                                     TextCapitalization.characters,
//                                 style: TextStyle(fontSize: 18),
//                                 decoration: const InputDecoration(
//                                     labelText: 'Postal Code', counterText: ''),
//                                 inputFormatters: <TextInputFormatter>[
//                                   FilteringTextInputFormatter.allow(
//                                       RegExp(r'[A-Z0-9 ]')),
//                                 ],
//                                 onSaved: (value) {
//                                   setState(() {
//                                     post = value!;
//                                   });
//                                 },
//                               )),
//                           Container(
//                             width: 174,
//                             child: IgnorePointer(
//                               ignoring: !editProfile,
//                               child: DropdownButtonHideUnderline(
//                                   child: ButtonTheme(
//                                 alignedDropdown: true,
//                                 layoutBehavior:
//                                     ButtonBarLayoutBehavior.constrained,
//                                 child: DropdownButtonFormField<String>(
//                                   isDense: false,
//                                   menuMaxHeight: 150,
//                                   alignment: AlignmentDirectional.centerStart,
//                                   padding: EdgeInsets.only(top: 10, left: 12),
//                                   borderRadius: BorderRadius.circular(10),
//                                   focusColor: Colors.transparent,
//                                   decoration: const InputDecoration(
//                                       contentPadding: EdgeInsets.zero,
//                                       focusedBorder: InputBorder.none,
//                                       enabledBorder: UnderlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: Colors.transparent)),
//                                       labelText: '     Province'),
//                                   value: province,
//                                   items: (country == 'CA' ? can_lst : usa_lst)
//                                       .map((label) => DropdownMenuItem(
//                                             alignment:
//                                                 AlignmentDirectional.center,
//                                             child: Text(label),
//                                             value: label,
//                                           ))
//                                       .toList(),
//                                   onChanged: (value) {
//                                     setState(() => province = value!);
//                                   },
//                                 ),
//                               )),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(),
//                 ListTile(
//                   title: const Text(
//                     'Personal',
//                     style: TextStyle(
//                       color: Colors.deepOrange,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: Column(
//                     children: [
//                       if (user?.providerData[0].providerId == 'password') ...[
//                         Row(
//                           children: [
//                             Container(
//                                 width: 200,
//                                 padding: EdgeInsets.only(left: 10),
//                                 child: TextFormField(
//                                   enabled: editProfile,
//                                   keyboardType: TextInputType.text,
//                                   textCapitalization: TextCapitalization.words,
//                                   maxLength: 30,
//                                   style: TextStyle(fontSize: 18),
//                                   decoration: const InputDecoration(
//                                       labelText: 'First Name', counterText: ''),
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.allow(
//                                         RegExp(r'[a-zA-Z ]')),
//                                   ],
//                                   onSaved: (value) {
//                                     setState(() {
//                                       fname = value!;
//                                     });
//                                   },
//                                 )),
//                             Container(
//                                 width: 200,
//                                 padding: EdgeInsets.only(left: 15),
//                                 child: TextFormField(
//                                   enabled: editProfile,
//                                   keyboardType: TextInputType.text,
//                                   textCapitalization: TextCapitalization.words,
//                                   maxLength: 30,
//                                   style: TextStyle(fontSize: 18),
//                                   decoration: const InputDecoration(
//                                       labelText: 'Last Name', counterText: ''),
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.allow(
//                                         RegExp(r'[a-zA-Z ]')),
//                                   ],
//                                   onSaved: (value) {
//                                     setState(() {
//                                       lname = value!;
//                                     });
//                                   },
//                                 )),
//                           ],
//                         ),
//                         const SizedBox(height: 5)
//                       ] else ...[
//                         const SizedBox(height: 3)
//                       ],
//                       if (!widget.currUser!.isDoctor) ...[
//                         Row(
//                           children: [
//                             Container(
//                               width: 100,
//                               padding: EdgeInsets.only(left: 10),
//                               child: IgnorePointer(
//                                 ignoring: !editProfile,
//                                 child: InputDatePickerFormField(
//                                   initialDate: dob,
//                                   firstDate: DateTime(1940),
//                                   lastDate: DateTime.now(),
//                                   fieldLabelText: 'Date of Birth',
//                                   keyboardType: TextInputType.datetime,
//                                   acceptEmptyDate: true,
//                                   onDateSubmitted: (value) {
//                                     setState(() {
//                                       dob = value;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 5),
//                             IgnorePointer(
//                               ignoring: !editProfile,
//                               child: IconButton(
//                                 hoverColor: Colors.transparent,
//                                 disabledColor: Colors.blue,
//                                 padding: EdgeInsets.only(top: 20),
//                                 icon: const Icon(Icons.calendar_month),
//                                 onPressed: () => selectDate(context),
//                               ),
//                             ),
//                             const SizedBox(width: 45),
//                             Container(
//                               width: 100,
//                               child: IgnorePointer(
//                                 ignoring: !editProfile,
//                                 child: DropdownButtonHideUnderline(
//                                     child: ButtonTheme(
//                                   alignedDropdown: true,
//                                   layoutBehavior:
//                                       ButtonBarLayoutBehavior.constrained,
//                                   child: DropdownButtonFormField<String>(
//                                     isDense: true,
//                                     menuMaxHeight: 115,
//                                     alignment: AlignmentDirectional.centerStart,
//                                     padding: EdgeInsets.only(top: 10),
//                                     borderRadius: BorderRadius.circular(10),
//                                     focusColor: Colors.transparent,
//                                     decoration: const InputDecoration(
//                                         contentPadding: EdgeInsets.zero,
//                                         focusedBorder: InputBorder.none,
//                                         enabledBorder: UnderlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.transparent)),
//                                         labelText: 'Sex'),
//                                     value: sex,
//                                     items: genders
//                                         .map((label) => DropdownMenuItem(
//                                               alignment:
//                                                   AlignmentDirectional.center,
//                                               child: Text(label),
//                                               value: label,
//                                             ))
//                                         .toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         sex = value!;
//                                       });
//                                     },
//                                   ),
//                                 )),
//                               ),
//                             ),
//                             const SizedBox(width: 35),
//                             Container(
//                               width: 80,
//                               child: IgnorePointer(
//                                 ignoring: !editProfile,
//                                 child: DropdownButtonHideUnderline(
//                                     child: ButtonTheme(
//                                   alignedDropdown: true,
//                                   layoutBehavior:
//                                       ButtonBarLayoutBehavior.constrained,
//                                   child: DropdownButtonFormField<String>(
//                                     isDense: true,
//                                     menuMaxHeight: 115,
//                                     alignment: AlignmentDirectional.centerStart,
//                                     padding: EdgeInsets.only(top: 10),
//                                     borderRadius: BorderRadius.circular(10),
//                                     focusColor: Colors.transparent,
//                                     decoration: const InputDecoration(
//                                         contentPadding: EdgeInsets.zero,
//                                         focusedBorder: InputBorder.none,
//                                         enabledBorder: UnderlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.transparent)),
//                                         labelText: 'Blood Type'),
//                                     value: bloodType,
//                                     items: bloodTypes
//                                         .map((label) => DropdownMenuItem(
//                                               alignment:
//                                                   AlignmentDirectional.center,
//                                               child: Text(label),
//                                               value: label,
//                                             ))
//                                         .toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         bloodType = value!;
//                                       });
//                                     },
//                                   ),
//                                 )),
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                       const SizedBox(height: 15),
//                       if (!widget.currUser!.isDoctor) ...[
//                         Row(
//                           children: [
//                             Container(
//                                 width: 150,
//                                 padding: EdgeInsets.only(left: 10),
//                                 child: TextFormField(
//                                   enabled: editProfile,
//                                   keyboardType: TextInputType.text,
//                                   textCapitalization: TextCapitalization.none,
//                                   maxLength: 30,
//                                   style: TextStyle(fontSize: 18),
//                                   decoration: const InputDecoration(
//                                       labelText: 'Hair Color', counterText: ''),
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.allow(
//                                         RegExp(r'[a-zA-Z ]')),
//                                   ],
//                                   onSaved: (value) {
//                                     setState(() {
//                                       hairCol = value!;
//                                     });
//                                   },
//                                 )),
//                             Container(
//                                 width: 150,
//                                 padding: EdgeInsets.only(left: 10),
//                                 child: TextFormField(
//                                   enabled: editProfile,
//                                   keyboardType: TextInputType.text,
//                                   textCapitalization: TextCapitalization.none,
//                                   maxLength: 30,
//                                   style: TextStyle(fontSize: 18),
//                                   decoration: const InputDecoration(
//                                       labelText: 'Eye Color', counterText: ''),
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.allow(
//                                         RegExp(r'[a-zA-Z ]')),
//                                   ],
//                                   onSaved: (value) {
//                                     setState(() {
//                                       eyeCol = value!;
//                                     });
//                                   },
//                                 )),
//                             Container(
//                                 width: 150,
//                                 padding: EdgeInsets.only(left: 10),
//                                 child: TextFormField(
//                                   enabled: editProfile,
//                                   keyboardType: TextInputType.text,
//                                   textCapitalization: TextCapitalization.none,
//                                   maxLength: 30,
//                                   style: TextStyle(fontSize: 18),
//                                   decoration: const InputDecoration(
//                                       labelText: 'Skin Tone', counterText: ''),
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.allow(
//                                         RegExp(r'[a-zA-Z ]')),
//                                   ],
//                                   onSaved: (value) {
//                                     setState(() {
//                                       skinTone = value!;
//                                     });
//                                   },
//                                 )),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 55),
//                 SizedBox(
//                   width: 180,
//                   height: 45,
//                   child: InkWell(
//                     splashColor: const Color.fromARGB(255, 176, 220, 240),
//                     hoverColor: Colors.blueGrey.withOpacity(0.1),
//                     highlightColor: Colors.blueGrey,
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.logout,
//                           size: 40,
//                           color: Color.fromARGB(255, 111, 198, 239),
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           'Sign out',
//                           style: TextStyle(
//                               color: Color.fromARGB(255, 111, 198, 239),
//                               fontSize: 25,
//                               fontWeight: FontWeight.w800),
//                         ),
//                       ],
//                     ),
//                     onTap: () => FirebaseUIAuth.signOut(
//                       context: context,
//                       auth: auth,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 DeleteAccountButton(
//                   auth: auth,
//                   onSignInRequired: () {
//                     return _reauthenticate(context);
//                   },
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
