import 'dart:io';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'package:guillama/models/model.dart';
import 'package:guillama/models/message.dart';

// Stores persistent data using SharedPreferences
class Prefs {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  static Future<void> addToStringList(String key, String value) async {
    List<String>? list = _prefs.getStringList(key);
    list ??= [];
    list.add(value);
    await _prefs.setStringList(key, list);
  }

  static Future<void> removeFromStringList(String key, String value) async {
    List<String>? list = _prefs.getStringList(key);
    list ??= [];
    list.remove(value);
    await _prefs.setStringList(key, list);
  }

  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  static Future<void> removeAll() async {
    await _prefs.clear();
  }

  // Application specific data
  static List<Model> models = [];
  static Map<String, List<Message>> messages = {};
  static Map<String, Stream> downloads = {};

  static void addDownload(String modelID, Stream<dynamic> stream) {
    downloads[modelID] = stream;
  }

  // Store data in local files
  static Future<String> localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> localFile(String file) async {
    final path = await localPath();
    return File('$path/$file');
  }

  static Future<void> createChat(String modelID, String chatName) async {
    String chatID = '${modelID}_$chatName';
    messages[chatID] = [];

    // Save the chatID to the list of chats
    addToStringList('chats', chatID);

    // Create data file for the chat
    final chatFile = await localFile('$chatID.json');
    await chatFile.writeAsString('[]');
  }

  static Future<void> deleteChat(String chatID) async {
    // Remove the chatID from the list of chats
    removeFromStringList('chats', chatID);

    // Delete the data file for the chat
    final chatFile = await localFile('$chatID.json');
    await chatFile.delete();
  }

  static Future<void> saveChats() async {
    final chats = getStringList('chats');

    for (final chatID in chats!) {
      final chatFile = await localFile('$chatID.json');
      // Create a string from the list of messages formatted as JSON
      final chatData = jsonEncode(messages[chatID]);
      await chatFile.writeAsString(chatData);
    }
  }

  static Future<void> loadChats() async {
    final chats = getStringList('chats');

    for (final chatID in chats ?? []) {
      // Load chat data from file
      final chatFile = await localFile('$chatID.json');
      final chatData = await chatFile.readAsString();

      // Convert chat data from string to json and store in messages
      final chatMessages = jsonDecode(chatData);
      messages[chatID] =
          chatMessages.map<Message>((msg) => Message.fromJson(msg)).toList();
    }
  }
}
