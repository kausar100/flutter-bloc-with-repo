import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/bloc/product_bloc.dart';
import 'package:hello_flutter/data/repository/products_repo.dart';
import 'package:hello_flutter/screens/app_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ProductsRepository(),
      child: BlocProvider(
        create: (context) => ProductBloc(
            productsRepository:
                RepositoryProvider.of<ProductsRepository>(context)),
        child: MaterialApp(
          title: 'Flutter Bloc',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
            useMaterial3: true,
          ),
          home: const AppScreen(),
        ),
      ),
    );
  }
}
