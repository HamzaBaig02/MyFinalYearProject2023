
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../constants/colors.dart';

class CustomShowCase extends StatelessWidget {

  final GlobalKey refKey;
  final Widget child;
  final String description;
  final double targetPadding;
  final double blur;
  final double opacity;
  final VoidCallback? onTargetClick;
  final bool? disposeOnTap;
  CustomShowCase({required this.refKey,required this.child,required this.description,this.targetPadding = 0,this.blur = 1.65,this.opacity = 0,this.onTargetClick,this.disposeOnTap});

  @override
  Widget build(BuildContext context) {

    return Showcase(key: refKey, child: child, description: description,overlayOpacity: opacity,tooltipBackgroundColor: domColor,textColor: Colors.white,targetBorderRadius: BorderRadius.circular(5),targetPadding: EdgeInsets.symmetric(vertical: targetPadding),blurValue: blur,onTargetClick: this.onTargetClick,disposeOnTap: disposeOnTap ,);
  }
}
