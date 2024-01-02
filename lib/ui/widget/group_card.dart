import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/ui/themes/app_text_theme.dart';
import 'package:bsuir_schedule/ui/themes/group_card_style.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    Key? key,
    required this.group,
    required this.isSelected,
    required this.onPressed,
    this.onDelete,
    this.onUpdate,
    this.style,
  }) : super(key: key);

  final GroupCardStyle? style;

  final Group group;
  final bool isSelected;
  final Function(Group group) onPressed;
  final Function(Group group)? onDelete;
  final Function(Group group)? onUpdate;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).extension<GroupCardStyle>()!;

    final borderRadius = style?.borderRadius ?? defaultStyle.borderRadius;
    final titleStyle = style?.titleStyle ?? defaultStyle.titleStyle;
    final subtitleStyle = style?.subtitleStyle ?? defaultStyle.subtitleStyle;
    final bodyStyle = Theme.of(context).extension<AppTextTheme>()!.bodyStyle;
    final backgroundColor =
        style?.backgroundColor ?? defaultStyle.backgroundColor;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onPressed(group),
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
                      onTap: () => onDelete!(group),
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
                      onTap: () => onUpdate!(group),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getCardTitle(titleStyle, isSelected),
            Text(
              '${group.facultyAbbrev} ${group.specialityAbbrev}',
              style: subtitleStyle,
            ),
            Text(
              '${group.course}й курс',
              style: subtitleStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget getCardTitle(TextStyle titleStyle, bool isSelected) =>
      Builder(builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              group.name,
              style: titleStyle,
            ),
            if (isSelected) ...[
              const SizedBox(
                width: 3,
              ),
              Icon(
                Icons.remove_red_eye_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ]
          ],
        );
      });
}
