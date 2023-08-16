import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/view_model/group_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupScreenViewModel(),
      child: const _GroupScreenBody(),
    );
  }
}

class _GroupScreenBody extends StatefulWidget {
  const _GroupScreenBody({super.key});

  @override
  State<_GroupScreenBody> createState() => _GroupScreenBodyState();
}

class _GroupScreenBodyState extends State<_GroupScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<GroupScreenViewModel>(
      builder: (context, viewModel, child) {
        return FutureBuilder(
          future:
              viewModel.fetchData(Provider.of<RootScreenViewModel>(context).db),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return getBody(viewModel);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    ));
  }

  ListView getBody(GroupScreenViewModel viewModel) {
    final List<Group> starredGroups = viewModel.starredGroups;
    final List<Group> groups = viewModel.groups;

    List<Widget> children = [
      const SizedBox(height: 16),
      if (starredGroups.isNotEmpty) ...[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Избранные',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...starredGroups.map((e) => ListTile(
              title: Text(e.name),
            ))
      ],
      const SizedBox(height: 16),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Все',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 8),
      ...groups.map((e) => GestureDetector(
            onTap: () => _onTap(e),
            child: ListTile(
              title: Text(e.name),
            ),
          )),
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
    );
  }

  void _onTap(Group group) {
    Provider.of<GroupScreenViewModel>(context, listen: false).addStarredGroup(
        Provider.of<RootScreenViewModel>(context, listen: false).db, group);
  }
}
