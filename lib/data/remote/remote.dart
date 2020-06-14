import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:palabras_por_sonrisas/data/model/hospital/hospital.dart';
import 'package:palabras_por_sonrisas/data/model/hospital/hospitalContainer.dart';
import 'package:palabras_por_sonrisas/data/model/letter/letterContainer.dart';

class Remote {
  Future<LetterContainer> getAll() async {
    String _url = 'http://192.168.1.65:3267/getAll';
    final response = await http.get(_url);

    if (response.statusCode == 200) {
      // print("---> [${json.decode(response.body)}]");
      return LetterContainer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<HospitalContainer> getHospitals() async {
    String _url = 'http://192.168.1.65:3267/getHospitals';
    final response = await http.get(_url);

    if (response.statusCode == 200) {
      return HospitalContainer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<void> sendLetter(String name, String profile, String letter,
      bool isPublic, File image, List<Hospital> hospitals, main) async {
    List<String> hospitalIds = [];
    for (Hospital h in hospitals) {
      if (h.isSelected) {
        hospitalIds.add(h.id.toString());
      }
    }

    String profileInt = '1';
    if (profile == "Adolescentes") {
      profileInt = '2';
    } else if (profile == "Adultos") {
      profileInt = '3';
    }

    /*
    final uri = 'http://192.168.1.65/palabraspsonrisas2/send_letter.php';
    var map = new Map<String, dynamic>();
    map['submit'] = 'true';
    map['name'] = name;
    map['profile'] = profileInt;
    map['letter'] = letter;
    map['public'] = isPublic == true ? '1' : '0';
    // map['image'] = UploadFileInfo(image, "upload.jpg");
    map['hospitals'] =
        hospitalIds.toString().replaceAll("[", "").replaceAll("]", "");

    http.Response response = await http.post(
      uri,
      body: map,
    );
    */

    var postUri =
        Uri.parse("http://192.168.1.65/palabraspsonrisas2/send_letter.php");
    var request = new http.MultipartRequest("POST", postUri);
    request.fields['submit'] = 'true';
    request.fields['name'] = name;
    request.fields['profile'] = profileInt;
    request.fields['letter'] = letter;
    request.fields['public'] = isPublic == true ? '1' : '0';
    request.fields['hospitals'] =
        hospitalIds.toString().replaceAll("[", "").replaceAll("]", "");
    // request.fields['image'] = 'customUpload.jpg';

    if (image != null) {
      // await File.fromUri(image.uri).readAsBytes()
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        await File.fromUri(image.uri).readAsBytes(),
        contentType: MediaType('image', 'jpg'),
        filename: "upload_prev.jpg",
      ));
    }

    request.send().then((response) {
      if (response.statusCode == 200 || response.statusCode == 302) {
        print("!! Uploaded");
        print(response.stream.toString());
        main.refresh();
      } else {
        print("ERROR IN POST: code-" + response.statusCode.toString());
      }
      print("IMG: " + image.toString());
    });

    /*
    print("-------- " + response.body);
    print("--------");
    print("-------- " + json.encode(map));
    */
  }
}
