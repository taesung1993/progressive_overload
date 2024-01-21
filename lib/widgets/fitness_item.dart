import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/designs/Pallete.dart';
import 'package:progressive_overload/designs/Typo.dart';
import 'package:progressive_overload/models/fitness.dart';
import 'package:progressive_overload/widgets/fitness_detail_bottom_sheet.dart';

class FitnessItem extends StatelessWidget {
  const FitnessItem({
    super.key,
    required this.fitness,
  });

  final Fitness fitness;

  void _openFitnessDetailBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (context) {
        return FitnessDetailBottomSheet(
          fitness: fitness,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
        bottom: 16,
        right: 8,
      ),
      decoration: BoxDecoration(
        color: pallete[Pallete.white],
        borderRadius: BorderRadius.circular(10),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              fitness.name,
              style: typos[Typos.T1_500]!.copyWith(
                color: pallete[Pallete.black],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${fitness.set.length} 세트',
                style: typos[Typos.T1_400]!.copyWith(
                  color: pallete[Pallete.black],
                ),
              ),
              const SizedBox(width: 16),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openFitnessDetailBottomSheet(context),
                  child: SvgPicture.asset(
                    'assets/icons/arrow-right-sign-to-navigate.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
