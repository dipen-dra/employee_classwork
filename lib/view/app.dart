import 'package:employee_classwork/view/employee_view.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EmployeeView(),
      debugShowCheckedModeBanner: false, 
    );
  }
}