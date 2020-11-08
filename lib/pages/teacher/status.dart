import 'package:flutter/material.dart';
import 'package:fluxoMind/Utils/design.dart';
import 'package:fluxoMind/services/teacherClass.dart';

class StatusStudentPage extends StatefulWidget {
  @override
  _StatusStudentState createState() => _StatusStudentState();
}

class _StatusStudentState extends State<StatusStudentPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String createInfoQuestionGeral() {
    String text = "";
    for (int i = 0; i < Teacher.listQuestionTentivas.length; i++) {
      text += "Questão " + (i + 1).toString() + ": " + Teacher.listQuestionTentivas[i].toString() + " Tentativa\n";
    }
    return text;
  }

  String createInfoQuestionIndividual() {
    String text = "";
    Teacher.listQuestionTentivasIndividual.forEach((key, value) {
      text += key + " - Tentativas: " + value.toString() + "\n";
    });
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.corAzul,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              Center(child: Text("Status Turma", style: TextStyle(fontSize: 30, color: Colors.white))),
              Text("---------------------------------------"),
              Text("Quantidade de atividade concluidas =  " + Teacher.numAcertos.toString() + "\nQuantidade erros = " + Teacher.numErros.toString(),
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              SizedBox(height: 25),
              Text("---------------------------------------"),
              Text(
                "Quantidade de tentivas por questão\n\n" + createInfoQuestionGeral(),
                style: TextStyle(fontSize: 15, color: Colors.yellow),
              ),
              Text("---------------------------------------"),
              SizedBox(height: 25),
              Text(
                "Quantidade de tentivas individuais\n\n" + createInfoQuestionIndividual(),
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

/// Sample ordinal data type.
class QuestionTentativa {
  final String question;
  final int numTentativas;

  QuestionTentativa(this.question, this.numTentativas);
}

/// Sample ordinal data type.
class QuestionTentativaIndividual {
  final String student;
  final int numTentativas;

  QuestionTentativaIndividual(this.student, this.numTentativas);
}
