
import 'package:flutternewsapp/models/article_response.dart';
import 'package:flutternewsapp/repository/article_repository.dart';
import 'package:rxdart/rxdart.dart';

class ArticleBloc {
  final ArticleRepository _repository = new ArticleRepository();
  final BehaviorSubject<ArticleResponse> _subject = new BehaviorSubject<ArticleResponse>();

  //add data response from repository to article model
  getNews(String query) async {
    ArticleResponse response = await _repository.getNews(query);
    _subject.sink.add(response);
  }

  //closing subject rx dart to avoid leaks
  dispose(){
    _subject.close();
  }

  //rxdart
  BehaviorSubject<ArticleResponse> get subject => _subject;
}

final bloc = ArticleBloc();