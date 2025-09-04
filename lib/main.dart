import 'package:dental_clinic/modules/statemanagement/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/layout/layout.dart';
void main() {
  runApp(const MyApp());

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dental Clinic',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.white))
        ),
        home:  LayoutScreen(),
      ),
    );
  }
}

