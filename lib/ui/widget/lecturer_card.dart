import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/ui/themes/lecturer_card_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LecturerCard extends StatelessWidget {
  final LecturerCardStyle? style;
  final Lecturer lecturer;
  final Widget? image;
  final bool isStarred;
  final VoidCallback? onPressed;
  final Function(Lecturer lecturer)? onDelete;
  final Function(Lecturer lecturer)? onUpdate;

  const LecturerCard({
    Key? key,
    this.style,
    required this.lecturer,
    required this.image,
    required this.isStarred,
    this.onPressed,
    this.onDelete,
    this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).extension<LecturerCardStyle>()!;

    final borderRadius = style?.borderRadius ?? defaultStyle.borderRadius;
    final titleStyle = style?.titleStyle ?? defaultStyle.titleStyle;
    final subtitleStyle = style?.subtitleStyle ?? defaultStyle.subtitleStyle;

    return GestureDetector(
      onTap: onPressed,
      child: Slidable(
        endActionPane: getActionPane(),
        child: Container(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: Row(
            children: [
              if (image != null) ...[
                image!,
                const SizedBox(
                  width: 10,
                ),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        lecturer.lastName,
                        style: titleStyle,
                      ),
                      if (isStarred) ...[
                        const SizedBox(
                          width: 3,
                        ),
                        const Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.white,
                        ),
                      ]
                    ],
                  ),
                  Text(
                    '${lecturer.firstName} ${lecturer.middleName}',
                    style: subtitleStyle,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ActionPane getActionPane() => ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (onUpdate != null) ...[
            SlidableAction(
              onPressed: (_) => onUpdate!(lecturer),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              icon: Icons.update,
              label: 'Обновить',
            ),
          ],
          if (onDelete != null) ...[
            SlidableAction(
              onPressed: (_) => onDelete!(lecturer),
              backgroundColor: Colors.black,
              foregroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Удалить',
            ),
          ],
        ],
      );
}
