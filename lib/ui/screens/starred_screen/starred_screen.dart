import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StarredScreen<T> extends StatefulWidget {
  final Future<bool> Function(BuildContext, dynamic) fetchData;
  final Widget Function(BuildContext, List<T>, T?) buildBody;
  final void Function(BuildContext, T) onPressed;
  final void Function(BuildContext, T) onDelete;
  final Future<void> Function(BuildContext, T, T?) onUpdate;
  final void Function(BuildContext) onSearch;

  const StarredScreen({
    Key? key,
    required this.fetchData,
    required this.buildBody,
    required this.onPressed,
    required this.onDelete,
    required this.onUpdate,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<StarredScreen<T>> createState() => _StarredScreenState<T>();
}

class _StarredScreenState<T> extends State<StarredScreen<T>> {
  late Future<bool> _dataFetched;

  @override
  void initState() {
    _dataFetched = widget.fetchData(context, context.read());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dataFetched,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.buildBody(
            context,
            context.read<List<T>>(),
            context.read<T?>(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class StarredScreenBodyWidget<T> extends StatelessWidget {
  static const _cardKeyMixin = 'starred_screen_body_widget_card_key_';

  final void Function(BuildContext, T) _onPressed;
  final void Function(BuildContext, T) _onDelete;
  final Future<void> Function(BuildContext, T, T?) _onUpdate;

  const StarredScreenBodyWidget({
    Key? key,
    required void Function(BuildContext, T) onPressed,
    required void Function(BuildContext, T) onDelete,
    required Future<void> Function(BuildContext, T, T?) onUpdate,
  })   : _onPressed = onPressed,
        _onDelete = onDelete,
        _onUpdate = onUpdate,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // ... (remaining code is the same)
    return const Placeholder();
  }
}
