import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/database/workout_repository.dart';
import 'package:progressive_overload/model/workout_model.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/loaded_workout.dart';
import 'package:progressive_overload/widget/typo.dart';

class LoadWorkoutBottomSheet extends StatefulWidget {
  const LoadWorkoutBottomSheet({Key? key}) : super(key: key);

  @override
  _LoadWorkoutBottomSheetState createState() => _LoadWorkoutBottomSheetState();
}

class _LoadWorkoutBottomSheetState extends State<LoadWorkoutBottomSheet> {
  final _controller = TextEditingController();
  int? selectedWorkoutId;
  Future<List<Workout>>? futureWorkouts;

  void _onChange(String value) {
    setState(() {
      _controller.text = value;
    });
  }

  void clear() {
    setState(() {
      _controller.text = '';
    });
  }

  void _onChecked(Workout? workout) {
    if (selectedWorkoutId == workout!.id) {
      setState(() {
        selectedWorkoutId = null;
      });
      return;
    }

    setState(() {
      selectedWorkoutId = workout!.id;
    });
  }

  void _onSearch(String value) async {
    setState(() {
      futureWorkouts = WorkoutRepository().getWorkouts(name: value);
    });
  }

  void _onSubmit(BuildContext context) async {
    final workout = await futureWorkouts!.then((value) {
      return value.firstWhere((element) => element.id == selectedWorkoutId);
    });

    Navigator.pop(context, workout);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: white),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 16),
              height: 56,
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: SearchBar(
                      controller: _controller,
                      backgroundColor: WidgetStateProperty.all(white),
                      constraints: const BoxConstraints(
                        maxHeight: 40,
                        minHeight: 40,
                      ),
                      shape: WidgetStateProperty.all(
                        ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      elevation: const WidgetStatePropertyAll(0),
                      side: WidgetStateProperty.all(
                        const BorderSide(
                          color: grey,
                          width: 1,
                        ),
                      ),
                      hintText: '불러올 운동 이름을 검색하세요.',
                      hintStyle: WidgetStateProperty.all(
                        text1Regular.copyWith(color: grey),
                      ),
                      textStyle: WidgetStateProperty.all(
                        head3Medium.copyWith(color: black),
                      ),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.only(
                          left: 12,
                          right: 0,
                        ),
                      ),
                      trailing: [
                        if (_controller.value.text.isNotEmpty)
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/svg/clear.svg',
                            ),
                            onPressed: clear,
                          )
                      ],
                      onSubmitted: _onSearch,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Typo.TextOneRegular('취소', color: black),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Workout>>(
                  future: futureWorkouts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/error.svg',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 16),
                            Typo.headingThreeMedium(
                              '에러가 발생했습니다.',
                              color: darkgrey,
                            ),
                            Typo.TextOneRegular(
                              '다시 시도해주세요.',
                              color: grey,
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/search.svg',
                              width: 40,
                              height: 40,
                              color: darkgrey,
                            ),
                            const SizedBox(height: 16),
                            Typo.headingThreeMedium(
                              '불러올 운동 이름을 검색해보세요.',
                              color: darkgrey,
                            ),
                            Typo.TextOneRegular(
                              '과거에 등록한 운동을 불러올 수 있습니다.',
                              color: grey,
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/search.svg',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 16),
                            Typo.headingThreeMedium(
                              '"${_controller.text}"에 대한 검색 결과가 없습니다.',
                              color: darkgrey,
                            ),
                            Typo.TextOneRegular(
                              '찾으시는 운동이 없다면 새로운 운동을 등록해보세요.',
                              color: grey,
                            ),
                          ],
                        ),
                      );
                    }

                    final workouts = snapshot.data!;

                    return LayoutBuilder(
                      builder: (context, constrants) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: constrants.maxHeight),
                            child: IntrinsicHeight(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 24, left: 20, right: 20),
                                child: Column(
                                  children: [
                                    for (int i = 0;
                                        i < workouts.length;
                                        i++) ...[
                                      LoadedWorkout(
                                        key: ObjectKey(
                                          workouts[i],
                                        ),
                                        checked:
                                            selectedWorkoutId == workouts[i].id,
                                        onChecked: _onChecked,
                                        workout: workouts[i],
                                      ),
                                      const SizedBox(height: 12),
                                    ]
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 20,
                right: 20,
                bottom: 40,
              ),
              child: Material(
                child: Ink(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: selectedWorkoutId != null ? primary1Color : grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: selectedWorkoutId != null
                        ? () => _onSubmit(context)
                        : null,
                    child: Center(
                      child: Typo.headingThreeBold(
                        '불러오기',
                        color: white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
