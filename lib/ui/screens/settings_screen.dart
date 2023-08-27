import 'package:bsuir_schedule/application/settings/models/app_settings.dart';
import 'package:bsuir_schedule/application/settings/settings_provider.dart';
import 'package:bsuir_schedule/ui/themes/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _AppTheme {
  light,
  dark,
  system,
  byDefault,
}

enum _AppIcon {
  light,
  dark,
  pride,
  byDefault,
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).extension<AppTextTheme>()!.bodyStyle;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (
          BuildContext context,
          bool innerBoxIsScrolled,
        ) =>
            <Widget>[
          const SliverAppBar(
              expandedHeight: 100,
              pinned: true,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Настройки'),
                    SizedBox(width: 8),
                    Icon(
                      Icons.settings_outlined,
                    ),
                  ],
                ),
              )),
        ],
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            getColorsSettings(context, bodyStyle),
            const SizedBox(
              height: 10,
            ),
            getThemeSettings(context, bodyStyle),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }

  Widget getColoredBox(Color color) => Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
      );

  Widget getColorsSettings(BuildContext context, TextStyle bodyStyle) {
    final Map<LessonColor, Color> lessonColorToColor = {
      LessonColor.red: Colors.red,
      LessonColor.amber: Colors.amber,
      LessonColor.yellowAccent: Colors.yellowAccent,
      LessonColor.green: Colors.green,
      LessonColor.blue: Colors.blue,
      LessonColor.purple: Colors.purple,
      LessonColor.violet: const Color.fromARGB(255, 135, 8, 190),
      LessonColor.grey: Colors.grey,
    };

    final colorSwitcherItems = <_SettingsSwitcherItem<LessonColor>>[
      _SettingsSwitcherItem(
        name: 'Красный',
        value: LessonColor.red,
        trailing: getColoredBox(Colors.red),
      ),
      _SettingsSwitcherItem(
        name: 'Янтарный',
        value: LessonColor.amber,
        trailing: getColoredBox(Colors.amber),
      ),
      _SettingsSwitcherItem(
        name: 'Желтый',
        value: LessonColor.yellowAccent,
        trailing: getColoredBox(Colors.yellowAccent),
      ),
      _SettingsSwitcherItem(
        name: 'Зеленый',
        value: LessonColor.green,
        trailing: getColoredBox(Colors.green),
      ),
      _SettingsSwitcherItem(
        name: 'Голубой',
        value: LessonColor.blue,
        trailing: getColoredBox(Colors.blue),
      ),
      _SettingsSwitcherItem(
        name: 'Пурпурный',
        value: LessonColor.purple,
        trailing: getColoredBox(Colors.purple),
      ),
      _SettingsSwitcherItem(
        name: 'Фиолетовый',
        value: LessonColor.violet,
        trailing: getColoredBox(const Color.fromARGB(255, 135, 8, 190)),
      ),
      _SettingsSwitcherItem(
        name: 'Серый',
        value: LessonColor.grey,
        trailing: getColoredBox(Colors.grey),
      ),
    ];

    return _SettingsBlock(
      title: Text(
        'Цвета',
        style: bodyStyle.copyWith(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
      items: [
        _SettingsSwitcher<LessonColor>(
          leading: getColoredBox(lessonColorToColor[
              Provider.of<SettingsProvider>(context).lectureColor]!),
          title: Text(
            'Лекция',
            style: bodyStyle,
          ),
          items: colorSwitcherItems
              .map((e) => e.copyWith(onPressed: () {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setLectureColor(e.value);
                  }))
              .toList(),
          currentValue: Provider.of<SettingsProvider>(context).lectureColor,
        ),
        _SettingsSwitcher<LessonColor>(
          leading: getColoredBox(lessonColorToColor[
              Provider.of<SettingsProvider>(context).practiceColor]!),
          title: Text(
            'Практическое занятие',
            style: bodyStyle,
          ),
          items: colorSwitcherItems
              .map((e) => e.copyWith(onPressed: () {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setPracticeColor(e.value);
                  }))
              .toList(),
          currentValue: Provider.of<SettingsProvider>(context).practiceColor,
        ),
        _SettingsSwitcher<LessonColor>(
          leading: getColoredBox(lessonColorToColor[
              Provider.of<SettingsProvider>(context).laboratoryColor]!),
          title: Text(
            'Лабораторная',
            style: bodyStyle,
          ),
          items: colorSwitcherItems
              .map((e) => e.copyWith(onPressed: () {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setLaboratoryColor(e.value);
                  }))
              .toList(),
          currentValue: Provider.of<SettingsProvider>(context).laboratoryColor,
        ),
        _SettingsSwitcher<LessonColor>(
          leading: getColoredBox(lessonColorToColor[
              Provider.of<SettingsProvider>(context).consultColor]!),
          title: Text(
            'Консультация',
            style: bodyStyle,
          ),
          items: colorSwitcherItems
              .map((e) => e.copyWith(onPressed: () {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setConsultColor(e.value);
                  }))
              .toList(),
          currentValue: Provider.of<SettingsProvider>(context).consultColor,
        ),
        _SettingsSwitcher<LessonColor>(
          leading: getColoredBox(lessonColorToColor[
              Provider.of<SettingsProvider>(context).examColor]!),
          title: Text(
            'Экзамен',
            style: bodyStyle,
          ),
          items: colorSwitcherItems
              .map((e) => e.copyWith(onPressed: () {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setExamColor(e.value);
                  }))
              .toList(),
          currentValue: Provider.of<SettingsProvider>(context).examColor,
        ),
        _SettingsSwitcher<LessonColor>(
          leading: getColoredBox(lessonColorToColor[
              Provider.of<SettingsProvider>(context).unknownColor]!),
          title: Text(
            'Неизвестно',
            style: bodyStyle,
          ),
          items: colorSwitcherItems
              .map((e) => e.copyWith(onPressed: () {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setUnknownColor(e.value);
                  }))
              .toList(),
          currentValue: Provider.of<SettingsProvider>(context).unknownColor,
        ),
      ],
    );
  }

  Widget getThemeSettings(BuildContext context, TextStyle bodyStyle) =>
      _SettingsBlock(
        title: Text(
          'Внешний вид',
          style: bodyStyle.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: [
          _SettingsSwitcher<_AppTheme>(
            leading: const Icon(Icons.palette_outlined),
            currentValue: _AppTheme.byDefault,
            title: Text(
              'Тема приложения',
              style: bodyStyle,
            ),
            items: [
              _SettingsSwitcherItem(
                  name: 'Тёмная',
                  value: _AppTheme.dark,
                  trailing: const Icon(Icons.dark_mode_outlined),
                  onPressed: () => {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .setTheme(AppColorScheme.dark),
                      }),
              _SettingsSwitcherItem(
                  name: 'Светлая',
                  value: _AppTheme.light,
                  trailing: const Icon(Icons.light_mode_outlined),
                  onPressed: () => {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .setTheme(AppColorScheme.light),
                      }),
              _SettingsSwitcherItem(
                  name: 'Как в системе',
                  value: _AppTheme.system,
                  trailing: const Icon(Icons.auto_mode_outlined)),
              _SettingsSwitcherItem(
                name: 'По умолчанию',
                value: _AppTheme.byDefault,
                onPressed: () => {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .setDefaultTheme(),
                },
              ),
            ],
          ),
          // _SettingsSwitcher<_AppIcon>(
          //   leading: const Icon(Icons.flag_outlined),
          //   title: Text(
          //     'Иконка приложения',
          //     style: bodyStyle,
          //   ),
          //   items: [
          //     _SettingsSwitcherItem(
          //       name: 'Тёмная',
          //       value: _AppIcon.dark,
          //       onPressed: () => {
          //         Provider.of<SettingsProvider>(context, listen: false)
          //             .setAppIcon(AppIcon.dark),
          //       },
          //     ),
          //     _SettingsSwitcherItem(
          //       name: 'Светлая',
          //       value: _AppIcon.light,
          //       onPressed: () => {
          //         Provider.of<SettingsProvider>(context, listen: false)
          //             .setAppIcon(AppIcon.light),
          //       },
          //     ),
          //     _SettingsSwitcherItem(
          //       name: 'Pride',
          //       value: _AppIcon.pride,
          //       onPressed: () => {
          //         Provider.of<SettingsProvider>(context, listen: false)
          //             .setAppIcon(AppIcon.pride),
          //       },
          //     ),
          //     _SettingsSwitcherItem(
          //       name: 'По умолчанию',
          //       value: _AppIcon.byDefault,
          //       onPressed: () => {
          //         Provider.of<SettingsProvider>(context, listen: false)
          //             .setDefaultAppIcon(),
          //       },
          //     ),
          //   ],
          // ),
        ],
      );
}

class _SettingsBlock extends StatelessWidget {
  final Widget title;
  final List<Widget> items;

  const _SettingsBlock({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: title,
          ),
          ...items,
        ],
      ),
    );
  }
}

class _SettingsSwitcher<T> extends StatefulWidget {
  final Widget? leading;
  final Widget title;
  final List<_SettingsSwitcherItem<T>> items;
  final T? currentValue;

  const _SettingsSwitcher({
    super.key,
    required this.leading,
    required this.title,
    required this.items,
    this.currentValue,
  });

  @override
  State<_SettingsSwitcher<T>> createState() => _SettingsSwitcherState<T>();
}

class _SettingsSwitcherState<T> extends State<_SettingsSwitcher<T>> {
  _SettingsSwitcherItem<T>? _currentRecord;

  @override
  Widget build(BuildContext context) {
    _currentRecord ??= widget.items
        .where(
          (element) => element.value == widget.currentValue,
        )
        .firstOrNull;

    return _SettingsItem(
      onPressed: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (context) => Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.items.length,
              (index) => Row(
                children: [
                  Radio(
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    value: widget.items[index].value,
                    groupValue: _currentRecord!.value,
                    onChanged: (value) {
                      if (widget.items[index].onPressed != null) {
                        widget.items[index].onPressed!();
                      }

                      setState(() {
                        _currentRecord = widget.items[index];
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Container(
                      margin:
                          const EdgeInsets.only(right: 20, top: 5, bottom: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        children: [
                          Text(
                            widget.items[index].name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          if (widget.items[index].trailing != null) ...[
                            const Spacer(),
                            widget.items[index].trailing!,
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      leading: widget.leading,
      title: widget.title,
      trailing: _currentRecord != null
          ? Text(
              _currentRecord!.name,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            )
          : null,
    );
  }
}

class _SettingsSwitcherItem<T> {
  final Widget? trailing;
  final String name;
  final T value;
  final VoidCallback? onPressed;

  _SettingsSwitcherItem({
    this.trailing,
    required this.name,
    required this.value,
    this.onPressed,
  });

  _SettingsSwitcherItem<T> copyWith({
    Widget? trailing,
    String? name,
    T? value,
    VoidCallback? onPressed,
  }) {
    return _SettingsSwitcherItem<T>(
      name: name ?? this.name,
      value: value ?? this.value,
      trailing: trailing ?? this.trailing,
      onPressed: onPressed ?? this.onPressed,
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? leading;
  final Widget title;
  final Widget? trailing;

  const _SettingsItem({
    Key? key,
    required this.onPressed,
    required this.leading,
    required this.title,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            if (leading != null) ...[
              leading!,
              const SizedBox(
                width: 10,
              ),
            ],
            title,
            if (trailing != null) ...[
              const Spacer(),
              trailing!,
              const SizedBox(
                width: 15,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
