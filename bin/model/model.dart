library server_model;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Model {

  static Model model;

  factory Model() {
    print("Model()");

    // allow only one instance
    if (model == null) {
      model = new Model._internal();
    }

    return model;
  }

  Model._internal() {
    List<Future> futures = [];

    // load all data
//    dataSources.forEach((dataSource) {
//      futures.add(HttpRequest.getString(dataSource['path']));
//    });

    Future.wait(futures).then((List values) {
      print(JSON.decode(values[0]));
    });
  }
}