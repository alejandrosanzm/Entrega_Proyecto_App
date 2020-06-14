import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palabras_por_sonrisas/data/model/letter/letter.dart';
import 'package:palabras_por_sonrisas/data/model/letter/letterContainer.dart';
import 'package:palabras_por_sonrisas/data/remote/remote.dart';
import 'package:palabras_por_sonrisas/ui/lettersList/letterListPresenter.dart';

class LetterListState extends State<LetterList> {
  LetterListPresenter presenter;
  List<Letter> favorites = [];
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    if (!flag) {
      presenter = LetterListPresenter();
      presenter.setFavorites(this);
      flag = true;
    }

    return Scaffold(
      appBar: _myAppBar(),
      body: Center(
        child: _myList(),
      ),
    );
  }

  Widget _myAppBar() {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.favorite),
          onPressed: goToFavorites,
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: goToWriteYourLetter,
        ),
      ],
      title: Text("Palabras Por Sonrisas"),
    );
  }

  void goToFavorites() {
    presenter.goToFavorites(context, this);
  }

  void goToWriteYourLetter() {
    presenter.goToWriteYourLetter(context, this);
  }

  FutureBuilder<LetterContainer> _myList() {
    return FutureBuilder<LetterContainer>(
      future: Remote().getAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.all(15.0),
            itemCount: snapshot.data.letters.length,
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

  // snapshot.data.letters[index].woeid.toString()
  Widget _tile(snapshot, index) {
    var subtitle = snapshot.data.letters[index].letter.toString();
    var favorite = IconButton(
      icon: Icon(Icons.favorite_border),
      onPressed: () {
        clickFavorites(snapshot.data.letters[index]);
      },
    );
    var title = Row(
      children: <Widget>[
        Text(snapshot.data.letters[index].writer.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Colors.white,
            ))
      ],
    );

    if (snapshot.data.letters[index].letter.toString().length > 32) {
      subtitle =
          snapshot.data.letters[index].letter.toString().substring(0, 29) +
              "...";
    }

    if (snapshot.data.letters[index].image.toString() != "") {
      title = Row(
        children: <Widget>[
          Text(snapshot.data.letters[index].writer.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: Colors.white,
              )),
          Text(" "),
          Icon(
            Icons.attachment,
            color: Colors.deepPurple,
            size: 25,
          ),
        ],
      );
    }

    bool isFavorite = false;
    if (favorites != null) {
      for (Letter l in favorites) {
        if (l.id == snapshot.data.letters[index].id) {
          favorite = IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              clickFavorites(snapshot.data.letters[index]);
            },
          );
          isFavorite = true;
        }
      }
    }

    return ListTile(
      onTap: () {
        LetterListPresenter()
            .clickTile(context, snapshot.data.letters[index], isFavorite);
      },
      leading: Icon(
        Icons.mail_outline,
        color: Colors.white,
        size: 35,
      ),
      title: title,
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
      trailing: favorite,
    );
  }

  void clickFavorites(data) {
    presenter.clickFavorites(data, this);
    // setFavorites(data);
  }

  void setFavorites(data) {
    setState(() {
      favorites = data;
    });
  }

  void refresh() {
    setState(() {
      build(context);
    });
  }
}

class LetterList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LetterListState();
  }
}
