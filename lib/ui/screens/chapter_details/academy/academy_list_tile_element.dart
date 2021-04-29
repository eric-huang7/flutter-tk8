import 'package:flutter/material.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/widgets/widgets.dart';

enum AcademyItemProgressStatus {
  done,
  available,
  locked,
}

enum AcademyItemProgressStatusIndicatorSize {
  regular,
  small,
}

final _lockedColor = TK8Colors.grey.withOpacity(0.5);

const _progressStatusIcon = {
  AcademyItemProgressStatus.done: Icons.check,
  AcademyItemProgressStatus.available: Icons.play_arrow,
  AcademyItemProgressStatus.locked: Icons.lock,
};

final _progressStatusIconColor = {
  AcademyItemProgressStatus.done: TK8Colors.ocean,
  AcademyItemProgressStatus.available: Colors.white,
  AcademyItemProgressStatus.locked: _lockedColor,
};

const _progressStatusIndicatorRegularSize = 46.0;
const _progressStatusIndicatorCondensedSize = 32.0;
const _listTileElementHeight = 80.0;
const _listTileHorizontalMargin = 16.0;
const _listTileVerticalMargin = 8.0;

class AcademyListTileElement extends StatelessWidget {
  final int orderNumber;
  final String title;
  final String subtitle;
  final Widget thumbnail;
  final AcademyItemProgressStatus progressStatus;
  final AcademyItemProgressStatus prevProgressStatus;
  final AcademyItemProgressStatus nextProgressStatus;
  final AcademyItemProgressStatusIndicatorSize progressStatusIndicatorSize;
  final bool highlight;

  double get _indicatorSize => progressStatusIndicatorSize ==
          AcademyItemProgressStatusIndicatorSize.small
      ? _progressStatusIndicatorCondensedSize
      : _progressStatusIndicatorRegularSize;

  const AcademyListTileElement({
    Key key,
    this.orderNumber,
    @required this.title,
    @required this.subtitle,
    @required this.thumbnail,
    @required this.progressStatus,
    this.prevProgressStatus,
    this.nextProgressStatus,
    this.progressStatusIndicatorSize =
        AcademyItemProgressStatusIndicatorSize.regular,
    this.highlight = false,
  })  : assert(title != null),
        assert(subtitle != null),
        assert(thumbnail != null),
        assert(progressStatus != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const progressLineMargin =
        _listTileHorizontalMargin - 2 + _progressStatusIndicatorRegularSize / 2;
    final progressLineHeight = (_listTileElementHeight - _indicatorSize) / 2;
    return Container(
      height: _listTileElementHeight,
      decoration: highlight
          ? const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color(0x1a0c2246),
                blurRadius: 30,
              )
            ], color: Colors.white)
          : null,
      child: Stack(
        children: [
          if (orderNumber != null)
            Positioned(
              left: 92,
              top: 2,
              child: Text(
                '$orderNumber',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: "RevxNeue",
                  fontStyle: FontStyle.normal,
                  fontSize: 72.0,
                  foreground: Paint()
                    ..strokeWidth = 1
                    ..color = TK8Colors.superDarkBlue.withOpacity(0.15)
                    ..style = PaintingStyle.stroke,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _listTileHorizontalMargin,
              vertical: _listTileVerticalMargin,
            ),
            child: Row(
              children: [
                thumbnail,
                const Space.horizontal(24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontFamily: "RevxNeue",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xff7c838d),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Gotham",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _itemProgressStatus(context),
              ],
            ),
          ),
          if (prevProgressStatus != null)
            Positioned(
              top: 0,
              right: progressLineMargin,
              height: progressLineHeight,
              child: _progressLineForProgressStatus(prevProgressStatus, false),
            ),
          if (nextProgressStatus != null)
            Positioned(
              bottom: 0,
              right: progressLineMargin,
              height: progressLineHeight,
              child: _progressLineForProgressStatus(nextProgressStatus, true),
            ),
        ],
      ),
    );
  }

  Widget _progressLineForProgressStatus(
    AcademyItemProgressStatus progressStatus,
    bool finishWithGap,
  ) {
    if (progressStatus == AcademyItemProgressStatus.locked) {
      return DashLine(
        direction: Axis.vertical,
        length: (_listTileElementHeight - _indicatorSize) / 2,
        dashLength: 1,
        dashGap: 2,
        dashColor: _indicatorColorForStatus(progressStatus),
        finishWithGap: finishWithGap,
      );
    }
    return Container(
      width: 2,
      height: _indicatorSize,
      color: _indicatorColorForStatus(progressStatus),
    );
  }

  Color _indicatorColorForStatus(AcademyItemProgressStatus progressStatus) {
    return progressStatus == AcademyItemProgressStatus.locked
        ? _lockedColor
        : TK8Colors.ocean;
  }

  Widget _itemProgressStatus(BuildContext context) {
    final filled = progressStatus == AcademyItemProgressStatus.available;
    final color = _indicatorColorForStatus(progressStatus);
    final iconSize = progressStatusIndicatorSize ==
            AcademyItemProgressStatusIndicatorSize.small
        ? 14.0
        : 18.0;

    return SizedBox(
      width: _progressStatusIndicatorRegularSize,
      height: _progressStatusIndicatorRegularSize,
      child: Center(
        child: Container(
          width: _indicatorSize,
          height: _indicatorSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(_indicatorSize / 2)),
            border: Border.all(color: color, width: 2),
            color: filled ? color : Colors.white,
          ),
          child: Icon(
            _progressStatusIcon[progressStatus],
            size: iconSize,
            color: _progressStatusIconColor[progressStatus],
          ),
        ),
      ),
    );
  }
}
