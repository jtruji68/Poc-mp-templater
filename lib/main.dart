import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_mp_templater/screens/form_date.dart';
import 'cubits/form_cubit.dart'; // Cubit import
import 'models/contract_form_state.dart'; // State import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contract Generator new Title',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (_) => FormCubit(),
        child: const FormPage(),
      ),
    );
  }
}
