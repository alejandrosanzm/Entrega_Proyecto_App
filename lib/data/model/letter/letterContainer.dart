import 'letter.dart';

class LetterContainer {
  List<Letter> letters;

  LetterContainer({this.letters});

  factory LetterContainer.fromJson(List<dynamic> json) {
    List<Letter> letters = json.map((i) => Letter.fromJson(i)).toList();

    return LetterContainer(
      letters: letters,
    );
  }
}
