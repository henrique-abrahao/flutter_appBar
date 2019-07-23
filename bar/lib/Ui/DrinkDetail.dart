import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Detail extends StatefulWidget {
  final Map _drinkData;

  Detail(this._drinkData);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Future<Map> _getDrinkComp() async {
    http.Response response;

    response = await http
        .get("https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${widget._drinkData['idDrink']}");

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._drinkData['strDrink']),
          backgroundColor: Color(0xff7f0000),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget._drinkData['strDrinkThumb'],
                      width: 250,
                      height: 250,
                    )),
              ),
            ),
            Text(
              'Ingredientes: ',
              style: TextStyle(fontSize: 30, fontFamily: 'Cookie'), textAlign: TextAlign.right,
            ),
            FutureBuilder(
                future: _getDrinkComp(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _ingComp(context, snapshot);
                  }
                }),
          ]),
        ));
  }

  Widget _ingComp(BuildContext context, AsyncSnapshot snapshot) {
    var ing = [];
    for (var i = 1; i <= 15; i++) {
      if (snapshot.data['drinks'][0]['strIngredient$i'] != '') {
        ing.add(snapshot.data['drinks'][0]['strIngredient$i']);
      }
    }

    return
      Column(
            children: ing
                .map((item) => ListTile(
                      leading: Icon(
                        Icons.local_drink,
                      ),
                      title: Text(item,
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Cookie',
                          )),
                    ))
                .toList());
  }
}
