import 'package:crypto_trainer/Utilities/ErrorSnackBar.dart';
import 'package:crypto_trainer/constants/colors.dart';
import 'package:crypto_trainer/constants/showcase_keys.dart';
import 'package:crypto_trainer/widgets/custom_showcase.dart';
import 'package:flutter/material.dart';

class WalletTilePlaceHolder extends StatelessWidget {
  final String name;
  final String value;
  final imageUrl;

  WalletTilePlaceHolder(this.name,this.value,this.imageUrl);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        ErrorSnackBar().errorSnackBar(error: 'This is a placeholder, buy crypto to get started', context: context,color: domColor);
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Color(0xff2e3340),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xff8b4a6c), width: 2),
        ),
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundImage:
                  NetworkImage(imageUrl, scale: 2),
                  radius: 15,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '$name',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '1.00',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Text(
                      '\$$value',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 3),
                    Text(
                      '0%',
                      style: TextStyle(
                        fontSize: 10,
                        color: 0 > 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WalletTilePlaceHolderShowCase extends StatelessWidget {
  final String name;
  final String value;
  final imageUrl;

  WalletTilePlaceHolderShowCase(this.name,this.value,this.imageUrl);

  @override
  Widget build(BuildContext context) {

    return CustomShowCase(
      refKey: walletTileKey,
      description: showCaseDescriptions['walletTile'].toString(),
      child: GestureDetector(
        onTap: (){
          ErrorSnackBar().errorSnackBar(error: 'This is a placeholder, buy crypto to get started', context: context,color: domColor);
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xff2e3340),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xff8b4a6c), width: 2),
          ),
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundImage:
                    NetworkImage(imageUrl, scale: 2),
                    radius: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '$name',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Column(
                children: [
                  CustomShowCase(
                    refKey: assetAmountKey,
                    description: showCaseDescriptions['assetAmount'].toString(),
                    child: Text(
                      '1.00',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      CustomShowCase(
                        refKey: assetValueKey,
                        description: showCaseDescriptions['assetValue'].toString(),
                        child: Text(
                          '\$$value',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 3),
                      CustomShowCase(
                        refKey: assetPercentageChangeKey,
                        description: showCaseDescriptions['assetPercentageChange'].toString(),
                        child: Text(
                          '0%',
                          style: TextStyle(
                            fontSize: 10,
                            color: 0 > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
