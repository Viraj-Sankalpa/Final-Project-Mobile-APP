import 'dart:io';

import 'package:dating_app/profile_page/PickImageFromGalleryOrCamera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Connection> connections = [
    Connection(day: "2022-12-20"),
    Connection(day: "2022-12-21"),
    Connection(day: "2022-12-22"),
    Connection(day: "2022-12-23"),
    Connection(day: "2022-12-24"),
  ];
  bool profileLoading = false;
  final picker = ImagePicker();
  late XFile? pickedFile;
  bool isImagesPicked = false;
  bool covidStatus = false;

  // TODO: get the profile details from the api

  Future saveImage(context) async {
    try {
      XFile? _image =
          await PickImageFromGalleryOrCamera.getProfileImage(context, picker);

      if (_image!.path != "") {
        setState(() {
          isImagesPicked = true;
          profileLoading = true;
          pickedFile = _image;
        });
      } else {
        print('No image');
      }

      setState(() {
        profileLoading = false;
      });
    } catch (e) {
      setState(() {
        profileLoading = false;
      });
    }
  }

  Color getCovidColorCode() {
    return covidStatus == true ? Colors.red : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return Column(
              children: [
                SizedBox(height: 20),
                Container(
                    height: 100,
                    width: 100,
                    child: isImagesPicked == false
                        ? CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/doctor.png'),
                          )
                        : Container(
                            child: Image.file(
                              File(pickedFile!.path),
                              fit: BoxFit.cover,
                            ),
                          )),
                MaterialButton(
                  onPressed: () => saveImage(context),
                  child: Icon(Icons.cloud_upload),
                ),
                SizedBox(height: 20),
                Text(
                  'Angela Yu',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.coronavirus,
                  color: getCovidColorCode(),
                ),
                Text(
                  "covid status",
                  style: TextStyle(
                    color: getCovidColorCode(),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    final Future<SharedPreferences> _prefs =
                        SharedPreferences.getInstance();
                    final SharedPreferences prefs = await _prefs;
                    prefs.remove("isLogin");
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text("Log out"),
                ),
                profileSections("Edit page", ''),
                profileSections("Connection Details", 'connectivityDetails'),
              ],
            );
          },
        ),
      ),
    );
  }

  Card profileSections(String title, String path) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Color.fromARGB(255, 179, 222, 243),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 15),
        ),
        trailing: IconButton(
          onPressed: () {
            if (path.isNotEmpty) Navigator.pushNamed(context, '/$path');
          },
          icon: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}

class Connection {
  final String day;
  Connection({required this.day});
}
