import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shlokasaar/screens/home_screen.dart';
import 'blocs/shloka_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> ShlokaBloc())
      ],
      child: MaterialApp(
        title: 'ShlokaSaar',
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            useMaterial3: true
        ),
        home: HomeScreen(),
      ),
    );
  }
}
