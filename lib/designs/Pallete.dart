import 'package:flutter/material.dart';

enum Pallete {
  black,
  darkGrey,
  grey,
  lightGrey,
  lightGrey2,
  white,
  primary1,
  primary2,
  primary3,
  red1,
  red2,
  green1,
  green2,
  blue1,
  blue2
}

const Map<Pallete, Color> pallete = {
  Pallete.black: Color(0xff000000),
  Pallete.darkGrey: Color(0xff9b9b9b),
  Pallete.grey: Color(0xffd5d5d5),
  Pallete.lightGrey: Color(0xfff2f2f2),
  Pallete.lightGrey2: Color(0xfff3f3f3),
  Pallete.white: Color(0xffffffff),
  Pallete.primary1: Color(0xffff6000),
  Pallete.primary2: Color(0xffffd3b9),
  Pallete.primary3: Color(0xfffff3ec),
  Pallete.red1: Color(0xffdb1307),
  Pallete.red2: Color(0xffffb8b4),
  Pallete.green1: Color(0xff34c759),
  Pallete.green2: Color(0xff8ddc9f),
  Pallete.blue1: Color(0xff007aff),
  Pallete.blue2: Color(0xff93c6fc),
};
