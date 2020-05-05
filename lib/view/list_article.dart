import 'package:flutter/material.dart';
import 'package:flutternewsapp/bloc/article_bloc.dart';
import 'package:flutternewsapp/models/article.dart';
import 'package:flutternewsapp/models/article_response.dart';
import 'package:flutternewsapp/utils/show_loading.dart';

class ListArticle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListArticleState();
  }
}

class _ListArticleState extends State<ListArticle> {
  @override
  void initState() {
    super.initState();
    //Technology = query params for news category
    bloc.getNews("Technology");
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: bloc.subject.stream,
      builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _buildErrorWidget(snapshot.data.error);
          }
          return _adapterUser(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: showLoading());
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error occured: $error",
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle),
          ],
        ));
  }


  Widget _adapterUser(ArticleResponse data) {
    List<Article> article = data.articles;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: article.length,
        itemBuilder: (context, index) {
          return Container(
            child: Card(
                child: InkWell(
//                  onTap: (){
//                    //Navigator.push(context, MaterialPageRoute(builder: (context) => PageDetail(users: users[index],),
//                    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => PageDetail(
//                      users: article[index],
//                    )));
//                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(article[index].urlToImage)
                            ),
                            shape: BoxShape.circle
                        ),
                      ),
                      Container(
                        child: Text(article[index].title, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 2,),
                      )

                    ],
                  ),
                )
            ),
          );
        });
  }
}