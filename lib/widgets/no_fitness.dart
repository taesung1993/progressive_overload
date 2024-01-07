import 'package:flutter/material.dart';
import 'package:progressive_overload/designs/Pallete.dart';
import 'package:progressive_overload/designs/Typo.dart';

class NoFitness extends StatelessWidget {
  const NoFitness({
    super.key,
    required this.createWorkout,
  });

  final void Function(BuildContext context) createWorkout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Image.asset(
          'assets/images/no_fitness.png',
          fit: BoxFit.fitWidth,
        ),
        const SizedBox(height: 46.91),
        Text(
          '아직 운동을 시작하지 않았어요!',
          style: typos[Typos.H2_600]!.copyWith(
            color: pallete[Pallete.black],
          ),
        ),
        Text(
          '오늘 하루도 힘차게 출발해보아요💪🏻',
          style: typos[Typos.T1_400]!.copyWith(
            color: pallete[Pallete.black],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(28),
          child: ElevatedButton(
            onPressed: () => createWorkout(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: pallete[Pallete.primary1],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
            child: Text(
              '운동 기록하기',
              style: typos[Typos.T1_600]!.copyWith(
                color: pallete[Pallete.white],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
