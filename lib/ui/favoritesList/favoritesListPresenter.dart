import 'package:flutter/material.dart';
import 'package:palabras_por_sonrisas/data/local/myFavorites.dart';
import 'package:palabras_por_sonrisas/data/model/letter/letter.dart';
import 'package:palabras_por_sonrisas/ui/favoritesList/favoritesList.dart';
import 'dart:convert';
import 'package:palabras_por_sonrisas/data/model/letter/letterContainer.dart';
import 'package:palabras_por_sonrisas/ui/letterDetail/letterDetail.dart';
import 'package:palabras_por_sonrisas/ui/lettersList/lettersList.dart';

class FavoritesListPresenter {
  FavoritesListState main;

  FavoritesListPresenter(this.main);

  void setFavorites() {
    MyFavorites().getFavorites().then((val) {
      var container = LetterContainer.fromJson(json.decode(val));
      main.setFavorites(container.letters);
    });
  }

  void clickTile(context, data) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LetterDetail(data, true)),
    );
  }

  void clickFavorites(data, main, LetterListState letterList) {
    MyFavorites().getFavorites().then((val) {
      bool exist = false;
      Letter forRemoveLetter = Letter();
      var container = LetterContainer.fromJson(json.decode(val));
      for (Letter l in container.letters) {
        if (l.id == data.id) {
          forRemoveLetter = l;
          exist = true;
        }
      }

      if (exist) {
        container.letters.remove(forRemoveLetter);
      } else {
        container.letters.add(data);
      }

      // print("FINAL_JSON: " + json.encode(container.letters));
      MyFavorites().clearAllPreferences();
      MyFavorites().saveInPreferences(json.encode(container.letters));

      main.setFavorites(container.letters);
      letterList.setFavorites(container.letters);
    });
  }
}
