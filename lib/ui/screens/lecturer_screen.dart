import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/view_model/lecturer_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:bsuir_schedule/ui/themes/app_text_theme.dart';
import 'package:bsuir_schedule/ui/widget/lecturer_card.dart';
import 'package:bsuir_schedule/ui/widget/lecturer_image_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LecturerScreen extends StatefulWidget {
  const LecturerScreen({super.key});

  @override
  State<LecturerScreen> createState() => _LecturerScreenState();
}

class _LecturerScreenState extends State<LecturerScreen> {
  late Future<bool> _dataFetched;

  @override
  void initState() {
    _dataFetched = Provider.of<LecturerScreenViewModel>(context, listen: false)
        .fetchData(Provider.of<RootScreenViewModel>(context, listen: false).db);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _dataFetched,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const _LecturerScreenBodyWidget();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class _LecturerScreenBodyWidget extends StatelessWidget {
  static const _cardKeyMixin = 'lecturer_screen_body_widget_card_key_';

  static final imageFactory = LecturerImageFactory();

  const _LecturerScreenBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final starredLecturers =
        Provider.of<LecturerScreenViewModel>(context).starredLecturers;
    final selectedLecturerId =
        Provider.of<RootScreenViewModel>(context).selectedLecturerId;

    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (
            BuildContext context,
            innerBoxIsScrolled,
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
                      'Избранные преподаватели',
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
              ),
            ),
          ],
          body: getBody(context, starredLecturers, selectedLecturerId),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'lecturer_screen_floating_action_button',
          onPressed: () {
            showSearch(
              context: context,
              delegate: LecturerSearchDelegate(
                allLecturers: context.read<LecturerScreenViewModel>().lecturers,
                onSelected: (lecturer) {
                  context.read<LecturerScreenViewModel>().addStarredLecturer(
                        context.read<RootScreenViewModel>().db,
                        lecturer,
                      );
                },
                onRefresh: () async {
                  await context
                      .read<LecturerScreenViewModel>()
                      .updateLecturers(context.read<RootScreenViewModel>().db);
                },
              ),
            );
          },
          child: const Icon(Icons.add),
        ));
  }

  Widget getBody(
    BuildContext context,
    List<Lecturer> starredLecturers,
    int? selectedLecturerId,
  ) {
    if (starredLecturers.isEmpty) {
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
      itemCount: starredLecturers.length,
      itemBuilder: (context, index) {
        final lecturer = starredLecturers[index];
        return LecturerCard(
          key: ValueKey(lecturer.hashCode ^ _cardKeyMixin.hashCode),
          lecturer: lecturer,
          image: imageFactory.fetchImage(
            radius: 23,
            borderSize: 0,
            lecturer: lecturer,
          ),
          isStarred: selectedLecturerId == lecturer.id,
          onPressed: () {
            context
                .read<RootScreenViewModel>()
                .setSelectedLecturerId(lecturer.id);
          },
          onDelete: (Lecturer lecturer) {
            final db = Provider.of<RootScreenViewModel>(context).db;

            Provider.of<LecturerScreenViewModel>(context)
                .removeStarredLecturer(db, lecturer);

            final selectedLecturerId =
                Provider.of<RootScreenViewModel>(context).selectedLecturerId;

            if (selectedLecturerId == lecturer.id) {
              Provider.of<RootScreenViewModel>(context)
                  .setSelectedLecturerId(null);
            }
          },
          onUpdate: (Lecturer lecturer) {
            final db = Provider.of<RootScreenViewModel>(context).db;

            Provider.of<LecturerScreenViewModel>(context)
                .updateStarredLecturer(db, lecturer);

            if (selectedLecturerId == lecturer.id) {
              Provider.of<RootScreenViewModel>(context)
                  .setSelectedLecturerId(lecturer.id);
            }
          },
        );
      },
    );
  }
}

class LecturerSearchDelegate extends SearchDelegate {
  final List<Lecturer> allLecturers;
  final Function(Lecturer) onSelected;
  final Future<void> Function() onRefresh;

  static const _cardKeyMixin = 'lecturer_search_delegate_card_key_';

  LecturerSearchDelegate({
    required this.allLecturers,
    required this.onSelected,
    required this.onRefresh,
    super.searchFieldLabel = 'Поиск',
  });

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    query = query.toLowerCase();

    final lecturers = allLecturers
        .where((lecturer) =>
            lecturer.firstName.toLowerCase().contains(query) ||
            lecturer.middleName.toLowerCase().contains(query) ||
            lecturer.lastName.toLowerCase().contains(query))
        .toList();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: lecturers.length,
        itemBuilder: (context, index) {
          final lecturer = lecturers[index];

          return LecturerCard(
            key: ValueKey(lecturer.hashCode ^ _cardKeyMixin.hashCode),
            lecturer: lecturer,
            image: const Icon(Icons.person_outline),
            isStarred: false,
            onPressed: () {
              onSelected(lecturer);
              close(context, null);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Добавляю расписание для ${lecturer.lastName}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
