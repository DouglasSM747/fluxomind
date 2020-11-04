import 'package:flutter/material.dart';
import 'package:fluxoMind/Utils/design.dart';
import 'package:fluxoMind/pages/teacher/createQuestion.dart';
import 'package:fluxoMind/pages/teacher/registerTeacher.dart';
import 'package:fluxoMind/pages/teacher/status.dart';
import 'package:fluxoMind/pages/teacher/studentsList.dart';
import 'package:fluxoMind/widgets/AppWidget.dart';

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
      backgroundColor: Design.corAzul,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(height: 80),
          Text("Bem Vindo Professor", style: TextStyle(fontSize: 35, color: Colors.white)),
          SizedBox(height: 30),
          Center(
            child: AppWidget.button("Cadastrar estudante",
                voidCallback: () => AppWidget.screenChange(
                      context,
                      RegisterStudentPage(),
                    ),
                sizeFont: 25,
                width: widhScreen,
                height: 70),
          ),
          SizedBox(height: 30),
          Center(
            child: AppWidget.button("Status Turma",
                voidCallback: () => AppWidget.screenChange(
                      context,
                      StatusStudentPage(),
                    ),
                sizeFont: 25,
                width: widhScreen,
                height: 70),
          ),
          SizedBox(height: 30),
          Center(
            child: AppWidget.button("Verificar contas",
                voidCallback: () => AppWidget.screenChange(
                      context,
                      ListStudentsPage(),
                    ),
                sizeFont: 25,
                width: widhScreen,
                height: 70),
          ),
          SizedBox(height: 30),
          Center(
            child: AppWidget.button("Criar Atividade",
                voidCallback: () => AppWidget.screenChange(
                      context,
                      CreateQuestionPage(),
                    ),
                sizeFont: 25,
                width: widhScreen,
                height: 70),
          ),
        ],
      ),
    );
  }
}
