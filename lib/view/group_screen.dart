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
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: viewModel.groups.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(viewModel.groups[index].name),
                  );
                },
              );
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
}
