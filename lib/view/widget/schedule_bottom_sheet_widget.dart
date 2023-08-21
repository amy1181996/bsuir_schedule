import 'dart:typed_data';

import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/view/view_constants.dart';
import 'package:flutter/material.dart';

class ScheduleBottomSheetWidget extends StatefulWidget {
  final Lesson lesson;
  final Uint8List? image;

  const ScheduleBottomSheetWidget({
    super.key,
    required this.lesson,
    required this.image,
  });

  @override
  State<ScheduleBottomSheetWidget> createState() =>
      _ScheduleBottomSheetWidgetState();
}

class _ScheduleBottomSheetWidgetState extends State<ScheduleBottomSheetWidget> {
  String _convertDate(String date) {
    // final dateData = DateFormat('dd.MM.yyyy').parse(date);
    final dateData = DateTime.parse(date);
    return '${dateData.day} ${ScheduleWidgetConstants.monthesList[dateData.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final globalTextStyle = Theme.of(context).textTheme.titleMedium!;
    final textStyle = TextStyle(
      color: ScheduleWidgetConstants
              .lessonColors[widget.lesson.lessonTypeAbbrev] ??
          Colors.grey,
      fontSize: globalTextStyle.fontSize,
      fontWeight: globalTextStyle.fontWeight,
    );

    final lessonPeriodStr =
        'с ${_convertDate(widget.lesson.startLessonDate.toString())} по ${_convertDate(widget.lesson.endLessonDate.toString())}'
            .toLowerCase();

    return Container(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              widget.lesson.subjectFullName,
              style: textStyle,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          getEmployeeInfo(context),
          getGroupInfo(context),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.group_outlined),
                    SizedBox(
                      width: 5,
                    ),
                    getSubgroupNumber(context),
                  ],
                ),
                SizedBox(height: 5),
                getTimeInfo(context),
                SizedBox(height: 5),
                getDateInfo(lessonPeriodStr, context),
                SizedBox(height: 5),
                getAuditoryInfo(context),
                SizedBox(height: 5),
                getNoteInfo(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row getAuditoryInfo(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.map_outlined),
        SizedBox(
          width: 5,
        ),
        getAuditory(context),
      ],
    );
  }

  RenderObjectWidget getNoteInfo(BuildContext context) {
    return widget.lesson.note != null
        ? Row(
            children: [
              Icon(Icons.note_outlined),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.lesson.note!,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          )
        : SizedBox.shrink();
  }

  Widget getSubgroupNumber(BuildContext context) {
    return widget.lesson.numSubgroup != 0
        ? Text(
            '${widget.lesson.numSubgroup}-я подгруппа',
            style: Theme.of(context).textTheme.displayMedium,
          )
        : Text(
            'вся группа',
            style: Theme.of(context).textTheme.displayMedium,
          );
  }

  Row getTimeInfo(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.timelapse_outlined),
        const SizedBox(
          width: 5,
        ),
        Text(
          '${widget.lesson.startLessonTime} - ${widget.lesson.endLessonTime}',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ],
    );
  }

  Row getDateInfo(String lessonPeriodStr, BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_month_outlined),
        const SizedBox(
          width: 5,
        ),
        Text(
          lessonPeriodStr,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        Expanded(child: Container()),
        getWeeks(context),
      ],
    );
  }

  Widget getGroupInfo(BuildContext context) {
    final groups = widget.lesson.studentGroups;

    if (groups.isNotEmpty ||
        widget.lesson.subject.toLowerCase().contains('спецп') &&
            widget.lesson.subject.toLowerCase().contains('физк')) {
      return SizedBox.shrink();
    }

    return Container(
      height: 75,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                groups.map((group) => group.name).join(', '),
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${groups.first.facultyAbbrev} ${groups.first.specialityAbbrev}',
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          CircleAvatar(
            child: Icon(Icons.group_outlined),
          )
        ],
      ),
    );
  }

  Widget getEmployeeInfo(BuildContext context) {
    final lecturer = widget.lesson.lecturers.firstOrNull;

    if (lecturer == null) {
      return SizedBox.shrink();
    }

    return Container(
      height: 75,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
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
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${lecturer.firstName} ${lecturer.middleName}',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
          getEmployeePhoto(
            context: context,
            radius: 50 / 2,
            borderSize: 2,
          ),
        ],
      ),
    );
  }

  Widget getEmployeePhoto({
    required BuildContext context,
    required double radius,
    required double borderSize,
  }) {
    final employees = widget.lesson.lecturers.firstOrNull;

    if (employees == null) {
      return Image.asset('assets/images/owl.jpg');
    }

    final lessonColor =
        ScheduleWidgetConstants.lessonColors[widget.lesson.lessonTypeAbbrev] ??
            Colors.grey;

    return widget.image == null
        ? CircleAvatar(
            radius: radius,
            backgroundColor: lessonColor,
            child: CircleAvatar(
              radius: radius - borderSize,
              backgroundImage: AssetImage(
                  'assets/images/owl.jpg'), // Image.asses('assets/images/owl.jpg');
            ),
          )
        : CircleAvatar(
            radius: radius,
            backgroundColor: lessonColor,
            child: CircleAvatar(
              radius: radius - borderSize,
              backgroundImage: Image.memory(widget.image!).image,
            ),
          );
  }

  Widget getWeeks(BuildContext context) {
    return widget.lesson.weeks.isNotEmpty
        ? Text(
            'нед. ${widget.lesson.weeks.join(', ')}',
            style: Theme.of(context).textTheme.displayMedium,
          )
        : const SizedBox.shrink();
  }

  Widget getAuditory(BuildContext context) {
    return widget.lesson.auditories.isNotEmpty
        ? Text(
            'ауд. ${widget.lesson.auditories.join(',')}',
            style: Theme.of(context).textTheme.displayMedium,
          )
        : const SizedBox.shrink();
  }
}
