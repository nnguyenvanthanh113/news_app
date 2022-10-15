import 'package:http/http.dart' as http;
import 'package:news_app/constants/newApi_contants.dart';
import 'dart:convert';

import 'package:news_app/model/NewsModel.dart';

class NewsRepository {
  //lay tat ca tin tuc
  Future<List<NewsModel>> fetchNews() async {
    String url =
        "https://newsapi.org/v2/top-headlines?q=business&languages=en&apiKey==${NewsApiConstants.newsApiKey} ";

    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    List<NewsModel> articleModelList = [];
    if (response.statusCode == 200) {
      for (var data in jsonData[NewsApiConstants.articles]) {
        if (data[NewsApiConstants.urlToImage] != null) {
          NewsModel articleModel = NewsModel.fromJson(data);
          articleModelList.add(articleModel);
        }
      }
      return articleModelList;
    } else {
      // nguoc lai tra ve list rong
      return articleModelList;
    }
  }

  //lay tin nong
  Future<List<NewsModel>> fetchBreakingNews() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=${NewsApiConstants.newsApiKey}";

    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    List<NewsModel> articleModelList = [];
    if (response.statusCode == 200) {
      for (var data in jsonData[NewsApiConstants.articles]) {
        if (data[NewsApiConstants.description].toString().isNotEmpty &&
            data[NewsApiConstants.urlToImage].toString().isNotEmpty) {
          NewsModel articleModel = NewsModel.fromJson(data);
          articleModelList.add(articleModel);
        }
      }
      return articleModelList;
    } else {
      // tra ve danh sach rong
      return articleModelList;
    }
  }

  //tim tin tuc theo dieu kien
  Future<List<NewsModel>> searchNews({required String query}) async {
    String url = '';
    if (query.isEmpty) {
      url =
          'https://newsapi.org/v2/everything?q=biden&from=${NewsApiConstants.date}&sortBy=popularity&apiKey=${NewsApiConstants.newsApiKey}';
    } else {
      url =
          "https://newsapi.org/v2/everything?q=$query&from=${NewsApiConstants.date}&sortBy=popularity&apiKey=${NewsApiConstants.newsApiKey}";
      print(NewsApiConstants.date);
    }

    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    List<NewsModel> articleModelList = [];
    if (response.statusCode == 200) {
      for (var data in jsonData[NewsApiConstants.articles]) {
        if (query.isNotEmpty && data[NewsApiConstants.urlToImage] != null) {
          NewsModel articleModel = NewsModel.fromJson(data);
          articleModelList.add(articleModel);
        } else if (query.isEmpty) {
          throw Exception('Query is empty');
        } else {
          throw Exception('Data was not loaded properly');
        }
      }
      return articleModelList;
    } else {
      //tra ve danh sach rong
      return articleModelList;
    }
  }
}
