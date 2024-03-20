import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';

import 'package:guillama/shared/data.dart';
import 'package:guillama/models/model.dart';
import 'package:guillama/models/message.dart';

// API class to handle all the API calls
class API {
  // Connect to the ollama server
  static Future<bool> connect() async {
    // Create a new Dio instance
    final dio = Dio();
    dio.httpClientAdapter = NativeAdapter();

    // Construct the url from server address and port
    final http = Prefs.getBool('https') ?? false ? 'https' : 'http';
    final serverAddress = Prefs.getString('serverAddress') ?? 'localhost';
    final serverPort = Prefs.getInt('serverPort') ?? 11434;
    final url = '$http://$serverAddress:$serverPort';

    // Send a GET request to the server
    final response = await dio.get(url);

    // If the response is 200, the server is reachable
    return response.statusCode == 200;
  }

  // Test connection to the ollama server
  static Future<bool> testConnection(String url) async {
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
    final http = Prefs.getBool('https') ?? false ? 'https' : 'http';
    final serverAddress = Prefs.getString('serverAddress') ?? 'localhost';
    final serverPort = Prefs.getInt('serverPort') ?? 11434;
    final url = '$http://$serverAddress:$serverPort/api/tags';

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

  // Get information about a specific model
  static Future<Model> showModel(String modelID) async {
    // Create a new Dio instance
    final dio = Dio();
    dio.httpClientAdapter = NativeAdapter();

    // Construct the url from server address and port
    final http = Prefs.getBool('https') ?? false ? 'https' : 'http';
    final serverAddress = Prefs.getString('serverAddress') ?? 'localhost';
    final serverPort = Prefs.getInt('serverPort') ?? 11434;
    final url = '$http://$serverAddress:$serverPort/api/show';

    // Prepare the request body
    final body = {'model': modelID};

    // Send a POST request to the server
    final response = await dio.post(url, data: body);

    // Parse JSON response
    final model = Model.fromJson(response.data['details']);

    // Add name and tag to the model
    model.name = modelID.split(':')[0];
    model.tag = modelID.split(':')[1];

    // Return the model
    return model;
  }

  // Pull a new model from ollama.com
  static Stream<dynamic> pullModel(String modelID) async* {
    // Create a new Dio instance
    final dio = Dio();
    dio.httpClientAdapter = NativeAdapter();

    // Construct the url from server address and port
    final http = Prefs.getBool('https') ?? false ? 'https' : 'http';
    final serverAddress = Prefs.getString('serverAddress') ?? 'localhost';
    final serverPort = Prefs.getInt('serverPort') ?? 11434;
    final url = '$http://$serverAddress:$serverPort/api/pull';

    // Prepare the request body
    final body = {'name': modelID};

    // Send a POST request to the server
    final response = await dio.post<ResponseBody>(url,
        data: body, options: Options(responseType: ResponseType.stream));

    // Yield the response
    yield* utf8.decoder
        .bind(response.data!.stream)
        .transform(const LineSplitter())
        .map((line) => jsonDecode(line));
  }

  // Copy/Duplicate a specified model with a new name
  static Future<bool> copyModel(String srcModelID, String destModelID) async {
    // Create a new Dio instance
    final dio = Dio();
    dio.httpClientAdapter = NativeAdapter();

    // Construct the url from server address and port
    final http = Prefs.getBool('https') ?? false ? 'https' : 'http';
    final serverAddress = Prefs.getString('serverAddress') ?? 'localhost';
    final serverPort = Prefs.getInt('serverPort') ?? 11434;
    final url = '$http://$serverAddress:$serverPort/api/copy';

    // Prepare the request body
    final body = {
      'source': srcModelID,
      'destination': destModelID,
    };

    // Send a POST request to the server
    final response = await dio.post(url, data: body);

    // If the response is 200, the model was copied
    return response.statusCode == 200;
  }

  // Delete a specified model
  static Future<bool> deleteModel(String modelID) async {
    // Create a new Dio instance
    final dio = Dio();
    dio.httpClientAdapter = NativeAdapter();

    // Construct the url from server address and port
    final http = Prefs.getBool('https') ?? false ? 'https' : 'http';
    final serverAddress = Prefs.getString('serverAddress') ?? 'localhost';
    final serverPort = Prefs.getInt('serverPort') ?? 11434;
    final url = '$http://$serverAddress:$serverPort/api/delete';

    // Prepare the request body
    final body = {'name': modelID};

    // Send a DELETE request to the server
    final response = await dio.delete(url, data: body);

    // If the response is 200, the model was deleted
    return response.statusCode == 200;
  }

  // Send a message to a specified ollama model
  static Stream sendMessage(String modelID, String message) async* {
    // Create a new Dio instance
    final dio = Dio();
    dio.httpClientAdapter = NativeAdapter();

    // Construct the url from server address and port
    final http = Prefs.getBool('https') ?? false ? 'https' : 'http';
    final serverAddress = Prefs.getString('serverAddress') ?? 'localhost';
    final serverPort = Prefs.getInt('serverPort') ?? 11434;
    final url = '$http://$serverAddress:$serverPort/api/generate';

    // Prepare the request body
    final body = {
      'model': modelID,
      'prompt': message,
    };

    // Send a POST request to the server
    final response = await dio.post<ResponseBody>(url,
        data: body, options: Options(responseType: ResponseType.stream));

    // Yield the response
    yield* utf8.decoder
        .bind(response.data!.stream)
        .transform(const LineSplitter())
        .map((line) => jsonDecode(line));
  }

  // Send a chat message with history to a specified ollama model
  static Stream sendChat(String modelID, List<Message> chatHistory) async* {
    // Create a new Dio instance
    final dio = Dio();
    dio.httpClientAdapter = NativeAdapter();

    // Construct the url from server address and port
    final http = Prefs.getBool('https') ?? false ? 'https' : 'http';
    final serverAddress = Prefs.getString('serverAddress') ?? 'localhost';
    final serverPort = Prefs.getInt('serverPort') ?? 11434;
    final url = '$http://$serverAddress:$serverPort/api/chat';

    // Prepare the request body
    final body = {
      'model': modelID,
      'messages': chatHistory.map((message) => message.toJson()).toList(),
    };

    // Send a POST request to the server
    final response = await dio.post<ResponseBody>(url,
        data: body, options: Options(responseType: ResponseType.stream));

    // Yield the response
    yield* utf8.decoder
        .bind(response.data!.stream)
        .transform(const LineSplitter())
        .map((line) => jsonDecode(line));
  }
}
