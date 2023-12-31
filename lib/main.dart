import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/data/repository/products_repo.dart';
import 'package:hello_flutter/screens/app_screen.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

import 'bloc/internet/internet_connection_bloc.dart';
import 'bloc/product/product_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ProductsRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProductBloc(
                productsRepository:
                    RepositoryProvider.of<ProductsRepository>(context)),
          ),
          BlocProvider(
            create: (context) => InternetConnectionBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Bloc',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
            useMaterial3: true,
          ),
          home: const App(),
        ),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final settingsAndroid = const OpenSettingsPlusAndroid();
  @override
  void initState() {
    context.read<InternetConnectionBloc>().add(InternetInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<InternetConnectionBloc, InternetConnectionState>(
        listener: (context, state) {
          if (state is NotConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                duration: const Duration(days: 1),
                content: const Text('Please check your internet connection!'),
                action: SnackBarAction(
                    label: "Turn on",
                    onPressed: () async {
                      await settingsAndroid.wifi();
                    }),
              ),
            );
          } else if (state is Connected) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Your internet connection is back!'),
              ),
            );
          }
        },
        child: BlocBuilder<InternetConnectionBloc, InternetConnectionState>(
            builder: (context, state) {
          if (state is NotConnected || state is NotChecked) {
            return Center(
              child: Text(
                "No Internet Connection",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          } else {
            return const AppScreen();
          }
        }),
      ),
    );
  }
}
