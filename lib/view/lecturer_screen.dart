import 'dart:typed_data';

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
  late Future<bool> _dataFetched;

  @override
  void initState() {
    _dataFetched = Provider.of<LecturerScreenViewModel>(context, listen: false)
        .fetchData(Provider.of<RootScreenViewModel>(context, listen: false).db);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<LecturerScreenViewModel>(
      builder: (context, viewModel, child) {
        return Stack(
          children: [
            FutureBuilder(
              future: _dataFetched,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return getBody(viewModel);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
              ),
              child: TextField(
                keyboardType: TextInputType.name,
                controller: viewModel.searchController,
                decoration: const InputDecoration(
                  hintText: 'Поиск...',
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(15.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
              ),
            ),
          ],
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
        ...starredLecturers.map((e) => GestureDetector(
              key: ValueKey(e.id),
              onTap: () => {
                Provider.of<RootScreenViewModel>(context, listen: false)
                    .setSelectedLecturerId(e.id)
              },
              child: LecturerCard(
                context: context,
                lecturer: e,
                isEditable: true,
              ),
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
            key: ValueKey(e.id),
            onTap: () => _onTap(e),
            child: LecturerCard(
              context: context,
              lecturer: e,
              isEditable: false,
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

  void _onTap(Lecturer lecturer) {
    Provider.of<LecturerScreenViewModel>(context, listen: false)
        .addStarredLecturer(
            Provider.of<RootScreenViewModel>(context, listen: false).db,
            lecturer);
    Provider.of<RootScreenViewModel>(context, listen: false)
        .setSelectedLecturerId(lecturer.id);
  }
}

class LecturerCard extends StatefulWidget {
  final BuildContext context;
  final Lecturer lecturer;
  final bool isEditable;

  const LecturerCard({
    Key? key,
    required this.context,
    required this.lecturer,
    required this.isEditable,
  }) : super(key: key);

  @override
  State<LecturerCard> createState() => _LecturerCardState();
}

class _LecturerCardState extends State<LecturerCard> {
  Uint8List? photo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FutureBuilder(
          future: _fetchImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                photo != null) {
              return CircleAvatar(
                radius: 16,
                foregroundImage: Image.memory(photo!).image,
              );
            } else {
              return const CircleAvatar(
                radius: 16,
                child: CircularProgressIndicator(),
              );
            }
          }),
      title: Text(
          '${widget.lecturer.firstName} ${widget.lecturer.middleName} ${widget.lecturer.lastName}'),
      trailing: SizedBox(
        width: 65,
        child: Row(
          children: [
            if (widget.isEditable) ...[
              IconButton(
                icon: const Icon(Icons.star),
                onPressed: () => Provider.of<LecturerScreenViewModel>(context,
                        listen: false)
                    .removeStarredLecturer(
                        Provider.of<RootScreenViewModel>(context, listen: false)
                            .db,
                        widget.lecturer),
              ),
              if (Provider.of<RootScreenViewModel>(context)
                      .selectedLecturerId ==
                  widget.lecturer.id) ...[
                const Icon(Icons.check),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _fetchImage() async {
    photo ??= await Provider.of<LecturerScreenViewModel>(widget.context,
            listen: false)
        .getLecturerPhoto(widget.lecturer.photoPath);
  }
}
