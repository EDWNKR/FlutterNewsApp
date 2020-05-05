import 'package:flutternewsapp/models/article_response.dart';
import 'package:flutternewsapp/repository/api_provider.dart';

class ArticleRepository{
  ApiProvider _apiProvider = new ApiProvider();

  Future<ArticleResponse> getNews(String query){
    return _apiProvider.getNews(query);
  }

}