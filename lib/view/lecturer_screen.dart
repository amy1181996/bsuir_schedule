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
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: viewModel.lecturers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${viewModel.lecturers[index].firstName} ${viewModel.lecturers[index].middleName} ${viewModel.lecturers[index].lastName}'),
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
