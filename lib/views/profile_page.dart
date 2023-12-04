import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_auth/src/screens/profile_screen.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/services.dart';
import 'package:health_mate/components/extensions.dart';
import 'package:health_mate/views/auth_gate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../views/theme_provider.dart';
import '../controllers/profile_page_service.dart';
import 'package:health_mate/models/chat_user.dart';

class ProfilePage extends StatefulWidget {
  final ChatUser currUser;
  ProfilePage({Key? key, required this.currUser}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ThemeProvider themeProvider = ThemeProvider();
  User? _user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final _userDataService = UserDataService();
  final ImagePicker picker = ImagePicker();
  String fname = '';
  String lname = '';
  DateTime? dob =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String sex = 'Male';
  String addr_line1 = '';
  String addr_line2 = '';
  String post = '';
  String city = '';
  String? country = 'CA';
  String? province = 'Newfoundland\nand Labrador';
  String hairCol = '';
  String bloodType = '';
  String eyeCol = '';
  String skinTone = '';
  String email = '';
  String phone_primary = '';
  String phone_secondary = '';
  String? photoUri = '';
  String? imageLink;
  XFile? selectedImage;
  bool is_doctor = false;
  bool editProfile = false;
  bool editProfilePic = false;
  List<String> genders = ['Male', 'Female'];
  List<String> bloodTypes = [
    '',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  List<String> country_lst = ['USA', 'CA'];
  List<String> can_lst = [
    'Ontario',
    'Quebec',
    'Nova Scotia',
    'New Brunswick',
    'Manitoba',
    'British Columbia',
    'Prince Edward\nIsland',
    'Saskatchewan',
    'Alberta',
    'Newfoundland\nand Labrador'
  ];
  List<String> usa_lst = [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Lousiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming'
  ];

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dob!,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != dob) {
      setState(() {
        dob = picked;
      });
    }
  }

  Future<void> pickImageFromGallery() async {
    final XFile? chosen = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = chosen;
    });
    print(selectedImage);
  }

  Future<void> pickImageFromCamera() async {
    final XFile? chosen = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      selectedImage = chosen;
    });
  }

  static void preload(BuildContext context, String? path) {
    final configuration = createLocalImageConfiguration(context);
    NetworkImage(path!).resolve(configuration);
  }

  Future<void> saveCurrUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    print(widget.currUser);
    print(widget.currUser.id);
    print(widget.currUser.toJson());
    // // Assuming 'user' is a Firebase User and 'widget.currUser' is of type ChatUser
    // widget.currUser ??= ChatUser(
    //   id: _user!.id,
    //   name: _user!.displayName ?? _user!.email!.split('@')[0],
    //   chatIds: [],
    //   email: _user!.email!,
    //   // Initialize other fields with default values
    // );
    //
    // // Update the fields of currUser
    if (selectedImage != null) {
      imageLink = await _userDataService
          .uploadProfilePic(selectedImage); // need to test
    }
    widget.currUser.fname = fname.isNotEmpty ? fname : widget.currUser.fname;
    widget.currUser.lname = lname.isNotEmpty ? lname : widget.currUser.lname;
    widget.currUser.dob = dob ?? widget.currUser.dob;
    widget.currUser.sex = sex.isNotEmpty ? sex : widget.currUser.sex;
    widget.currUser.addr = '$addr_line1, $addr_line2';
    widget.currUser.post = post.isNotEmpty ? post : widget.currUser.post;
    widget.currUser.city = city.isNotEmpty ? city : widget.currUser.city;
    widget.currUser.province = province ?? widget.currUser.province;
    widget.currUser.hairCol =
        hairCol.isNotEmpty ? hairCol : widget.currUser.hairCol;
    widget.currUser.eyeCol =
        eyeCol.isNotEmpty ? eyeCol : widget.currUser.eyeCol;
    widget.currUser.bloodType =
        bloodType.isNotEmpty ? bloodType : widget.currUser.bloodType;
    widget.currUser.skinTone =
        skinTone.isNotEmpty ? skinTone : widget.currUser.skinTone;
    widget.currUser.phone = phone_primary.isNotEmpty
        ? phone_primary
        : (phone_secondary.isNotEmpty
            ? phone_secondary
            : widget.currUser.phone);
    widget.currUser.photoUri =
        imageLink ?? photoUri ?? widget.currUser.photoUri; // nneed to test
    await _userDataService
        .updateProfile(widget.currUser.id!, widget.currUser)
        .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User profile updated'))));
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _user = widget.currUser; // Assuming you pass the current user data here
  // }

  @override
  Widget build(BuildContext context) {
    if (_user!.photoURL != null) {
      preload(context, _user!.photoURL);
    }
    // widget.currUser ??= ChatUser(id: _user!.id, email: _user!.email!);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              height: 225,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple,
                    Color.fromARGB(255, 145, 107, 209),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.5, 0.9],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 60.0,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _user!.photoURL == null
                              ? const AssetImage('assets/person-icon.png')
                              : NetworkImage(_user!.photoURL!) as ImageProvider,
                          child: Visibility(
                            visible: editProfile,
                            child: Stack(children: [
                              Align(
                                  alignment: const Alignment(1.5, 1.2),
                                  child: CircleAvatar(
                                    radius: 17,
                                    backgroundColor:
                                        const Color.fromARGB(255, 117, 74, 193),
                                    child: CircleAvatar(
                                      radius: 13,
                                      backgroundColor: Colors.white70,
                                      child: IconButton(
                                        padding: const EdgeInsets.only(left: 2),
                                        iconSize: 22,
                                        icon: const Icon(Icons.edit),
                                        color: Colors.blueGrey,
                                        onPressed: () {
                                          showModalBottomSheet(
                                              constraints: const BoxConstraints(
                                                  maxHeight: 100),
                                              context: context,
                                              builder: (BuildContext bc) {
                                                return Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        pickImageFromCamera();
                                                      },
                                                      child: const Row(
                                                        children: [
                                                          Text(
                                                            'Take image with Camera',
                                                            style: TextStyle(
                                                                fontSize: 23),
                                                          ),
                                                          SizedBox(
                                                            width: 40,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .camera_alt_outlined,
                                                            size: 40,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        pickImageFromGallery();
                                                      },
                                                      child:
                                                          const Row(children: [
                                                        Text(
                                                          'Pick image from Gallery',
                                                          style: TextStyle(
                                                              fontSize: 23),
                                                        ),
                                                        SizedBox(
                                                          width: 40,
                                                        ),
                                                        Icon(
                                                          Icons.photo,
                                                          size: 40,
                                                        ),
                                                      ]),
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                    ),
                                  ))
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      Center(
                        child: Text(
                          // _user?.displayName ??
                          //     '${widget.currUser?.fname ?? ''} ${widget.currUser?.lname ?? 'Guest'}'
                          widget.currUser.name,
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        heightFactor: 2,
                        child: Container(
                          height: 40,
                          width: 120,
                          padding: const EdgeInsets.only(right: 10),
                          child: FloatingActionButton.extended(
                              foregroundColor: editProfile
                                  ? Colors.cyan.shade400
                                  : Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(110, 95, 87, 108),
                              onPressed: () {
                                setState(() {
                                  editProfile = !editProfile;
                                });
                                if (editProfile == false) {
                                  saveCurrUser();
                                }
                              },
                              icon: const Icon(Icons.edit_note_rounded),
                              label: const Text(
                                'Edit Profile',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                ListTile(
                  title: const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Email',
                      style: TextStyle(
                        color: Color.fromARGB(255, 76, 31, 154),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      _user!.email!,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                    title: const Text(
                      'Phone',
                      style: TextStyle(
                        color: Color.fromARGB(255, 76, 31, 154),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          // width: MediaQuery.of(context).size.width / 4 -
                          //     MediaQuery.of(context).size.width / 40,
                          child: IgnorePointer(
                            ignoring: !editProfile,
                            child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                              alignedDropdown: true,
                              layoutBehavior:
                                  ButtonBarLayoutBehavior.constrained,
                                  child: DropdownButtonFormField<String>(
                                isDense: true,
                                menuMaxHeight: 115,
                                alignment: AlignmentDirectional.centerStart,
                                padding:
                                    const EdgeInsets.only(top: 10, left: 10),
                                borderRadius: BorderRadius.circular(10),
                                focusColor: Colors.transparent,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    labelText: 'Country'),
                                value: country,
                                items: country_lst
                                    .map((label) => DropdownMenuItem(
                                          alignment:
                                              AlignmentDirectional.center,
                                          value: label,
                                          child: Text(label),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    province = (country == 'CA')
                                        ? 'Newfoundland\nand Labrador'
                                        : 'New York';
                                    country = value!;
                                  });
                                },
                              ),
                            )),
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 45),
                        Expanded(
                           // width: 125,
                            child: TextFormField(
                              enabled: editProfile,
                              initialValue: widget.currUser.phone,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                  prefixText: '+1',
                                  hintText: 'xxx-xxxxxxx',
                                  labelText: 'Primary',
                                  counterText: ''),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: ((value) {
                                if (value!.length > 0 && value!.length < 10) {
                                  return 'Enter valid phone number';
                                }
                                return null;
                              }),
                              onSaved: (value) {
                                // setState(() {
                                phone_primary = value!;
                                // });
                              },
                            )),
                        SizedBox(width: MediaQuery.of(context).size.width / 45),
                        // Container(
                        //     width: 125,
                        //     child: TextFormField(
                        //       enabled: editProfile,
                        //       initialValue: widget.currUser.phone,
                        //       keyboardType: TextInputType.number,
                        //       maxLength: 10,
                        //       style: const TextStyle(fontSize: 18),
                        //       decoration: const InputDecoration(
                        //           prefixText: '+1',
                        //           hintText: 'xxx-xxxxxxx',
                        //           labelText: 'Secondary',
                        //           counterText: ''),
                        //       inputFormatters: <TextInputFormatter>[
                        //         FilteringTextInputFormatter.allow(
                        //             RegExp(r'[0-9]')),
                        //         FilteringTextInputFormatter.digitsOnly
                        //       ],
                        //       validator: ((value) {
                        //         if (value!.length > 0 && value!.length < 10) {
                        //           return 'Enter valid phone number';
                        //         }
                        //         return null;
                        //       }),
                        //       onSaved: (value) {
                        //         setState(() {
                        //           phone_secondary = value!;
                        //         });
                        //       },
                        //     )),
                      ],
                    )),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Address',
                    style: TextStyle(
                      color: Color.fromARGB(255, 76, 31, 154),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 360,
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            enabled: editProfile,
                            initialValue: widget.currUser.addr,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            maxLength: 50,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                                labelText: 'Address line 1', counterText: ''),
                            onSaved: (value) {
                              setState(() {
                                addr_line1 = value!;
                              });
                            },
                          )),
                      Container(
                          width: 360,
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            enabled: editProfile,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            maxLength: 50,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                                labelText: 'Address line 2', counterText: ''),
                            onSaved: (value) {
                              setState(() {
                                addr_line2 = value!;
                              });
                            },
                          )),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                              // width: MediaQuery.of(context).size.width / 4 -
                              //     MediaQuery.of(context).size.width / 100,
                             // padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                enabled: editProfile,
                                initialValue: widget.currUser.city,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                maxLength: 30,
                                style: const TextStyle(fontSize: 18),
                                decoration: const InputDecoration(
                                    labelText: 'City', counterText: ''),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z ]')),
                                ],
                                onSaved: (value) {
                                  setState(() {
                                    city = value!;
                                  });
                                },
                              )),
                          Container(
                              width: 95,
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 20),
                              child: TextFormField(
                                enabled: editProfile,
                                initialValue: widget.currUser.post,
                                keyboardType: TextInputType.text,
                                maxLength: 6,
                                textCapitalization:
                                    TextCapitalization.characters,
                                style: const TextStyle(fontSize: 18),
                                decoration: const InputDecoration(
                                    labelText: 'Postal Code', counterText: ''),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[A-Z0-9 ]')),
                                ],
                                onSaved: (value) {
                                  setState(() {
                                    post = value!;
                                  });
                                },
                              )),
                          Container(
                            width: 165,
                            child: IgnorePointer(
                              ignoring: !editProfile,
                              child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                alignedDropdown: true,
                                layoutBehavior:
                                    ButtonBarLayoutBehavior.constrained,
                                child: DropdownButtonFormField<String>(
                                  isDense: false,
                                  menuMaxHeight: 150,
                                  alignment: AlignmentDirectional.centerStart,
                                  padding: EdgeInsets.only(
                                      top: 20,
                                      left: MediaQuery.of(context).size.width /
                                          140),
                                  borderRadius: BorderRadius.circular(10),
                                  focusColor: Colors.transparent,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      labelText: '     Province'),
                                  value: widget.currUser.province == ''
                                      ? province
                                      : widget.currUser.province,
                                  items: (country == 'CA' ? can_lst : usa_lst)
                                      .map((label) => DropdownMenuItem(
                                            alignment:
                                                AlignmentDirectional.center,
                                            child: Text(label),
                                            value: label,
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() => province = value!);
                                  },
                                ),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Personal',
                    style: TextStyle(
                      color: Color.fromARGB(255, 76, 31, 154),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      if (widget.currUser.signInMethod != 'google') ...[
                        Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  enabled: editProfile,
                                  initialValue: widget.currUser.fname,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.words,
                                  maxLength: 30,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                      labelText: 'First Name', counterText: ''),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z ]')),
                                  ],
                                  onSaved: (value) {
                                    setState(() {
                                      fname = value!;
                                    });
                                  },
                                )),
                            Expanded(
                                // width: MediaQuery.of(context).size.width / 2.5,
                                // padding: const EdgeInsets.only(left: 20),
                                child: TextFormField(
                                  enabled: editProfile,
                                  initialValue: widget.currUser.lname,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.words,
                                  maxLength: 30,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                      labelText: 'Last Name', counterText: ''),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z ]')),
                                  ],
                                  onSaved: (value) {
                                    setState(() {
                                      lname = value!;
                                    });
                                  },
                                )),
                          ],
                        ),
                        const SizedBox(height: 5)
                      ] else ...[
                        const SizedBox(height: 3)
                      ],
                      if (widget.currUser?.isDoctor == false) ...[
                        Row(
                          children: [
                            Expanded(
                              //width: 100,
                              //padding: const EdgeInsets.only(left: 10),
                              child: IgnorePointer(
                                ignoring: !editProfile,
                                child: InputDatePickerFormField(
                                  initialDate: widget.currUser.dob ?? dob,
                                  firstDate: DateTime(1940),
                                  lastDate: DateTime.now(),
                                  fieldLabelText: 'Date of Birth',
                                  keyboardType: TextInputType.datetime,
                                  acceptEmptyDate: true,
                                  onDateSubmitted: (value) {
                                    setState(() {
                                      dob = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            IgnorePointer(
                              ignoring: !editProfile,
                              child: IconButton(
                                hoverColor: Colors.transparent,
                                disabledColor: Colors.blue,
                                padding: const EdgeInsets.only(top: 20),
                                icon: const Icon(Icons.calendar_month),
                                onPressed: () => selectDate(context),
                              ),
                            ),

                            // Expanded(
                            //   //width: 100,
                            //   child: IgnorePointer(
                            //     ignoring: !editProfile,
                            //     child: DropdownButtonHideUnderline(
                            //         child: ButtonTheme(
                            //       alignedDropdown: true,
                            //       layoutBehavior:
                            //           ButtonBarLayoutBehavior.constrained,
                            //       child: DropdownButtonFormField<String>(
                            //         isDense: true,
                            //         menuMaxHeight: 115,
                            //         alignment: AlignmentDirectional.centerStart,
                            //         padding: EdgeInsets.only(
                            //             top: 10,
                            //             left:
                            //                 MediaQuery.of(context).size.width /
                            //                     150),
                            //         borderRadius: BorderRadius.circular(10),
                            //         focusColor: Colors.transparent,
                            //         decoration: const InputDecoration(
                            //             contentPadding: EdgeInsets.zero,
                            //             focusedBorder: InputBorder.none,
                            //             enabledBorder: UnderlineInputBorder(
                            //                 borderSide: BorderSide(
                            //                     color: Colors.transparent)),
                            //             labelText: 'Sex'),
                            //         value: widget.currUser.sex,
                            //         items: genders
                            //             .map((label) => DropdownMenuItem(
                            //                   alignment:
                            //                       AlignmentDirectional.center,
                            //                   child: Text(label),
                            //                   value: label,
                            //                 ))
                            //             .toList(),
                            //         onChanged: (value) {
                            //           setState(() {
                            //             sex = value!;
                            //           });
                            //         },
                            //       ),
                            //     )),
                            //   ),
                            // ),
                            // SizedBox(
                            //     width: MediaQuery.of(context).size.width / 20),
                            // Expanded(
                            //  // width: 80,
                            //   child: IgnorePointer(
                            //     ignoring: !editProfile,
                            //     child: DropdownButtonHideUnderline(
                            //         child: ButtonTheme(
                            //       alignedDropdown: true,
                            //       layoutBehavior:
                            //           ButtonBarLayoutBehavior.constrained,
                            //       child: DropdownButtonFormField<String>(
                            //         isDense: true,
                            //         menuMaxHeight: 115,
                            //         alignment: AlignmentDirectional.centerStart,
                            //         padding: const EdgeInsets.only(top: 10),
                            //         borderRadius: BorderRadius.circular(10),
                            //         focusColor: Colors.transparent,
                            //         decoration: const InputDecoration(
                            //             contentPadding: EdgeInsets.zero,
                            //             focusedBorder: InputBorder.none,
                            //             enabledBorder: UnderlineInputBorder(
                            //                 borderSide: BorderSide(
                            //                     color: Colors.transparent)),
                            //             labelText: 'Blood Type'),
                            //         value: widget.currUser.bloodType == ''
                            //             ? bloodType
                            //             : widget.currUser.bloodType,
                            //         items: bloodTypes
                            //             .map((label) => DropdownMenuItem(
                            //                   alignment:
                            //                       AlignmentDirectional.center,
                            //                   child: Text(label),
                            //                   value: label,
                            //                 ))
                            //             .toList(),
                            //         onChanged: (value) {
                            //           setState(() {
                            //             bloodType = value!;
                            //           });
                            //         },
                            //       ),
                            //     )),
                            //   ),
                            // )
                          ],
                        ),
                      ],




                      if (widget.currUser?.isDoctor == false) ...[
                        Row(
                          children: [
                            Expanded(
                              //width: 100,
                              child: IgnorePointer(
                                ignoring: !editProfile,
                                child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      layoutBehavior:
                                      ButtonBarLayoutBehavior.constrained,
                                      child: DropdownButtonFormField<String>(
                                        isDense: true,
                                        menuMaxHeight: 115,
                                        alignment: AlignmentDirectional.centerStart,
                                        padding: EdgeInsets.only(
                                            top: 10,
                                            left:
                                            MediaQuery.of(context).size.width /
                                                150),
                                        borderRadius: BorderRadius.circular(10),
                                        focusColor: Colors.transparent,
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent)),
                                            labelText: 'Sex'),
                                        value: widget.currUser.sex,
                                        items: genders
                                            .map((label) => DropdownMenuItem(
                                          alignment:
                                          AlignmentDirectional.center,
                                          child: Text(label),
                                          value: label,
                                        ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            sex = value!;
                                          });
                                        },
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 20),
                            Expanded(
                              // width: 80,
                              child: IgnorePointer(
                                ignoring: !editProfile,
                                child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      layoutBehavior:
                                      ButtonBarLayoutBehavior.constrained,
                                      child: DropdownButtonFormField<String>(
                                        isDense: true,
                                        menuMaxHeight: 115,
                                        alignment: AlignmentDirectional.centerStart,
                                        padding: const EdgeInsets.only(top: 10),
                                        borderRadius: BorderRadius.circular(10),
                                        focusColor: Colors.transparent,
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent)),
                                            labelText: 'Blood Type'),
                                        value: widget.currUser.bloodType == ''
                                            ? bloodType
                                            : widget.currUser.bloodType,
                                        items: bloodTypes
                                            .map((label) => DropdownMenuItem(
                                          alignment:
                                          AlignmentDirectional.center,
                                          child: Text(label),
                                          value: label,
                                        ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            bloodType = value!;
                                          });
                                        },
                                      ),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ],




                      const SizedBox(height: 15),
                      if (widget.currUser?.isDoctor == false) ...[
                        Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width / 4,
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  enabled: editProfile,
                                  initialValue: widget.currUser.hairCol,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.none,
                                  maxLength: 30,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                      labelText: 'Hair Color', counterText: ''),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z ]')),
                                  ],
                                  onSaved: (value) {
                                    setState(() {
                                      hairCol = value!;
                                    });
                                  },
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width / 3,
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width / 20),
                                child: TextFormField(
                                  enabled: editProfile,
                                  initialValue: widget.currUser.eyeCol,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.none,
                                  maxLength: 30,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                      labelText: 'Eye Color', counterText: ''),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z ]')),
                                  ],
                                  onSaved: (value) {
                                    setState(() {
                                      eyeCol = value!;
                                    });
                                  },
                                )),
                            Container(
                                width:
                                    MediaQuery.of(context).size.width / 3 - 10,
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width / 20),
                                child: TextFormField(
                                  enabled: editProfile,
                                  initialValue: widget.currUser.skinTone,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.none,
                                  maxLength: 30,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                      labelText: 'Skin Tone', counterText: ''),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z ]')),
                                  ],
                                  onSaved: (value) {
                                    setState(() {
                                      skinTone = value!;
                                    });
                                  },
                                )),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 55),
                SizedBox(
                  width: 180,
                  height: 45,
                  child: InkWell(
                    splashColor: Colors.deepPurple,
                    hoverColor: Colors.deepPurple.withOpacity(0.1),
                    highlightColor: Colors.deepPurple,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          size: 40,
                          color: Colors.deepPurple,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Sign out',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 25,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    onTap: () async {
                      await FirebaseUIAuth.signOut(
                        context: context,
                        auth: FirebaseAuth.instance,
                      ).whenComplete(() {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const AuthGate()),
                            (Route<dynamic> route) => false);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 50,
                  alignment: AlignmentDirectional.center,
                  child: FloatingActionButton.extended(
                      heroTag: null,
                      backgroundColor: Colors.red.shade400,
                      icon: const Icon(Icons.delete_forever),
                      label: Text('Delete Account'),
                      onPressed: (() async {
                        await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Delete Account'),
                                  contentPadding: const EdgeInsets.only(
                                      top: 15, left: 15, right: 15),
                                  content: const Text('Are you sure?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () async => await _userDataService
                                          .deleteProfile(widget.currUser)
                                          .whenComplete(
                                              () async => await _user?.delete())
                                          .whenComplete(() => ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'User account deleted'))))
                                          .whenComplete(() => Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AuthGate()),
                                                  (Route<dynamic> route) => false)),
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ));
                      })),
                ),
                const SizedBox(height: 30),
              ],
            )
          ],
        ),
      ),
    );
  }
}
