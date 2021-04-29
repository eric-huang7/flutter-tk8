import 'package:flutter/material.dart';
import 'package:tk8/data/models/academy_category.model.dart';

class VideoCategoryQuickSelect extends StatelessWidget {
  final AcademyCategory category;
  final VoidCallback onPressed;

  const VideoCategoryQuickSelect(
      {Key key, @required this.category, @required this.onPressed})
      : assert(category != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Ink(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          alignment: Alignment.center,
          child: Text(category.title),
        ),
      ),
    );
  }
}
