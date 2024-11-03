import 'package:flutter/material.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/typo.dart';

class ConfirmDialog extends StatelessWidget {
  final Function()? onCancel;
  final Function()? onConfirm;
  final String title;
  final String description;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.description,
    this.onCancel,
    this.onConfirm,
  });

  void _onCancel(BuildContext context) async {
    if (onCancel != null) {
      await onCancel!();
    }
    Navigator.pop(context);
  }

  void _onConfirm(BuildContext context) async {
    if (onConfirm != null) {
      await onConfirm!();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      insetPadding: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      backgroundColor: white,
      child: SizedBox(
        width: 288,
        height: 133,
        child: Column(
          children: [
            Container(
              width: 288,
              height: 86,
              padding: const EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Typo.headingThreeBold(title, color: black),
                  Typo.TextOneRegular(description, color: black),
                ],
              ),
            ),
            Container(height: 1, width: 288, color: darkgrey),
            Row(
              children: [
                Expanded(
                  child: Ink(
                    height: 46,
                    child: InkWell(
                      child: Center(
                        child:
                            Typo.headingThreeMedium('취소', color: primary1Color),
                      ),
                      onTap: () => _onCancel(context),
                    ),
                  ),
                ),
                Container(
                  height: 46,
                  width: 1,
                  color: darkgrey,
                ),
                Expanded(
                  child: Ink(
                    height: 46,
                    child: InkWell(
                      child: Center(
                        child: Typo.headingThreeMedium('삭제하기',
                            color: primary1Color),
                      ),
                      onTap: () => _onConfirm(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
