import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;


class ExpandCollapseButton extends StatefulWidget {

  final Color? color;
  final Function? onTap;
  final bool isNeededSearchIcon;
  final bool isUpArrow;

  ExpandCollapseButton({this.color = Colors.grey,this.onTap,this.isNeededSearchIcon = false,this.isUpArrow = true});

  @override
  State<ExpandCollapseButton> createState() => _ExpandCollapseButtonState();
}

class _ExpandCollapseButtonState extends State<ExpandCollapseButton> {

  bool isUp = true;

  @override
  void initState() {
    super.initState();
    isUp = widget.isUpArrow;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
          color: Colors.white60,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5, offset: Offset(0, 1)), // changes position of shadow
          ],
          border: Border.all(
            color: ColorResources.getPrimary(context).withOpacity(.5),
          ),
          borderRadius: BorderRadius.circular(5)),
      child: widget.isNeededSearchIcon&&!isUp?IconButton(
        onPressed: () {
          setState(() {
            isUp = !isUp;
          });
          if(widget.onTap!=null){
            widget.onTap!(isUp);
          }
        },
        icon: Icon(Icons.search, color: widget.color, size: 18),
      ):Transform.rotate(
        angle: isUp?(270 * math.pi / 180):(90 * math.pi / 180),
        child: IconButton(
          onPressed: () {
            setState(() {
              isUp = !isUp;
            });
            if(widget.onTap!=null){
              widget.onTap!(isUp);
            }
          },
          icon: Icon(Icons.double_arrow, color: widget.color, size: 18),
        ),
      ),
    );
  }
}
