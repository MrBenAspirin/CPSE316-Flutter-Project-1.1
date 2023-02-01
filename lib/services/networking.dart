import 'dart:convert';
import 'package:NewsApp/model/article_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:rate_limiter/rate_limiter.dart';

class StatusCodeDisplay extends StatelessWidget {
  final int statCode;

  StatusCodeDisplay({Key key, this.statCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("Status Code: $statCode");
  }
}

class Networking {
  int statCode;

  Future<List<Article>> getArticle(String search, String apiKey) async {
    //if theres no inputted search value in the textfield do:
    if (search == null) {
      try {
        Response response = await get(Uri.parse("https://newsapi.org/v2/everything?q=news&apiKey=$apiKey"));

        if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body);

          List<dynamic> body = json['articles'];

          List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();

          return articles;
        } else {
          statCode = response.statusCode;
          throw Exception("Response status code is not 200");
        }
      } catch (exception) {
        throw ("Can't get the Articles");
      }

      //if user inputted search value in the textfield do:
    } else {
      try {
        Response response = await get(Uri.parse("https://newsapi.org/v2/everything?q=$search&apiKey=$apiKey"));

        if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body);

          List<dynamic> body = json['articles'];

          List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();

          return articles;
        } else {
          statCode = response.statusCode;
          throw Exception("Response status code is not 200");
        }
      } catch (exception) {
        throw ("Can't get the Articles");
      }
    }
  }
}

//final String apiID1 = "77fc7fcb498f4837bda6bebb7cb033e2";
//final String apiID2 = "f5f09f5970784ffb8a83aa7c05e8bf5e";