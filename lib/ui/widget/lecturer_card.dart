import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/ui/themes/app_text_theme.dart';
import 'package:bsuir_schedule/ui/themes/lecturer_card_style.dart';
import 'package:flutter/material.dart';

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
    final bodyStyle = Theme.of(context).extension<AppTextTheme>()!.bodyStyle;
    final backgroundColor =
        style?.backgroundColor ?? defaultStyle.backgroundColor;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      onLongPressStart: (onDelete == null && onUpdate == null)
          ? null
          : (details) => showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                ),
                items: [
                  if (onDelete != null)
                    PopupMenuItem(
                      onTap: () => onDelete!(lecturer),
                      child: Row(children: [
                        const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        Text(
                          'Удалить',
                          style: bodyStyle.copyWith(color: Colors.red),
                        )
                      ]),
                    ),
                  if (onUpdate != null)
                    PopupMenuItem(
                      onTap: () => onUpdate!(lecturer),
                      child: Row(children: [
                        const Icon(
                          Icons.update_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          'Обновить',
                          style: bodyStyle,
                        )
                      ]),
                    )
                ],
              ),
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
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
                      Icon(
                        Icons.remove_red_eye_outlined,
                        color: Theme.of(context).primaryColor,
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
    );
  }
}
