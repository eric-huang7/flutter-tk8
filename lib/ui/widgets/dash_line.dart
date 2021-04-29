import 'package:flutter/material.dart';

class DashLine extends StatelessWidget {
  const DashLine({
    Key key,
    this.direction = Axis.horizontal,
    this.dashColor = Colors.black,
    this.length = 200,
    this.dashGap = 3,
    this.dashLength = 6,
    this.dashThickness = 1,
    this.dashBorderRadius = 0,
    this.finishWithGap = false,
  }) : super(key: key);

  final Axis direction;
  final Color dashColor;
  final double length;
  final double dashGap;
  final double dashLength;
  final double dashThickness;
  final double dashBorderRadius;
  final bool finishWithGap;

  @override
  Widget build(BuildContext context) {
    final dashes = <Widget>[];
    final newLength = length - (finishWithGap ? dashGap : 0);
    final n = (newLength + dashGap) / (dashGap + dashLength);
    final newN = n.round();
    final newDashGap = (newLength - dashLength * newN) / (newN - 1);
    for (var i = newN; i > 0; i--) {
      dashes.add(step(i, newDashGap));
    }
    if (direction == Axis.horizontal) {
      return SizedBox(
          width: newLength,
          child: Row(
            children: dashes,
          ));
    } else {
      return Column(children: dashes);
    }
  }

  Widget step(int index, double newDashGap) {
    final isHorizontal = direction == Axis.horizontal;
    return Padding(
        padding: EdgeInsets.fromLTRB(
            0,
            0,
            isHorizontal && index != 1 ? newDashGap : 0,
            isHorizontal || index == 1 ? 0 : newDashGap),
        child: SizedBox(
          width: isHorizontal ? dashLength : dashThickness,
          height: isHorizontal ? dashThickness : dashLength,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: dashColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(dashBorderRadius))),
          ),
        ));
  }
}
