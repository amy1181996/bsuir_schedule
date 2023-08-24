import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/view_model/group_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:bsuir_schedule/view/widget/group_card.dart';
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
  const _GroupScreenBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final starredGroups =
        Provider.of<GroupScreenViewModel>(context).starredGroups;
    final selectedGroupId =
        Provider.of<RootScreenViewModel>(context).selectedGroupId;
    // final starredGroups = context
    //     .select((GroupScreenViewModel viewModel) => viewModel.starredGroups);
    // final selectedGroupId = context
    //     .select((RootScreenViewModel viewModel) => viewModel.selectedGroupId);

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
                    Text('Избранные группы'),
                    SizedBox(width: 8),
                    Icon(
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
      return const Center(
        child: Text(
          'Тут пока что пусто...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
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
          group: group,
          isSelected: selectedGroupId == group.id,
          onPressed: (Group group) {
            context.read<RootScreenViewModel>().setSelectedGroupId(group.id);
          },
          onDelete: (Group group) {
            final db = context.read<RootScreenViewModel>().db;
            context.read<GroupScreenViewModel>().removeStarredGroup(db, group);
          },
          onUpdate: (Group group) {
            final db = context.read<RootScreenViewModel>().db;
            context.read<GroupScreenViewModel>().updateStarredGroup(db, group);

            if (selectedGroupId == group.id) {
              context.read<RootScreenViewModel>().setSelectedGroupId(group.id);
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

  GroupSearchDelegate({
    required this.allGroups,
    required this.onSelected,
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
    query = query.toLowerCase();

    final groups = allGroups
        .where((group) =>
            group.name.toLowerCase().contains(query) ||
            group.facultyAbbrev.toLowerCase().contains(query) ||
            group.specialityAbbrev.toLowerCase().contains(query) ||
            group.specialityName.toString().contains(query))
        .toList();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return GroupCard(
          group: groups[index],
          isSelected: false,
          onPressed: (Group group) {
            onSelected(group);
            close(context, null);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Добавляю расписание для ${group.name}')));
          },
        );
      },
    );
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

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return GroupCard(
          group: groups[index],
          isSelected: false,
          onPressed: (Group group) {
            onSelected(group);
            close(context, null);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Добавляю расписание для ${group.name}')));
          },
        );
      },
    );
  }
}
