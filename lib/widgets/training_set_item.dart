import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/designs/Pallete.dart';
import 'package:progressive_overload/designs/Typo.dart';

class TrainingSetItem extends StatelessWidget {
  const TrainingSetItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: pallete[Pallete.white],
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.08),
              offset: Offset(1, 2),
              blurRadius: 11,
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: pallete[Pallete.black],
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Text(
                '1 세트',
                style: typos[Typos.T2_500]!.copyWith(
                  color: pallete[Pallete.white],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 28,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: typos[Typos.T2_500]!.copyWith(
                      color: pallete[Pallete.black],
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(8.0),
                      hintText: '10',
                      hintStyle: typos[Typos.T2_500]!.copyWith(
                        color: const Color(0xffD5D5D5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: pallete[Pallete.grey]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: pallete[Pallete.primary1]!,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'kg',
                  style: typos[Typos.T2_500]!
                      .copyWith(color: pallete[Pallete.black]!),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 28,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: typos[Typos.T2_500]!.copyWith(
                      color: pallete[Pallete.black],
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(8.0),
                      hintText: '10',
                      hintStyle: typos[Typos.T2_500]!.copyWith(
                        color: const Color(0xffD5D5D5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: pallete[Pallete.grey]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: pallete[Pallete.primary1]!,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '회',
                  style: typos[Typos.T2_500]!
                      .copyWith(color: pallete[Pallete.black]!),
                ),
              ],
            ),
            Ink(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: pallete[Pallete.lightGrey2],
              ),
              child: InkWell(
                child: SvgPicture.asset(
                  'assets/icons/trash.svg',
                  width: 16,
                  height: 16,
                ),
              ),
            ),
          ],
        ));
  }
}
