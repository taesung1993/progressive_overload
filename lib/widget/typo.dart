import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progressive_overload/shared/styles.dart';

class Typo extends StatelessWidget {
  final String text;
  final TextStyle style;

  Typo.headingOneBold(this.text, {Color color = primary1Color})
      : style = head1Bold.copyWith(color: color);
  Typo.headingTwoBold(this.text, {Color color = primary1Color})
      : style = head2Bold.copyWith(color: color);
  Typo.headingThreeBold(this.text, {Color color = primary1Color})
      : style = head3Bold.copyWith(color: color);
  Typo.TextOneMedium(this.text, {Color color = primary1Color})
      : style = text1Medium.copyWith(color: color);
  Typo.TextOneRegular(this.text, {Color color = primary1Color})
      : style = text1Regular.copyWith(color: color);
  Typo.TextTwoMedium(this.text, {Color color = primary1Color})
      : style = text2Medium.copyWith(color: color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(textStyle: style),
    );
  }
}
