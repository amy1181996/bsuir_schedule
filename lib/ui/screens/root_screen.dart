import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:bsuir_schedule/ui/screen_factory/screen_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RootScreenViewModel(),
      child: const _RootScreenBody(),
    );
  }
}

class _RootScreenBody extends StatefulWidget {
  const _RootScreenBody({super.key});

  @override
  State<_RootScreenBody> createState() => _RootScreenBodyState();
}

class _RootScreenBodyState extends State<_RootScreenBody> {
  int _currentIndex = 0;
  late Future<bool> _dataFetched;
  final _screenFactory = ScreenFactory();

  @override
  void initState() {
    _dataFetched =
        Provider.of<RootScreenViewModel>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<RootScreenViewModel>(
          builder: (context, viewModel, child) {
            return FutureBuilder(
              future: _dataFetched,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return IndexedStack(
                    index: _currentIndex,
                    children: [
                      _screenFactory.makeScheduleScreen(),
                      _screenFactory.makeLecturerScreen(),
                      _screenFactory.makeGroupScreen(),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Расписание',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              label: 'Преподаватели',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined),
              label: 'Группы',
            ),
          ],
        ),
      ),
    );
  }
}
