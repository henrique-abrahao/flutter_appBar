import 'package:bar/Ui/DrinkDetail.dart';
import 'package:flutter/material.dart';

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
                style: TextStyle(fontSize: 15),
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.black,),
                      onPressed:(){
                        setState(() {
                          if(_nmDrink == ''){
                            _nmDrink = null;
                          }
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            color: Colors.black, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            color: Colors.black, width: 1.0)),
                    labelText: "Search Here...",
                    labelStyle: TextStyle(color: Colors.black,)),
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
                            AlwaysStoppedAnimation<Color>(Colors.black),
                            strokeWidth: 3,
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
        leading: Icon(Icons.search, color: Colors.black38),
        title: Text(
          'Nenhum Resultado Encontrado!',
          style: TextStyle(color: Colors.black38, fontSize: 18),
        ),
      );
    } else {
      return ListView.builder(
          itemCount: _getTam(snapshot.data['drinks']),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child:
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Detail(snapshot.data['drinks'][index])));
                    },
                    leading: CircleAvatar(
                      backgroundColor: Color(0xff7f0000),
                      radius: 30,
                      backgroundImage: NetworkImage(
                          snapshot.data['drinks'][index]['strDrinkThumb']),
                    ),
                    title: Text(snapshot.data['drinks'][index]['strDrink']),
                    subtitle: Text(
                        'id: ${snapshot.data['drinks'][index]['idDrink']}'),
                  )

              ),
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
