import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/themes/group_card_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

    return GestureDetector(
      onTap: () => onPressed(group),
      child: Slidable(
        endActionPane: getActionPane(),
        child: Container(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
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
      ),
    );
  }

  ActionPane getActionPane() => ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (onUpdate != null)
            SlidableAction(
              onPressed: (_) => onUpdate!(group),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              icon: Icons.update,
              label: 'Обновить',
            ),
          if (onDelete != null)
            SlidableAction(
              onPressed: (_) => onDelete!(group),
              backgroundColor: Colors.black,
              foregroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Удалить',
            ),
        ],
      );

  Row getCardTitle(TextStyle titleStyle, bool isSelected) => Row(
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
            const Icon(
              Icons.remove_red_eye_outlined,
              color: Colors.white,
            ),
          ]
        ],
      );
}
