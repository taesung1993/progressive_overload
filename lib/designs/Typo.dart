import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum Typos {
  H1_700,
  H2_600,
  H3_700,
  H3_600,
  H3_500,
  T1_500,
  T1_600,
  T1_400,
  T2_500,
}

const defaultFont = GoogleFonts.roboto;

final Map<Typos, TextStyle> typos = {
  Typos.H1_700: defaultFont(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.08,
  ),
  Typos.H2_600: defaultFont(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  ),
  Typos.H3_700: defaultFont(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.5,
  ),
  Typos.H3_600: defaultFont(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  ),
  Typos.H3_500: defaultFont(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  ),
  Typos.T1_400: defaultFont(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  ),
  Typos.T1_500: defaultFont(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.42,
  ),
  Typos.T1_600: defaultFont(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.42,
  ),
  Typos.T2_500: defaultFont(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  ),
};
