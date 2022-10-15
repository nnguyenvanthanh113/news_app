import 'package:intl/intl.dart';

class NewsApiConstants {
  NewsApiConstants._();
  static const newsApiKey = 'c3c8e3a211ed419c8da525aedac6625f';
  static const mediaStackApi = 'c49733599aae1bec5427af9a7bc5234b';
  static const articles = 'articles';
  static const mediaStackData = 'data';
  static const id = 'id';
  static const name = 'name';
  static const source = 'source';
  static const author = 'author';
  static const title = 'title';
  static const image = 'image';
  static const description = 'description';
  static const url = 'url';
  static const urlToImage = 'urlToImage';
  static const publishedAt = 'publishedAt';
  static const content = 'content';
  static const language = 'language';
  static const category = 'category';
  static const country = 'country';
  static final DateTime now = DateTime.now();
  static final dateSubtract = now.subtract(const Duration(days: 7));
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  static final String date = formatter.format(dateSubtract);
  //static final String date = new DateTime(dateformatter.year, dateformatter.month - 1, dateformatter.day) as String;
  //static const date = '2022-08-25';
}
