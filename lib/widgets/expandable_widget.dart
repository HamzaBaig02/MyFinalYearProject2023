import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpandableWidget extends StatefulWidget {

  final String title;
  final Widget expanded;


  ExpandableWidget({required this.title, required this.expanded});

  @override
  _ExpandableWidgetState createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> with TickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;
  IconData icon = FontAwesomeIcons.angleDown;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  _toggleContainer() {
    print(_animation.status);
    if (_animation.status != AnimationStatus.completed) {
      setState(() {
        icon = FontAwesomeIcons.angleUp;
      });
      _controller.forward();

    } else {
      setState(() {
        icon = FontAwesomeIcons.angleDown;
      });
      _controller.animateBack(0, duration: Duration(milliseconds: 100));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: GestureDetector(
              onTap: _toggleContainer,
              child: Row(
                children: [
                  Text(widget.title,style: TextStyle(fontSize: 20),),
                  Icon(icon,color: Color(0xff8b4a6c),)
                ],
              ),
            ),
          ),
          SizedBox(height: 5,),
          Container(
            child: SizeTransition(
              sizeFactor: _animation,
              axis: Axis.vertical,
              axisAlignment: -1,
              child: widget.expanded,
            ),
          )
        ],
      ),
    );
  }
}
