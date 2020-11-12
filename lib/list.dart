import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactPickerScreen extends StatefulWidget {
  @override
  _ContactPickerScreenState createState() => _ContactPickerScreenState();
}

class _ContactPickerScreenState extends State<ContactPickerScreen> {
  bool _isLoading = false;
  Iterable<Contact> contactsArray = [];

  @override
  void initState() {
    getAllContacts();
    super.initState();
  }

  bool longPressFlag = false;
  List<int> indexList = new List();

  // void longPress() {
  //   setState(() {
  //     if (indexList.isEmpty) {
  //       longPressFlag = false;
  //     } else {
  //       longPressFlag = true;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('profile'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Favorite'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('help?'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Broadcast SMS'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () => exit(0),
                child: Icon(
                  Icons.close,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                minLines: 3,
                maxLines: 6,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Write your message here',
                  filled: true,
                  fillColor: Color(0xFFDBEDFF),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                'SEND TO:',
                style: TextStyle(height: 1, fontSize: 22),
              ),
              addRadioButton(0, 'SELECTED'),
              addRadioButton(1, 'FAVORITE'),
              addRadioButton(2, 'ALL'),
            ],
          ),
          Container(
            child: TextField(
              autocorrect: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Here...',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 15),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
              ),
              width: 330,
              height: 370,
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: contactsArray.map((e) {
                        final name =
                            e.displayName == null ? 'No Name' : e.displayName;
                        final middleName = e.middleName == null
                            ? 'No Middle Name'
                            : e.middleName;

                        return Card(
                          elevation: 5,
                          color: Colors.red[100],
                          shadowColor: Colors.black,
                          child: ListTile(
                            title: Text(name),
                            subtitle: Text(middleName),
                            trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.star),
                                  Checkbox(value: false, onChanged: null),
                                ]),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          )),
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black12)),
            color: Colors.red,
            textColor: Colors.white,
            padding: EdgeInsets.all(8.0),
            onPressed: () {},
            child: Text(
              "SEND".toUpperCase(),
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
    return scaffold;
  }

  Future<void> getAllContacts() async {
    setState(() {
      _isLoading = true;
    });
    print('Getting contacts');
    contactsArray = await ContactsService.getContacts(
      withThumbnails: false,
    );
    print('Contact list Size : ${contactsArray.length}');
    setState(() {
      _isLoading = false;
    });
  }

  List gender = ["ALL", "FAVORITE", "SELECTED"];

  String select;

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }
}
