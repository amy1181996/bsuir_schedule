import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/view/view_constants.dart';
import 'package:bsuir_schedule/view/widget/schedule_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';

class ScheduleCardWidget extends StatefulWidget {
  final Lesson lesson;
  final ScheduleEntityType scheduleEntityType;

  const ScheduleCardWidget({
    super.key,
    required this.lesson,
    required this.scheduleEntityType,
  });

  @override
  State<ScheduleCardWidget> createState() => _ScheduleCardWidgetState();
}

class _ScheduleCardWidgetState extends State<ScheduleCardWidget> {
  double height = 0;

  @override
  void initState() {
    final lecturers = widget.lesson.lecturers;
    final groups = widget.lesson.studentGroups;

    height = 70;

    if (lecturers.isNotEmpty) {
      height += 35;
    } else if (groups.isNotEmpty) {
      height += 16;
    }

    if (widget.lesson.note != null && widget.lesson.note!.isNotEmpty) {
      height += 23;
    }

    super.initState();
  }

  void _onTap() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return ScheduleBottomSheetWidget(
            lesson: widget.lesson,
            image: null,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: IntrinsicHeight(
        child: Container(
          // height: height,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: getCard(context),
        ),
      ),
    );
  }

  Widget getCard(BuildContext context) {
    final lessonColor =
        ScheduleWidgetConstants.lessonColors[widget.lesson.lessonTypeAbbrev] ??
            Colors.grey;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        getLessonTime(context),
        const SizedBox(
          width: 10,
        ),
        getColoredLine(color: lessonColor, height: height - 20),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getLessonTitle(context),
              const SizedBox(
                height: 5,
              ),
              getLessonAdditionalInfo(context),
              const SizedBox(
                height: 5,
              ),
              if (widget.lesson.note != null && widget.lesson.note!.isNotEmpty)
                getNote(context),
              if (widget.scheduleEntityType == ScheduleEntityType.lecturer)
                getGroupInfo(context)
              else
                getLecturerInfo(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget getLessonTime(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.lesson.startLessonTime,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          widget.lesson.endLessonTime,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget getColoredLine({
    required Color color,
    required double height,
  }) =>
      Container(
        width: 7,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
      );

  Widget getLessonTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.lesson.subject,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: ScheduleWidgetConstants
                      .lessonColors[widget.lesson.lessonTypeAbbrev] ??
                  Colors.grey),
        ),
        Text(
          ScheduleWidgetConstants
                  .lessonsTypeFullName[widget.lesson.lessonTypeAbbrev] ??
              widget.lesson.lessonTypeAbbrev,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: ScheduleWidgetConstants
                      .lessonColors[widget.lesson.lessonTypeAbbrev] ??
                  Colors.grey),
        ),
      ],
    );
  }

  Widget getLessonAdditionalInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getAuditory(context),
        getSubgroupNumber(context),
        getWeeks(context),
        getExamDate(context),
      ],
    );
  }

  Widget getAuditory(BuildContext context) {
    return widget.lesson.auditories.isNotEmpty
        ? Text(
            'ауд. ${widget.lesson.auditories.join(', ')}',
            style: Theme.of(context).textTheme.titleMedium,
          )
        : const SizedBox.shrink();
  }

  Widget getSubgroupNumber(BuildContext context) {
    return widget.lesson.numSubgroup != 0
        ? Text(
            '${widget.lesson.numSubgroup}-я подгруппа',
            style: Theme.of(context).textTheme.titleMedium,
          )
        : const SizedBox.shrink();
  }

  Widget getWeeks(BuildContext context) {
    return widget.lesson.weeks.isNotEmpty
        ? Text(
            'нед. ${widget.lesson.weeks.join(', ')}',
            style: Theme.of(context).textTheme.titleMedium,
          )
        : const SizedBox.shrink();
  }

  Widget getExamDate(BuildContext context) {
    return widget.lesson.dateLesson != null
        ? Text(
            widget.lesson.dateLesson!.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          )
        : const SizedBox.shrink();
  }

  Widget getNote(BuildContext context) {
    return widget.lesson.note != null
        ? Column(
            children: [
              Text(
                widget.lesson.note!,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget getLecturerInfo(BuildContext context) {
    final Lecturer? lecturer = widget.lesson.lecturers.firstOrNull;

    return lecturer != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getEmployeeFIO(context),
              getEmployeePhoto(context: context, radius: 35 / 2, borderSize: 0),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget getGroupInfo(BuildContext context) {
    final groups = widget.lesson.studentGroups;

    return !widget.lesson.subject.toLowerCase().contains('спецп') &&
            !widget.lesson.subject.toLowerCase().contains('физк')
        ? Text(
            groups.map((group) => group.name).join(', '),
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : const SizedBox.shrink();
  }

  Widget getEmployeeFIO(BuildContext context) {
    final lecturer = widget.lesson.lecturers.firstOrNull;

    return lecturer != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lecturer.lastName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '${lecturer.firstName} ${lecturer.middleName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget getEmployeePhoto({
    required BuildContext context,
    required double radius,
    required double borderSize,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey,
      child: CircleAvatar(
        radius: radius - borderSize,
        child: const Icon(Icons.person_2_outlined),
      ),
    );
    // final employees = widget.schedule.employee;

    // if (employees == null || employees.photoLink.isEmpty) {
    //   return Image.asset('assets/images/owl.jpg');
    // }

    // final lessonColor = lessonColors[lesson.lessonTypeAbbrev] ?? Colors.grey;

    // return FutureBuilder(
    //     future: image == null ? _fetchImage(context) : null,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return CircleAvatar(
    //           radius: radius,
    //           child: CircularProgressIndicator(),
    //         );
    //       } else if (snapshot.hasError || image == null) {
    //         return CircleAvatar(
    //           radius: radius,
    //           backgroundColor: lessonColor,
    //           child: CircleAvatar(
    //             radius: radius - borderSize,
    //             backgroundImage: AssetImage(
    //                 'assets/images/owl.jpg'), // Image.asses('assets/images/owl.jpg');
    //           ),
    //         );
    //       } else {
    //         return CircleAvatar(
    //           radius: radius,
    //           backgroundColor: lessonColor,
    //           child: CircleAvatar(
    //             radius: radius - borderSize,
    //             backgroundImage: Image.memory(image!).image,
    //           ),
    //         );
    //       }
    //     });
  }
}
