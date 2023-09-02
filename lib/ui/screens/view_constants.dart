enum ScheduleViewType {
  full,
  dayly,
  exams,
  announcements,
}

enum ScheduleGroupType {
  allGroup,
  firstSubgroup,
  secondSubgroup,
}

enum ScheduleEntityType {
  group,
  lecturer,
}

abstract class ScheduleWidgetConstants {
  static const monthesList = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря'
  ];

  static const weekdayList = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье'
  ];

  static const weekdayAbbrevList = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

  static const Map<String, String> lessonsTypeFullName = {
    'ЛК': 'Лекция',
    'ЛР': 'Лабораторная работа',
    'ПЗ': 'Практическое занятие',
  };
}
