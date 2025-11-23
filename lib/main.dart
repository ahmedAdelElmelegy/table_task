import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_task2/feature/home/presentation/screen/home_screen.dart';
import 'package:table_task2/manager/cubit/table_cubit.dart';

// flutter_multiple_forms_snapping.dart
// A self-contained example demonstrating:
// - 10 stacked forms presented in a snapping PageView (vertical)
// - header that changes based on the active form
// - a multi-select dropdown implemented with a modal
// - validation across all forms at once
// - a left-side DataTable showing saved entries

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TableCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Multi-Form Snapping UI',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
