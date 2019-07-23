import 'package:bar/Ui/DrinkDetail.dart';
import 'package:flutter/material.dart';

import 'MyDrawer.dart';
import 'Repository.dart';

class DrinkPage extends StatefulWidget {
  final String categoria;

  DrinkPage(this.categoria);

  @override
  _DrinkPageState createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {
  String _nmDrink = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: Color(0xff7f0000),
          title: Text(
            "Drinks",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        backgroundColor: Color(0xffF8F8F8),
        body: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
                decoration: InputDecoration(
                    labelText: "Pesquise o nome do Drink Aqui",
                    labelStyle: TextStyle(color: Colors.black)),
                onSubmitted: (text) {
                  setState(() {
                    if (_nmDrink == '') {
                      _nmDrink = null;
                    } else {
                      _nmDrink = text;
                    }
                  });
                }),
          ),
          Expanded(
              child: FutureBuilder(
                  future: getDrink(_nmDrink, widget.categoria),
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
                          return _drinksAll(context, snapshot);
                    }
                  }))
        ]));
  }

  Widget _drinksAll(BuildContext context, AsyncSnapshot snapshot) {
    if (_getTam(snapshot.data['drinks']) == 0) {
      return ListTile(
        leading: Icon(Icons.search , color: Colors.black38),
        title:Text('Nenhum Resultado Encontrado!', style: TextStyle(color: Colors.black38, fontSize: 18),) ,
      );
    } else {
      return ListView.builder(
          itemCount: _getTam(snapshot.data['drinks']),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: NetworkImage(snapshot.data['drinks']
                                [index]['strDrinkThumb']))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(snapshot.data['drinks'][index]['strDrink']),
                      )
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Detail(snapshot.data['drinks'][index])));
              },
            );
          });
    }
  }

  int _getTam(List data) {
    if (data == null) return 0;
    if (data.length > 0) {
      data.length = (data.length - 1);
      return data.length;
    }
  }
}

