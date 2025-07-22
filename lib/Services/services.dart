import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:news_app/model/news_model.dart';

class NewsApi {
  List<NewsModel> dataStore = [];

  Future<void> getNews() async {
    try {
      await InternetAddress.lookup('google.com');
      
      final Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=7d4f4ef7153849bd926e427fdc51d475");

      final response = await http.get(url).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        dataStore = (jsonData['articles'] as List)
            .map((article) => NewsModel.fromJson(article))
            .toList();
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Connection timeout');
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }
}

// أضف هذه الفئة الجديدة
class CategoryNews {
  List<NewsModel> dataStore = [];

  Future<void> getNews(String category) async {
    try {
      await InternetAddress.lookup('google.com');
      
      final Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=7d4f4ef7153849bd926e427fdc51d475");

      final response = await http.get(url).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        dataStore = (jsonData['articles'] as List)
            .map((article) => NewsModel.fromJson(article))
            .toList();
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Connection timeout');
    } catch (e) {
      throw Exception('Failed to load category news: $e');
    }
  }
}