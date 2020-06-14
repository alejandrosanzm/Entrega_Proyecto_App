import 'package:flutter/material.dart';
import 'package:palabras_por_sonrisas/data/local/myFavorites.dart';
import 'package:palabras_por_sonrisas/data/model/letter/letter.dart';
import 'package:palabras_por_sonrisas/data/model/letter/letterContainer.dart';
import 'package:palabras_por_sonrisas/ui/favoritesList/favoritesList.dart';
import 'package:palabras_por_sonrisas/ui/letterDetail/letterDetail.dart';
import 'dart:convert';
import 'package:palabras_por_sonrisas/ui/lettersList/lettersList.dart';
import 'package:palabras_por_sonrisas/ui/main.dart';
import 'package:palabras_por_sonrisas/ui/writeYourLetter/writeYourLetter.dart';

class LetterListPresenter {
  void clickTile(context, data, isFavorite) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LetterDetail(data, isFavorite)),
    );
  }

  void clickFavorites(data, main) {
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

      setFavorites(main);
    });
  }

  void goToFavorites(context, main) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoritesList(main)),
    );
  }

  void setFavorites(LetterListState main) {
    MyFavorites().getFavorites().then((val) {
      var container = LetterContainer.fromJson(json.decode(val));
      main.setFavorites(container.letters);
    });
  }

  void goToWriteYourLetter(context, main) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WriteYourLetter(main)),
    );
  }
}
