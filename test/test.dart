import 'package:bored_angle/Widgetbar.dart';
import 'package:bored_angle/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class newsData{

  late String newsdata;

  Future getNews ()async{
    Response response = await get(Uri.parse('https://newsapi.org/v2/top-headlines?country=ph&apiKey=099ef0b6af0d4a74ad7db8c80091ffc5'));

    newsdata = response.body;
    return newsdata;
  }
}

class News extends StatefulWidget {

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {

  late String scr, name, aut, title, desc, url, pub, content, img;
  int add = 0;

  @override
  void initState() {
    super.initState();
    update();
  }

  void update() async {
    newsData news = new newsData();
    String article = await news.getNews();
    var dec = jsonDecode(article)['articles'];
    for (int i = 0; i < add; i++) {
      setState(() {
        scr = dec[i]['source']['name'] ?? '';
        aut = dec[i]['author'] ?? '';
        title = dec[i]['title'] ?? '';
        desc = dec[i]['description'] ?? '';
        url = dec[i]['url'] ?? '';
        img = dec [i]['urlToImage'];
        pub = dec[i]['publishedAt'] ?? '';
        content = dec[i]['content'] ?? '';
      });
    }
  }

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse('$url');
    if (!await launchUrl(uri,
        mode: LaunchMode.inAppWebView)) {
      throw "Can not launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'Image/logo.png',
          fit: BoxFit.contain,
          height: 20,
          alignment: FractionalOffset.center,
        ),
        backgroundColor: Colors.black54,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'News',
                  style: titleStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: CardWidget(
              cardColor: Color(0xff1d1f33),
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child:Column(
                            children: [
                              Text(
                                '$title',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Source: $scr',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ))),

                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: const
                          EdgeInsets.fromLTRB(30, 40, 10, 30),
                          child: RawMaterialButton(
                            child: Text(
                              'URL',
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            constraints: BoxConstraints.tightFor(
                              width: 150,
                              height: 150,
                            ),
                            fillColor: Color(0xffff312e),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            onPressed: () {
                              launchURL(url);
                              print(url);
                            },
                          ),
                        ),

                      ],
                    ),

                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
