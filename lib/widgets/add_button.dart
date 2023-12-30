import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/designs/Pallete.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    required this.size,
    this.iconSize = 18,
    this.iconBackgroundColor = Pallete.primary1,
    required this.onTap,
  });

  final double size;
  final double? iconSize;
  final Pallete? iconBackgroundColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(size, size),
        backgroundColor: pallete[iconBackgroundColor],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      child: SvgPicture.asset(
        'assets/icons/plus.svg',
        width: iconSize,
        height: iconSize,
      ),
    );
  }
}
