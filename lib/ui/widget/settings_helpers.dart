import 'package:flutter/material.dart';

import '../themes/app_text_theme.dart';
import '../themes/settings_theme.dart';

class SettingsItem extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? leading;
  final Widget title;
  final Widget? trailing;

  const SettingsItem({
    Key? key,
    required this.onPressed,
    this.leading,
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
            const Spacer(),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(
                width: 15,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SettingsSwitch extends StatelessWidget {
  final bool value;
  final Widget? leading;
  final Widget title;
  final Function(bool)? onChanged;

  const SettingsSwitch({
    super.key,
    required this.value,
    this.leading,
    required this.title,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const SizedBox(width: 15),
          if (leading != null) leading!,
          title,
          const Spacer(),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class SettingsSelectorItem<T> {
  final Widget? trailing;
  final String name;
  final T value;
  final VoidCallback? onPressed;

  SettingsSelectorItem({
    this.trailing,
    required this.name,
    required this.value,
    this.onPressed,
  });

  SettingsSelectorItem<T> copyWith({
    Widget? trailing,
    String? name,
    T? value,
    VoidCallback? onPressed,
  }) {
    return SettingsSelectorItem<T>(
      name: name ?? this.name,
      value: value ?? this.value,
      trailing: trailing ?? this.trailing,
      onPressed: onPressed ?? this.onPressed,
    );
  }
}

class SettingsSelector<T> extends StatefulWidget {
  final Widget? leading;
  final Widget title;
  final List<SettingsSelectorItem<T>> items;
  final T? currentValue;

  const SettingsSelector({
    super.key,
    required this.leading,
    required this.title,
    required this.items,
    this.currentValue,
  });

  @override
  State<SettingsSelector<T>> createState() => _SettingsSelectorState<T>();
}

class _SettingsSelectorState<T> extends State<SettingsSelector<T>> {
  SettingsSelectorItem<T>? _currentRecord;

  @override
  Widget build(BuildContext context) {
    _currentRecord ??= widget.items
        .where(
          (element) => element.value == widget.currentValue,
        )
        .firstOrNull;

    return SettingsItem(
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
                    value: widget.items[index].value,
                    groupValue: _currentRecord?.value ?? widget.items.first,
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
                          color: Theme.of(context)
                              .extension<SettingsTheme>()!
                              .menuColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        children: [
                          Text(
                            widget.items[index].name,
                            style: Theme.of(context)
                                .extension<AppTextTheme>()!
                                .bodyStyle,
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
              style: Theme.of(context).extension<AppTextTheme>()!.bodyStyle,
            )
          : null,
    );
  }
}

class SettingsBlock extends StatelessWidget {
  final Widget title;
  final List<Widget> items;
  final Color backgroundColor;

  const SettingsBlock({
    Key? key,
    required this.title,
    required this.items,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
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
