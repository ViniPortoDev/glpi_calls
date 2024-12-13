import 'package:dio/dio.dart';

//Dio Customizado com a URL Base da API e os tempos de Timeout
BaseOptions options = BaseOptions(
    baseUrl: "http://example.com",
    //baseUrl: "https://example.com",
    connectTimeout: const Duration(milliseconds: 40000),
    receiveTimeout: const Duration(milliseconds: 30000),
    /* contentType: Headers.jsonContentType, */
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
       'App-Token':'apptoken'
    }
    );
var dio = Dio(options);
   
  BaseOptions optionsPush = BaseOptions(
    baseUrl: "https://example.com",
    connectTimeout: const Duration(milliseconds:50000),
    receiveTimeout: const Duration(milliseconds:50000),
  );

  var dioPush = Dio(optionsPush);