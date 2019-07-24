import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map> getDrink(_nmDrink, categoria) async {
  http.Response response;

  if(_nmDrink == '') {
    response = await http.get(
        'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=$categoria');
    return json.decode(response.body);
  }else if(_nmDrink != ''){
    response = await http.get(
        'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$_nmDrink');
    return json.decode(response?.body ?? {});
  }
}