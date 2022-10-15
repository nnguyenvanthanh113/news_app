import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/constants/newApi_contants.dart';
import 'package:news_app/model/ArticleModel.dart';
import 'package:news_app/model/NewsModel.dart';

class NewsController extends GetxController {
  // danh sach tin tuc hien tren list view trang chu
  List<ArticleModel> allNews = <ArticleModel>[];
  // danh sach tin tuc casousel
  List<ArticleModel> breakingNews = <ArticleModel>[];
  ScrollController scrollController = ScrollController();
  RxBool articleNotFound = false.obs;
  RxBool isLoading = false.obs;
  RxString cName = ''.obs;
  RxString country = ''.obs;
  RxString category = ''.obs;
  RxString channel = ''.obs;
  RxString searchNews = ''.obs;
  RxInt pageNum = 1.obs;
  RxInt pageSize = 10.obs;
  String baseUrl = "https://newsapi.org/v2/top-headlines?";

  @override
  void onInit() {
    scrollController = ScrollController()..addListener(_scrollListener);
    getAllNews();
    getBreakingNews();
    super.onInit();
  }

  _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoading.value = true;
      getAllNews();
    }
  }

  //function de load va hien thi tin tuc
  getBreakingNews({reload = false}) async {
    articleNotFound.value = false;

    if (!reload && isLoading.value == false) {
    } else {
      country.value = '';
    }
    if (isLoading.value == true) {
      pageNum++;
    } else {
      breakingNews = [];

      pageNum.value = 2;
    }
    baseUrl =
        "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&languages=en&";
    // set mac dinh ngon ngu la tieng anh my
    baseUrl += country.isEmpty ? 'country=us&' : 'country=$country&';
    baseUrl += 'apiKey=${NewsApiConstants.newsApiKey}';
    print([baseUrl]);
    //goi api lay ban tin, truyen vao baseUrl
    getBreakingNewsFromApi(baseUrl);
  }

  // hien thi tat ca tin tuc va tim kiem tat ca tin tuc
  getAllNews({channel = '', searchKey = '', reload = false}) async {
    articleNotFound.value = false;

    if (!reload && isLoading.value == false) {
    } else {
      country.value = '';
      category.value = '';
    }
    if (isLoading.value == true) {
      pageNum++;
    } else {
      allNews = [];

      pageNum.value = 2;
    }
    baseUrl = "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&";
    // mac dinh quoc gia la An Do
    baseUrl += country.isEmpty ? 'country=in&' : 'country=$country&';
    // mac dinh the loai la kinh doanh
    baseUrl += category.isEmpty ? 'category=business&' : 'category=$category&';
    baseUrl += 'apiKey=${NewsApiConstants.newsApiKey}';
    if (channel != '') {
      country.value = '';
      category.value = '';
      baseUrl =
          "https://newsapi.org/v2/top-headlines?sources=$channel&apiKey=${NewsApiConstants.newsApiKey}";
    }
    if (searchKey != '') {
      country.value = '';
      category.value = '';
      baseUrl =
          "https://newsapi.org/v2/everything?q=$searchKey&from=${NewsApiConstants.date}&sortBy=popularity&pageSize=10&apiKey=${NewsApiConstants.newsApiKey}";
    }
    print(baseUrl);
    // goi function api lay tat ca tin nong.
    getAllNewsFromApi(baseUrl);
  }

  //tra ve cac tin nong tu newwApi.org
  getBreakingNewsFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      NewsModel newsData = NewsModel.fromJson(jsonDecode(res.body));

      if (newsData.articles.isEmpty && newsData.totalResults == 0) {
        articleNotFound.value = isLoading.value == true ? false : true;
        isLoading.value = false;
        update();
      } else {
        if (isLoading.value == true) {
          //ket hop tin nong va thong tin
          breakingNews = [...breakingNews, ...newsData.articles];
          update();
        } else {
          if (newsData.articles.isNotEmpty) {
            breakingNews = newsData.articles;
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            update();
          }
        }
        articleNotFound.value = false;
        isLoading.value = false;
        update();
      }
    } else {
      articleNotFound.value = true;
      update();
    }
  }

  //tra ve json thong tin tat ca cac tin tuc tu newsApi.org
  getAllNewsFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      //phan tich cu phap string sau do tra ve doi tuong Json
      NewsModel newsData = NewsModel.fromJson(jsonDecode(res.body));

      if (newsData.articles.isEmpty && newsData.totalResults == 0) {
        articleNotFound.value = isLoading.value == true ? false : true;
        isLoading.value = false;
        update();
      } else {
        if (isLoading.value == true) {
          // hop nhat 2 list allNews va newsData
          allNews = [...allNews, ...newsData.articles];
          update();
        } else {
          if (newsData.articles.isNotEmpty) {
            allNews = newsData.articles;
            //scroll tro ve dau trang
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            update();
          }
        }
        articleNotFound.value = false;
        isLoading.value = false;
        update();
      }
    } else {
      articleNotFound.value = true;
      update();
    }
  }
}
