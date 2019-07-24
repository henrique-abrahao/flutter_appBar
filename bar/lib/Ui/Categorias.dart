import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Drink.dart';

class Cat extends StatefulWidget {
  @override
  _CatState createState() => _CatState();
}

class _CatState extends State<Cat> {


  Future<Map> _getCat() async {
    http.Response response;

    response = await http
        .get('https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list');

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff7f0000),
          title: Text(
            "Categories",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        backgroundColor: Color(0xffF8F8F8),
        body: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                  future: _getCat(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                              strokeWidth: 3,
                            ),
                          ),
                        );
                      default:
                        if (snapshot.hasError)
                          return Container();
                        else
                          return _gerGrid(context, snapshot);
                    }
                  }),
            )
          ],
        ));
  }

  Widget _gerGrid(BuildContext context, AsyncSnapshot snapshot) {
    final img = snapshot.data['drinks'].map((item) =>
        item['strCategory'].replaceAll('/', '')).toList();

    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: 11,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Stack(
              children: <Widget>[
                Image.asset(
                  'imges/${img[index]}.jpg',
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child:
                    Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        color: Colors.white70,
                        child: Text(
                          snapshot.data['drinks'][index]['strCategory'],
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),textAlign: TextAlign.center,
                        ),
                    )
                )
              ],
            ),
           onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context) => DrinkPage('${snapshot.data['drinks'][index]['strCategory']}')));
           },
          );
        });
  }

}
