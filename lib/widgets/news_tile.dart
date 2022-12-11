import 'package:crypto_trainer/models/news_data.dart';
import 'package:crypto_trainer/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsTile extends StatelessWidget {
final NewsData news;

NewsTile({required this.news});

Future<void> _launchUrl() async {
  print("Launching News Url Browser");
  if (!await launchUrl(Uri.parse(news.articleUrl))) {
    throw 'Could not launch ${news.articleUrl}';
  }
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchUrl,
      child: Container(

        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 4,
              child: Container(
                  height: 85,
                  decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage(news.imageUrl),
                  fit: BoxFit.fill,
                )
              )),
            ),
            SizedBox(width: 4,),
            Flexible(
              fit: FlexFit.tight,
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(news.title,style: TextStyle(fontSize: getFontSize(context, 2.3),fontWeight: FontWeight.w400)),
                  SizedBox(height: 10,),
                  Container(
                    alignment: Alignment.bottomRight,
                      child: Text(news.source,style: TextStyle(fontSize: getFontSize(context, 2.2),fontWeight: FontWeight.w400,letterSpacing: 2)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

