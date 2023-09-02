import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/view_model/group_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:bsuir_schedule/ui/themes/app_text_theme.dart';
import 'package:bsuir_schedule/ui/widget/group_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  late Future<bool> _dataFetched;

  @override
  void initState() {
    _dataFetched = Provider.of<GroupScreenViewModel>(context, listen: false)
        .fetchData(Provider.of<RootScreenViewModel>(context, listen: false).db);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _dataFetched,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const _GroupScreenBodyWidget();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class _GroupScreenBodyWidget extends StatelessWidget {
  static const _cardKeyMixin = 'group_screen_body_widget_card_key_';

  const _GroupScreenBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final starredGroups =
        Provider.of<GroupScreenViewModel>(context).starredGroups;
    final selectedGroupId =
        Provider.of<RootScreenViewModel>(context).selectedGroupId;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (
          BuildContext context,
          bool innerBoxIsScrolled,
        ) =>
            <Widget>[
          SliverAppBar(
              forceElevated: true,
              expandedHeight: 100,
              pinned: true,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Избранные группы',
                      style: Theme.of(context)
                          .extension<AppTextTheme>()!
                          .titleStyle,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ],
                ),
              )),
        ],
        body: getStarred(context, starredGroups, selectedGroupId),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'group_screen_floating_action_button',
        onPressed: () {
          showSearch(
            context: context,
            delegate: GroupSearchDelegate(
              allGroups: context.read<GroupScreenViewModel>().groups,
              onSelected: (Group group) {
                context.read<GroupScreenViewModel>().addStarredGroup(
                      context.read<RootScreenViewModel>().db,
                      group,
                    );
              },
              onRefresh: () => context
                  .read<GroupScreenViewModel>()
                  .updateGroups(context.read<RootScreenViewModel>().db),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getStarred(
    BuildContext context,
    List<Group> starredGroups,
    int? selectedGroupId,
  ) {
    if (starredGroups.isEmpty) {
      final textTheme = Theme.of(context).extension<AppTextTheme>()!;
      final textStyle = textTheme.bodyStyle;

      return Center(
        child: Text(
          'Тут пока что пусто...',
          style: textStyle,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: starredGroups.length,
      itemBuilder: (context, index) {
        final group = starredGroups[index];
        return GroupCard(
          key: ValueKey(group.hashCode ^ _cardKeyMixin.hashCode),
          group: group,
          isSelected: selectedGroupId == group.id,
          onPressed: (Group group) {
            context.read<RootScreenViewModel>().setSelectedGroupId(group.id);
          },
          onDelete: (Group group) {
            final db = context.read<RootScreenViewModel>().db;
            Provider.of<GroupScreenViewModel>(context, listen: false)
                .removeStarredGroup(db, group);

            final selectedGroupId =
                Provider.of<RootScreenViewModel>(context, listen: false)
                    .selectedGroupId;

            if (selectedGroupId == group.id) {
              Provider.of<RootScreenViewModel>(context, listen: false)
                  .setSelectedGroupId(null);
            }
          },
          onUpdate: (Group group) {
            final db =
                Provider.of<RootScreenViewModel>(context, listen: false).db;

            Provider.of<GroupScreenViewModel>(context, listen: false)
                .updateStarredGroup(db, group);

            if (selectedGroupId == group.id) {
              Provider.of<RootScreenViewModel>(context, listen: false)
                  .setSelectedGroupId(group.id);
            }
          },
        );
      },
    );
  }
}

class GroupSearchDelegate extends SearchDelegate {
  final List<Group> allGroups;
  final Function(Group) onSelected;
  final Future<void> Function() onRefresh;

  static const _cardKeyMixin = 'group_search_delegate_card_key_';

  GroupSearchDelegate({
    required this.allGroups,
    required this.onSelected,
    required this.onRefresh,
    super.searchFieldLabel = 'Поиск',
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final groups = allGroups
        .where((group) =>
            group.name.toLowerCase().contains(query) ||
            group.facultyAbbrev.toLowerCase().contains(query) ||
            group.specialityAbbrev.toLowerCase().contains(query) ||
            group.specialityName.toString().contains(query))
        .toList();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];

          return GroupCard(
            key: ValueKey(group.hashCode ^ _cardKeyMixin.hashCode),
            group: group,
            isSelected: false,
            onPressed: (Group group) {
              onSelected(group);
              close(context, null);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Добавляю расписание для ${group.name}')));
            },
          );
        },
      ),
    );
  }
}
