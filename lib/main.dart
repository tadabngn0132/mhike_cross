import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/hike_provider.dart';
import 'repositories/hike_repository.dart';
import 'services/database_service.dart';
import 'ui/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
// Service providers (singletons)
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),

          dispose: (_, service) => service.close(),
        ),
// Repository providers (depend on services)
        ProxyProvider<DatabaseService, HikeRepository>(
          create: (context) => HikeRepositoryImpl(
            context.read<DatabaseService>(),
          ),
          update: (context, databaseService, _) => HikeRepositoryImpl(
            databaseService,
          ),
        ),
// Provider that depends on repository
        ChangeNotifierProxyProvider<HikeRepository, HikeProvider>(
          create: (context) => HikeProvider(
            context.read<HikeRepository>(),
          )..loadHikes(),
          update: (context, bookRepository, previous) =>
          previous ?? HikeProvider(bookRepository)..loadHikes(),
        ),
      ],
      child: MaterialApp(
        title: 'Hike Library',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
