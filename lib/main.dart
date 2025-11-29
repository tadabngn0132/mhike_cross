import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/hike_viewmodel.dart';
import 'views/hike_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HikeViewModel()..loadHikes(),
      child: MaterialApp(
        title: 'Hike SQLite Flutter App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HikeListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
