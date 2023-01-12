import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckboxWidget extends StatefulWidget {
  @override
  CheckboxWidgetState createState() => new CheckboxWidgetState();
}

class CheckboxWidgetState extends State {
  Map<String, bool> values = {
    'Apple': false,
    'Banana': false,
    'Cherry': false,
    'Mango': false,
    'Orange': false,
  };

  Future<List<EntryModel>> getApiList() async {
    var url = Uri.parse("https://api.publicapis.org/entries");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var resData = jsonDecode(response.body);
      List data = resData['entries'];
      return data.map((e) => EntryModel.fromJson(e)).toList();
    } else {
      return List<EntryModel>.empty();
    }
  }

  var tmpArray = [];

  getCheckboxItems() {
    values.forEach((key, value) {
      if (value == true) {
        tmpArray.add(key);
      }
    });

    // Printing all selected items on Terminal screen.
    print(tmpArray);
    // Here you will get all your selected Checkbox items.

    // Clear array after use.
    tmpArray.clear();
  }

  List<bool> boolList = <bool>[];
  List<String> ids = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ids[0]"),
      ),
      body: Column(children: <Widget>[
        Expanded(child: FutureBuilder(
          future: getApiList(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              List<EntryModel> data = snapshot.data;
              for (var i = 0; i < data.length; i++) {
                boolList.add(false);
              }
              return _mainView(data, boolList);
            } else {
              return CircularProgressIndicator();
            }
          },
        )),
      ]),
    );
  }

  int selectedItem = 0;

  _mainView(List<EntryModel> data, List<bool> localData) {
    return ListView.builder(
        itemCount: localData.length,
        itemBuilder: (context, index) {
          var key = data[index].auth??"";
          return CheckboxListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: SizedBox(
                    height: 150,
                    child: Row(
                      children: [
                        Text(index.toString()),
                        Text(key),
                        Text(key),
                        Text(key),
                        Text(key),
                        Text(key)
                      ],
                    ),
                  ),
                ),

              ],
            ),
            value: localData[index],
            activeColor: Colors.pink,
            checkColor: Colors.white,
            onChanged: (bool? value) {
              setState(() {
                ids.add(data[index].auth??"");
                localData[index] = value ?? false;
              });
            },
          );
        });
  }
}

EntryModel? entryModelFromJson(String str) =>
    EntryModel.fromJson(json.decode(str));

String entryModelToJson(EntryModel? data) => json.encode(data!.toJson());

class EntryModel {
  EntryModel({
    this.api,
    this.description,
    this.auth,
    this.https,
    this.cors,
    this.link,
    this.category,
  });

  String? api;
  String? description;
  String? auth;
  bool? https;
  String? cors;
  String? link;
  String? category;

  factory EntryModel.fromJson(Map<String, dynamic> json) => EntryModel(
        api: json["API"],
        description: json["Description"],
        auth: json["Auth"],
        https: json["HTTPS"],
        cors: json["Cors"],
        link: json["Link"],
        category: json["Category"],
      );

  Map<String, dynamic> toJson() => {
        "API": api,
        "Description": description,
        "Auth": auth,
        "HTTPS": https,
        "Cors": cors,
        "Link": link,
        "Category": category,
      };
}
