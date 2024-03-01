import 'package:dio/dio.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';

import 'package:guillama/shared/data.dart';

// API class to handle all the API calls
class API {
  // Connect to the ollama server
  static Future<bool> connect(String url) async {
    // Create a new Dio instance
    final dio = Dio();
    dio.httpClientAdapter = NativeAdapter();

    // Send a GET request to the server
    final response = await dio.get(url);

    // If the response is 200, the server is reachable
    return response.statusCode == 200;
  }

  // Lists all the models installed on the server
  static Future<List<String>> listModels() async {
    // Create a new Dio instance
    final dio = Dio();
    dio.httpClientAdapter = NativeAdapter();

    // Construct the url from server address and port
    final serverAddress = Prefs.getString('serverAddress') ?? 'localhost';
    final serverPort = Prefs.getInt('serverPort') ?? 11434;
    final url = 'http://$serverAddress:$serverPort/api/tags';

    // Send a GET request to the server
    final response = await dio.get(url);

    // Parse JSON response
    final List<String> models = [];
    for (final model in response.data['models']) {
      models.add(model['name']);
    }

    // Return the list of models
    return models;
  }

  static Future<bool> sendMessage(String chat, String message) async {
    final dio = Dio();
    dio.httpClientAdapter = NativeAdapter();

    final serverAddress = Prefs.getString('serverAddress') ?? 'localhost';
    final serverPort = Prefs.getString('serverPort') ?? '11434';
    final url = 'http://$serverAddress:$serverPort/api/chat/$chat';

    final response = await dio.post(url, data: {'message': message});

    return response.statusCode == 200;
  }
}
