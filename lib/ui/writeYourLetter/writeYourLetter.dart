import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palabras_por_sonrisas/data/model/hospital/hospital.dart';
import 'package:palabras_por_sonrisas/data/model/hospital/hospitalContainer.dart';
import 'package:palabras_por_sonrisas/data/remote/remote.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palabras_por_sonrisas/ui/lettersList/lettersList.dart';

class WriteYourLetterState extends State<WriteYourLetter> {
  final _formKey = GlobalKey<FormState>();
  String _nameValue = "Anon";
  String _profileValue = "Peques";
  String _letterValue = "";
  List<Hospital> _myHospitals = [];
  File _image;
  final picker = ImagePicker();
  bool _isPublicLetter = false;
  LetterListState mainList;
  bool flag = false;

  WriteYourLetterState(this.mainList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _myAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: _myForm(),
        ),
      ),
    );
  }

  Widget _myAppBar() {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Remote().sendLetter(_nameValue, _profileValue, _letterValue,
                  _isPublicLetter, _image, _myHospitals, mainList);
              Navigator.pop(context);
            }
          },
        ),
      ],
      title: Text("Write Your Own Letter"),
    );
  }

  Widget _myForm() {
    return Form(
      key: _formKey,
      child: _myFormUI(),
    );
  }

  Widget _myFormUI() {
    TextStyle _titlesStyle = TextStyle(color: Colors.white, fontSize: 20.0);

    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(20.0),
          leading: Icon(Icons.assignment_ind),
          title: Text(
            "¿Quién escribe esta carta?",
            style: _titlesStyle,
          ),
          subtitle: TextFormField(
            decoration: InputDecoration(hintText: "Tu nombre"),
            onChanged: (val) {
              _nameValue = val;
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(20.0),
          leading: Icon(Icons.public),
          title: Text(
            "¿A quién va dirigida?",
            style: _titlesStyle,
          ),
          subtitle: new DropdownButton<String>(
            hint: Text(_profileValue),
            items: <String>['Peques', 'Adolescentes', 'Adultos']
                .map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _profileValue = val;
              });
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(20.0),
          leading: Icon(Icons.headset),
          title: Text(
            "Escribe tu carta",
            style: _titlesStyle,
          ),
          subtitle: TextFormField(
            decoration: InputDecoration(
                hintText:
                    "Lorem ipsum dolor sit amet consectetur adipiscing elit..."),
            // ignore: missing_return
            validator: (val) {
              if (val.isEmpty) {
                return "Tu carta se enviaría vacía";
              }
            },
            onChanged: (val) {
              _letterValue = val;
            },
          ),
        ),
        ListTile(
          title: Text(
            "Sube un dibujo tuyo",
            style: _titlesStyle,
          ),
          subtitle: Row(
            children: <Widget>[
              Text(_image.toString().length > 30
                  ? _image.toString().substring(0, 27) + "..."
                  : _image.toString()),
              IconButton(
                onPressed: getImage,
                icon: Icon(Icons.cloud_upload),
              )
            ],
          ),
          leading: Icon(Icons.border_color),
          // subtitle: ImagePicker.pickImage(source: ImageSource.gallery),
        ),
        ListTile(
          leading: Icon(Icons.local_hospital),
          title: Text(
            "¿A Dónde va tu carta?",
            style: _titlesStyle,
          ),
          subtitle: _myList(),
        ),
        ListTile(
          leading: Icon(Icons.share),
          title: Text(
            "Quiero que mi carta sea pública",
            style: _titlesStyle,
          ),
          subtitle: CheckboxListTile(
            title: Text("Hacer mi carta pública"),
            value: _isPublicLetter,
            onChanged: (bool value) {
              setState(() {
                _isPublicLetter = value;
              });
            },
          ),
        ),
      ],
    );
  }

  FutureBuilder<HospitalContainer> _myList() {
    return FutureBuilder<HospitalContainer>(
      future: Remote().getHospitals(),
      builder: (context, snapshot) {
        if (!flag) {
          _myHospitals = snapshot.data.hospitals;
          flag = true;
        }

        if (snapshot.hasData) {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            itemCount: snapshot.data.hospitals.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return _tile(snapshot, index);
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _tile(snapshot, index) {
    return CheckboxListTile(
      title: Text(
        snapshot.data.hospitals[index].name,
        style: TextStyle(fontSize: 15.0),
      ),
      onChanged: (bool value) {
        setState(() {
          print("--- " + value.toString());
          _myHospitals[index].isSelected = value;
        });
      },
      value: _myHospitals[index].isSelected,
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }
}

// ignore: must_be_immutable
class WriteYourLetter extends StatefulWidget {
  LetterListState mainList;

  WriteYourLetter(this.mainList);

  @override
  State<StatefulWidget> createState() {
    return WriteYourLetterState(mainList);
  }
}
