import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/ui/themes/lesson_bottom_sheet_style.dart';
import 'package:bsuir_schedule/ui/screens/view_constants.dart';
import 'package:flutter/material.dart';

class LessonBottomSheet extends StatelessWidget {
  final LessonBottomSheetStyle? style;
  final Lesson lesson;
  final Widget? image;

  const LessonBottomSheet({
    super.key,
    this.style,
    required this.lesson,
    required this.image,
  });

  String _convertDate(DateTime date) {
    return '${date.day} ${ScheduleWidgetConstants.monthesList[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).extension<LessonBottomSheetStyle>()!;

    final titleStyle = style?.titleStyle ?? defaultStyle.titleStyle;
    final bodyStyle = style?.bodyStyle ?? defaultStyle.bodyStyle;
    final padding = style?.padding ?? defaultStyle.padding;

    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          getSubjectName(titleStyle),
          const SizedBox(
            height: 15,
          ),
          if (lesson.lecturers.isNotEmpty)
            getLecturerInfo(bodyStyle, Theme.of(context).primaryColor)
          else
            getGroupInfo(bodyStyle, Theme.of(context).primaryColor),
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                getSubgroupNumber(bodyStyle),
                const SizedBox(height: 5),
                getTimeInfo(bodyStyle),
                const SizedBox(height: 5),
                getDateInfo(bodyStyle),
                const SizedBox(height: 5),
                getAuditoryInfo(bodyStyle),
                const SizedBox(height: 5),
                getNoteInfo(bodyStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSubjectName(TextStyle titleStyle) => Container(
        margin: const EdgeInsets.all(10),
        child: Text(
          lesson.subjectFullName,
          style: titleStyle.copyWith(
              color: ScheduleWidgetConstants
                      .lessonColors[lesson.lessonTypeAbbrev] ??
                  Colors.grey),
        ),
      );

  Widget getAuditoryInfo(TextStyle bodyStyle) =>
      lesson.auditories.where((element) => element.isNotEmpty).isNotEmpty
          ? Row(
              children: [
                const Icon(Icons.map_outlined),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'ауд. ${lesson.auditories.join(',')}',
                  style: bodyStyle,
                ),
              ],
            )
          : const SizedBox.shrink();

  Widget getNoteInfo(TextStyle bodyStyle) =>
      lesson.note != null && lesson.note!.isNotEmpty
          ? Row(
              children: [
                const Icon(Icons.note_outlined),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    lesson.note!,
                    style: bodyStyle,
                    maxLines: 10,
                  ),
                ),
              ],
            )
          : const SizedBox.shrink();

  Widget getSubgroupNumber(TextStyle bodyStyle) => Row(
        children: [
          const Icon(Icons.group_outlined),
          const SizedBox(
            width: 5,
          ),
          Text(
            lesson.numSubgroup != 0
                ? '${lesson.numSubgroup}-я подгруппа'
                : 'вся группа',
            style: bodyStyle,
          ),
        ],
      );

  Row getTimeInfo(TextStyle bodyStyle) => Row(
        children: [
          const Icon(Icons.timelapse_outlined),
          const SizedBox(
            width: 5,
          ),
          Text(
            '${lesson.startLessonTime} - ${lesson.endLessonTime}',
            style: bodyStyle,
          ),
        ],
      );

  Row getDateInfo(TextStyle bodyStyle) => Row(
        children: [
          const Icon(Icons.calendar_month_outlined),
          const SizedBox(
            width: 5,
          ),
          Text(
            'с ${_convertDate(lesson.startLessonDate)} по ${_convertDate(lesson.endLessonDate)}',
            style: bodyStyle,
          ),
          Expanded(child: Container()),
          if (lesson.weeks.isNotEmpty)
            Text(
              'нед. ${lesson.weeks.join(', ')}',
              style: bodyStyle,
            )
        ],
      );

  Widget getGroupInfo(TextStyle bodyStyle, Color backgroundColor) {
    final groups = lesson.studentGroups;

    if (groups.isEmpty ||
        lesson.subject.toLowerCase().contains('спецп') &&
            lesson.subject.toLowerCase().contains('физк')) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 75,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                groups.map((group) => group.name).join(', '),
                style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${groups.first.facultyAbbrev} ${groups.first.specialityAbbrev}',
                style: bodyStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          const CircleAvatar(
            child: Icon(Icons.group_outlined),
          )
        ],
      ),
    );
  }

  Widget getLecturerInfo(TextStyle bodyStyle, Color backgroundColor) {
    final lecturer = lesson.lecturers.firstOrNull;

    if (lecturer == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 75,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lecturer.lastName,
                style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${lecturer.firstName} ${lecturer.middleName}',
                style: bodyStyle,
              ),
            ],
          ),
          if (image != null) ...[
            image!,
          ]
        ],
      ),
    );
  }
}