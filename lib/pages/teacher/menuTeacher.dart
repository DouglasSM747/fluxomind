import 'package:flutter/material.dart';
import 'package:fluxoMind/widgets/AppWidget.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuTeacher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.gloriaHallelujahTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: "Menu Screen",
      home: MenuTeacherPage(),
    );
  }
}

class MenuTeacherPage extends StatefulWidget {
  @override
  _MenuTeacherPageState createState() => _MenuTeacherPageState();
}

class _MenuTeacherPageState extends State<MenuTeacherPage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widhScreen = MediaQuery.of(context).size.width - 30;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(height: 80),
          Text("Bem Vindo Professor", style: TextStyle(fontSize: 30)),
          SizedBox(height: 30),
          Center(child: AppWidget.button("Cadastrar estudante", () {}, sizeFont: 25, width: widhScreen, height: 70)),
          SizedBox(height: 30),
          Center(child: AppWidget.button("Status Turma", () {}, sizeFont: 25, width: widhScreen, height: 70)),
          SizedBox(height: 30),
          Center(child: AppWidget.button("Verificar contas", () {}, sizeFont: 25, width: widhScreen, height: 70)),
        ],
      ),
    );
  }
}
