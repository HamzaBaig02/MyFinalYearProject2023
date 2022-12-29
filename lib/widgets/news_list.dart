import 'dart:async';
import 'dart:convert';

import 'package:crypto_trainer/models/coin_data.dart';
import 'package:crypto_trainer/widgets/news_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/news_data.dart';
import '../services/functions.dart';
import '../services/network.dart';


Future<List<NewsData>> fetchNews(CoinData coin) async {
  List<NewsData> news = [];
  Uri link = Uri.parse("https://newsapi.org/v2/everything?q=${coin.name}%20AND%20(crypto%20OR%20cryptocurrency)&pageSize=10&apiKey=10e7d179267e426aaec7f426328ad4e5");
  Network cryptoNewsNetwork = Network(link, {"accept": "application/json"});
  String _cryptoData = '';

  _cryptoData = await cryptoNewsNetwork.getData() ?? " ";
  List response = jsonDecode(_cryptoData)['articles'];
print(response.length);
  try {
    for(int i = 0;i < response.length;i++){
      news.add(NewsData(title: response[i]['title'],body: response[i]['content'],source: response[i]['source']['name'],imageUrl: response[i]['urlToImage'],articleUrl: response[i]['url'],date: response[i]['publishedAt']));
    }
  }catch (e) {
    print(e);
    news = [];
    // TODO
  }

return news;

}


class NewsList extends StatefulWidget {
  final CoinData coin;


  NewsList(this.coin);

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  bool newsFail = false;
  List<NewsData> news = [];
  late PageController pageController;
  double pageOffset = 0;
  int _currentPage = 0;
  late Timer _timer;
  bool changePage = true;
  void getNews()async{

    news = await compute(fetchNews,widget.coin);

    setState(() {
        if(news.isEmpty)
          newsFail = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
    pageController = PageController(viewportFraction: 1);
    pageController.addListener(() {
      setState(() {
        pageOffset = pageController.page!;
      });

    });
    _timer = Timer.periodic(Duration(milliseconds: 6700), (Timer timer) {


          if (_currentPage < news.length) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }

          if (pageController.hasClients) {
            pageController.animateToPage(
              _currentPage,
              duration: Duration(milliseconds: 650),
              curve: Curves.easeIn,
            );
          }


    });


  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(children: [Text('${widget.coin.name} News',style: TextStyle(fontSize: getFontSize(context, 2.8),letterSpacing: 1)),
          SizedBox(width: 4,),
          Icon(FontAwesomeIcons.newspaper,color: Color(0xff8b4a6c))
        ]),
        SizedBox(height: 8,),
        news.isEmpty?Center(child: newsFail?Text("Unable to Fetch News"):CircularProgressIndicator(),):
        Container(
          height: height*0.4,

          child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: news.length,
              controller: pageController,
              itemBuilder: (context, i) {
                return NewsTile(news: news[i], alignment: Alignment(-pageOffset.abs() + i,
                    -pageOffset.abs() + i));
              }),
        )
      ],
    );
  }
}


// Container(
// height: 250,
// child: ListView.separated(
// separatorBuilder: (context, index) {
// return Divider(
// height: 1,
// thickness: 1,
// color: Colors.grey.shade300,
// );
// },
// physics: ClampingScrollPhysics(),
// scrollDirection: Axis.vertical,
// itemBuilder: (context, index) {
// return NewsTile(news: news[index] ,);
// },
// itemCount: news.length,
// ),
// ),