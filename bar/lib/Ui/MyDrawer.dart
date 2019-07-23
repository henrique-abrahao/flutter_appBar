import 'package:flutter/material.dart';

import 'Categorias.dart';
import 'Drink.dart';


class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff7f0000),
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage('imges/padrao.png'))
                        ),
                      ),
                    )
                  ],
                )
            ),
            ListTile(
              leading: Icon(
                Icons.local_bar,
                color: Colors.black,
              ),
              title: Text('Drinks alcoólicos'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DrinkPage('alcoolico')));
              },

            ),
            ListTile(
              leading: Icon(
                Icons.local_drink,
                color: Colors.black,
              ),
              title: Text('Drinks Não alcoólicos'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DrinkPage('nao_alcoolico')));
              },

            ),
            ListTile(
              leading: Icon(
                Icons.grid_on,
                color: Colors.black,
              ),
              title: Text('Categorias'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Cat()));
              },

            ),
          ],
        )
    );
  }
}
