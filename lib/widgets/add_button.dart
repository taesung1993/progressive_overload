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
  final double iconSize;
  final Pallete iconBackgroundColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: pallete[iconBackgroundColor],
        shape: BoxShape.circle,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(1000.0),
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(iconSize * (19 / 18)),
          child: SvgPicture.asset(
            'assets/icons/plus.svg',
            width: iconSize,
            height: iconSize,
          ),
        ),
      ),
    );
  }
}
