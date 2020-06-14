import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palabras_por_sonrisas/data/model/letter/letter.dart';
import 'package:palabras_por_sonrisas/ui/favoritesList/favoritesListPresenter.dart';
import 'package:palabras_por_sonrisas/ui/lettersList/lettersList.dart';

class FavoritesListState extends State<FavoritesList> {
  LetterListState letterList;
  FavoritesListPresenter presenter;
  List<Letter> favorites;
  bool flag = false;

  FavoritesListState(this.letterList);

  @override
  Widget build(BuildContext context) {
    if (!flag) {
      presenter = FavoritesListPresenter(this);
      presenter.setFavorites();
      flag = true;
    }

    return Scaffold(
      appBar: _myAppBar(),
      body: _myBody(),
    );
  }

  Widget _myBody() {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return _myTile(favorites[index]);
      },
    );
  }

  Widget _myTile(data) {
    var subtitle = data.letter.toString();
    var favorite = IconButton(
      icon: Icon(Icons.favorite_border),
      onPressed: () {
        presenter.clickFavorites(data, this, letterList);
      },
    );
    var title = Row(
      children: <Widget>[
        Text(data.writer.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Colors.white,
            ))
      ],
    );

    if (data.image.toString() != "") {
      title = Row(
        children: <Widget>[
          Text(data.writer.toString(),
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
        if (l.id == data.id) {
          favorite = IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              presenter.clickFavorites(data, this, letterList);
            },
          );
          isFavorite = true;
        }
      }
    }

    if (data.letter.toString().length > 32) {
      subtitle = data.letter.toString().substring(0, 29) + "...";
    }

    return ListTile(
      onTap: () {
        presenter.clickTile(context, data);
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

  Widget _myAppBar() {
    return AppBar(
      title: Text("Favoritos"),
    );
  }

  void setFavorites(data) {
    setState(() {
      favorites = data;
    });
  }
}

// ignore: must_be_immutable
class FavoritesList extends StatefulWidget {
  LetterListState letterList;

  FavoritesList(this.letterList);

  @override
  State<StatefulWidget> createState() {
    return FavoritesListState(letterList);
  }
}
