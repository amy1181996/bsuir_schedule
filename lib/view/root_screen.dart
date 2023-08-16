import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:bsuir_schedule/view/group_screen.dart';
import 'package:bsuir_schedule/view/lecturer_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RootScreenViewModel>(
        builder: (context, viewModel, child) {
          return FutureBuilder(
            future: viewModel.init(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return IndexedStack(
                  index: _currentIndex,
                  children: const [
                    GroupScreen(),
                    LecturerScreen(),
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
            icon: Icon(Icons.group),
            label: 'Группы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Преподаватели',
          ),
        ],
      ),
    );
  }
}
