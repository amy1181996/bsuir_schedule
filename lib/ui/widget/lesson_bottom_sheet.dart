import 'package:bsuir_schedule/application/settings/models/app_settings.dart';
import 'package:bsuir_schedule/application/settings/settings_provider.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/ui/screens/view_constants.dart';
import 'package:bsuir_schedule/ui/themes/lesson_bottom_sheet_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/model/schedule_descriptor.dart';

class LessonBottomSheet extends StatelessWidget {
  final LessonBottomSheetStyle? style;
  final ScheduleEntityType? scheduleEntityType;
  final Lesson lesson;
  final Widget? image;

  const LessonBottomSheet({
    super.key,
    this.style,
    required this.scheduleEntityType,
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
    final cardColor = style?.cardColor ?? defaultStyle.cardColor;

    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // if (lesson.isAnnouncement)
          //   getAnnouncement(titleStyle)
          // else
            getSubjectName(titleStyle),
          const SizedBox(
            height: 7,
          ),
          if (scheduleEntityType == ScheduleEntityType.group)
            getLecturerInfo(bodyStyle, cardColor)
          else
            getGroupInfo(bodyStyle, cardColor),
          const SizedBox(
            height: 7,
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
                // if (lesson.isAnnouncement == false) ...[
                //   const SizedBox(height: 5),
                //   getNoteInfo(bodyStyle),
                // ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const Map<LessonColor, Color> lessonColorToColor = {
    LessonColor.red: Colors.red,
    LessonColor.amber: Colors.amber,
    LessonColor.yellowAccent: Colors.yellowAccent,
    LessonColor.green: Colors.green,
    LessonColor.blue: Colors.blue,
    LessonColor.purple: Colors.purple,
    LessonColor.violet: Color.fromARGB(255, 135, 8, 190),
    LessonColor.grey: Colors.grey,
  };

  Color getLessonColor(BuildContext context, String lessonAbbrev) =>
      switch (lessonAbbrev) {
        'ЛК' => lessonColorToColor[
            Provider.of<SettingsProvider>(context).lectureColor]!,
        'ЛР' => lessonColorToColor[
            Provider.of<SettingsProvider>(context).laboratoryColor]!,
        'ПЗ' => lessonColorToColor[
            Provider.of<SettingsProvider>(context).practiceColor]!,
        'Консультация' => lessonColorToColor[
            Provider.of<SettingsProvider>(context).consultColor]!,
        'Экзамен' =>
          lessonColorToColor[Provider.of<SettingsProvider>(context).examColor]!,
        'ОБ' => lessonColorToColor[
            Provider.of<SettingsProvider>(context).announcementColor]!,
        _ => lessonColorToColor[
            Provider.of<SettingsProvider>(context).unknownColor]!
      };

  Widget getSubjectName(TextStyle titleStyle) => Builder(
      builder: (context) => Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              lesson.subjectFullName,
              style: titleStyle.copyWith(
                  color: getLessonColor(context, lesson.lessonTypeAbbrev)),
            ),
          ));

  Widget getAnnouncement(TextStyle titleStyle) => Builder(
      builder: (context) => Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              lesson.note!,
              style: titleStyle.copyWith(
                  color: getLessonColor(context, lesson.lessonTypeAbbrev)),
            ),
          ));

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
                const Icon(Icons.announcement_outlined),
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
          if (lesson.dateLesson != null) ...[
            Text(
              _convertDate(lesson.dateLesson!),
              style: bodyStyle,
            ),
          ] else if (lesson.startLessonDate == lesson.endLessonDate && lesson.startLessonDate != null) ...[
            Text(
              _convertDate(lesson.startLessonDate!),
              style: bodyStyle,
            ),
          ] else if (lesson.startLessonDate != null && lesson.endLessonDate != null)...[
            Text(
              'с ${_convertDate(lesson.startLessonDate!)} по ${_convertDate(lesson.endLessonDate!)}',
              style: bodyStyle,
            ),
          ],
          Expanded(child: Container()),
          if (lesson.weeks.isNotEmpty)
            Text(
              'нед. ${lesson.weeks.join(', ')}',
              style: bodyStyle,
            )
        ],
      );

  Widget getGroupInfo(
    TextStyle bodyStyle,
    Color backgroundColor,
  ) {
    final groups = lesson.studentGroups;

    if (groups.isEmpty ||
        lesson.subject.toLowerCase().contains('спецп') &&
            lesson.subject.toLowerCase().contains('физк')) {
      return const SizedBox.shrink();
    }

    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (context) {
              return _ExtendedGroupBottomSheet(
                cardColor: backgroundColor,
                groups: groups,
              );
            }),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
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
                      groups
                          .map((group) =>
                              '${group.facultyAbbrev} ${group.specialityAbbrev}')
                          .join(', '),
                      style: bodyStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const CircleAvatar(
                child: Icon(Icons.group_outlined),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget getLecturerInfo(TextStyle bodyStyle, Color backgroundColor) {
    final lecturer = lesson.lecturers.firstOrNull;

    if (lecturer == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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

class _ExtendedGroupBottomSheet extends StatelessWidget {
  final List<Group> groups;
  final Color cardColor;

  const _ExtendedGroupBottomSheet({
    Key? key,
    required this.groups,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).extension<LessonBottomSheetStyle>()!;

    final bodyStyle = defaultStyle.bodyStyle;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(groups.length, (index) {
          final group = groups[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      group.name,
                      style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${group.facultyAbbrev} ${group.specialityAbbrev}, ${group.course}-й курс',
                      style: bodyStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const Spacer(),
                const CircleAvatar(
                  child: Icon(Icons.group_outlined),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
