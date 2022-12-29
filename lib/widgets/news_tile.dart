import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_trainer/models/news_data.dart';
import 'package:crypto_trainer/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NewsTile extends StatelessWidget {
final NewsData news;
final Alignment alignment;

NewsTile({required this.news,required this.alignment});

Future<void> _launchUrl() async {
  print("Launching News Url Browser");
  if (!await launchUrl(Uri.parse(news.articleUrl),mode: LaunchMode.externalApplication)) {
    throw 'Could not launch ${news.articleUrl}';
  }
}




  @override
  Widget build(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  return GestureDetector(
      onTap: _launchUrl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child:CachedNetworkImage(imageUrl: news.imageUrl, height: height*0.4,
                fit: BoxFit.cover,
                alignment: alignment,
                placeholder: (context,url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context,url,error) => Center(child: Icon(Icons.error)),




              )

            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xCC000000),
                      const Color(0x00000000),
                      const Color(0x00000000),
                      const Color(0xCC000000),
                    ],
                  ),
                )
            ),
            Positioned(
              left: 10,
              bottom: 20,
              right: 10,
              child: Text(
                  news.title,
                  style: TextStyle(fontSize: getFontSize(context, 2.8),fontWeight: FontWeight.w400,color: Colors.white,shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0,0),
                      blurRadius: 6.0,
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(0,0),
                      blurRadius: 16.0,
                      color: Colors.black,
                    ),
                  ],

                  )
              ),
            ),
            Positioned(
              top: 20,
              right: 10,
              child: Text(
                  news.source,
                  style: TextStyle(fontSize: getFontSize(context, 1.95),fontWeight: FontWeight.w500,color: Colors.white)
              ),
            )
          ],
        ),
      )
    );
  }
}





