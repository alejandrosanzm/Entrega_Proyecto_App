import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palabras_por_sonrisas/data/model/letter/letter.dart';

class LetterDetailState extends State<LetterDetail> {
  Letter _myLetter;
  bool isFavorite = false;

  LetterDetailState(this._myLetter, this.isFavorite);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _myAppBar(),
      body: _myBody(),
    );
  }

  Widget _myBody() {
    return SingleChildScrollView(
      child: Container(
        margin: new EdgeInsets.all(15.0),
        child: _myForm(),
      ),
    );
  }

  Widget _myForm() {
    var icon = Icon(Icons.child_care);
    var imageTile = ListTile(
        title: Row(
      children: <Widget>[
        Icon(
          Icons.format_paint,
          color: Colors.deepPurple,
        ),
        Text(" "),
        Text("No hay dibujo para esta carta")
      ],
    ));

    if (_myLetter.profile == "Adolescentes") {
      icon = Icon(Icons.videogame_asset);
    } else if (_myLetter.profile == "Adultos") {
      icon = Icon(Icons.work);
    }

    if (_myLetter.image != "") {
      imageTile = ListTile(
        title: Image.network("http://192.168.1.65/palabraspsonrisas2/res/img/" +
            _myLetter.image),
      );
    }

    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "Carta de " + _myLetter.writer,
            style: TextStyle(color: Colors.white, fontSize: 23),
          ),
          subtitle: Text("Subida en " + _myLetter.date.substring(0, 10)),
          trailing: Column(
            children: <Widget>[icon, Text(_myLetter.profile)],
          ),
        ),
        ListTile(
          title: Text(
            _myLetter.letter,
            style: TextStyle(color: Colors.white),
          ),
        ),
        imageTile
      ],
    );
  }

  Widget _myAppBar() {
    var icon = IconButton(icon: Icon(Icons.favorite_border));
    if (isFavorite) {
      icon = IconButton(icon: Icon(Icons.favorite));
    }

    return AppBar(
      title: Text("Palabras por Sonrisas"),
      actions: <Widget>[icon],
    );
  }
}

// ignore: must_be_immutable
class LetterDetail extends StatefulWidget {
  Letter _myLetter;
  bool isFavorite = false;

  LetterDetail(this._myLetter, this.isFavorite);

  @override
  State<StatefulWidget> createState() {
    return LetterDetailState(_myLetter, isFavorite);
  }
}
