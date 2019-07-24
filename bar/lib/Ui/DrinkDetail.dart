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

    response = await http.get(
        "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${widget._drinkData['idDrink']}");

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: 2,
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      backgroundColor: Color(0xff7f0000),
                      expandedHeight: 350.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text(widget._drinkData['strDrink'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              )),
                          background: Image.network(
                            widget._drinkData['strDrinkThumb'],
                            fit: BoxFit.cover,
                          )),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          indicatorColor: Color(0xff7f0000),
                          labelColor: Colors.black87,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(
                              text: "INGREDIENTS",
                            ),
                            Tab(text: "RECIPE"),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(children: <Widget>[
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                    strokeWidth: 3,
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
                  ),
                  Container(
                    child: FutureBuilder(
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                  strokeWidth: 3,
                                ),
                              );
                            default:
                              if (snapshot.hasError)
                                return Container();
                              else
                                return _ingRec(context, snapshot);
                          }
                        }),
                  ),
                ]))));
  }

  Widget _ingComp(BuildContext context, AsyncSnapshot snapshot) {
    var ing = [];
    for (var i = 1; i <= 15; i++) {
      if (snapshot.data['drinks'][0]['strIngredient$i'] != '') {
        if (snapshot.data['drinks'][0]['strMeasure$i'] != " ") {
          ing.add('- ${snapshot.data['drinks'][0]['strMeasure$i']} de ${snapshot.data['drinks'][0]['strIngredient$i']}');
        } else {
          ing.add('-  ${snapshot.data['drinks'][0]['strIngredient$i']}');
        }
      }
    }
    print(ing);

    return Column(
        children: ing
            .map((item) => ListTile(
                  title: Text(
                    item,
                    style: TextStyle(fontSize: 20),
                  ),
                ))
            .toList());
  }

  Widget _ingRec(BuildContext context, AsyncSnapshot snapshot) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            snapshot.data['drinks'][0]['strInstructions'],
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
