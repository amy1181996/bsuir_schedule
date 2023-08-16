import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/view_model/lecturer_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LecturerScreen extends StatefulWidget {
  const LecturerScreen({super.key});

  @override
  State<LecturerScreen> createState() => _LecturerScreenState();
}

class _LecturerScreenState extends State<LecturerScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LecturerScreenViewModel(),
      child: const _LecturerScreenBody(),
    );
  }
}

class _LecturerScreenBody extends StatefulWidget {
  const _LecturerScreenBody({super.key});

  @override
  State<_LecturerScreenBody> createState() => _LecturerScreenBodyState();
}

class _LecturerScreenBodyState extends State<_LecturerScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<LecturerScreenViewModel>(
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

  ListView getBody(LecturerScreenViewModel viewModel) {
    final List<Lecturer> starredLecturers = viewModel.starredLecturers;
    final List<Lecturer> lecturers = viewModel.lecturers;

    List<Widget> children = [
      const SizedBox(height: 16),
      if (starredLecturers.isNotEmpty) ...[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Избранные',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...starredLecturers.map((e) => ListTile(
              title: Text('${e.firstName} ${e.middleName} ${e.lastName}'),
            )),
        const SizedBox(height: 16),
      ],
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Все',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 8),
      ...lecturers.map((e) => GestureDetector(
            onTap: () => _onTap(e),
            child: ListTile(
              title: Text('${e.firstName} ${e.middleName} ${e.lastName}'),
            ),
          ))
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
    );
  }

  void _onTap(Lecturer group) {
    Provider.of<LecturerScreenViewModel>(context, listen: false)
        .addStarredLecturer(
            Provider.of<RootScreenViewModel>(context, listen: false).db, group);
  }
}
