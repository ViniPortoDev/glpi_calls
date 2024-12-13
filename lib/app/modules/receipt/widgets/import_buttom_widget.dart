import 'package:flutter/material.dart';

import '../../../shared/utils/utils.dart';

class ImportButtomWidget extends StatelessWidget {
  final double? heigth;
  final double? width;
  final Color? color;
  final void Function()? onTap;

  const ImportButtomWidget({
    super.key,
    this.heigth,
    this.width,
    this.onTap, this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Color userColor1 = getUserColor()[1];

    return InkWell(
      onTap: onTap,
      child: Container(
        height: heigth ?? size.height * 0.4,
        width: width ?? size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color ?? userColor1,
            width: 2,
          ),
        ),
        child: Center(
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color?.withOpacity(0.5) ?? userColor1.withOpacity(0.5),
              border: Border.all(
                color: color ?? userColor1,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.add,
              size: 32,
              color: color ?? userColor1,
            ),
          ),
        ),
      ),
    );
  }
}
