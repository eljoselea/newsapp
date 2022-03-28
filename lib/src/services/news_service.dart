import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/news_models.dart';

final _URL_NEWS = 'newsapi.org/v2';
final _APIKEY = '6265e6e2b7644ceaa6eed18fe0a10b30';

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  String _selectedCategory = 'business';

  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyball, 'sport'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];

  Map<String, List<Article>> categoryArticles = {
  };

  NewsService() {
    this.getTopHeadLines();
    categories.forEach((item) {
      this.categoryArticles[item.name] = [];
    });
  }

  String get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor) {
    this._selectedCategory = valor;
    this.getArticlesByCategory(valor);

    notifyListeners();
  }

  List <Article>? get getArticulosCategoriaSeleccionada 
  => this.categoryArticles[this.selectedCategory];

  getTopHeadLines() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=gb&apiKey=6265e6e2b7644ceaa6eed18fe0a10b30');
    final resp = await http.get(url);
    final newsResponse = newsResponseFromJson(resp.body);
    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesByCategory(String category) async {

    if (this.categoryArticles[category]!.length > 0 ){
      return this.categoryArticles[category];
    }

    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=gb&apiKey=6265e6e2b7644ceaa6eed18fe0a10b30&category=${category}');
    final resp = await http.get(url);
    final newsResponse = newsResponseFromJson(resp.body);
    this.categoryArticles[category]!.addAll(newsResponse.articles);
    notifyListeners();
  }
}
