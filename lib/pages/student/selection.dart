import 'package:flutter/material.dart';
import 'package:fluxoMind/pages/student/question.dart';
import 'package:fluxoMind/services/atividades.dart';
import 'package:fluxoMind/services/firebaseCloud.dart';
import 'package:fluxoMind/services/studentClass.dart';
import 'package:fluxoMind/widgets/AppWidget.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class SelectionPage extends StatefulWidget {
  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  int quantidadeAtividades = 1;
  String emailTeacher = "";
  ServiceCrudFireStore serviceCrudFireStore = new ServiceCrudFireStore();

  void initState() {
    super.initState();
    setState(() {
      serviceCrudFireStore.getEmailTeacher.then((value) {
        setState(() {
          emailTeacher = value;
        });
      });
      quantidadeAtividades = Atividade.numberAtividades;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 214, 98, 1),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Text("Email do professor: " + emailTeacher),
          Center(child: Text("Selecione Uma Atividade", style: TextStyle(fontSize: 32))),
          loadAtividades(),
        ],
      ),
    );
  }

  Widget loadAtividades() {
    if (quantidadeAtividades > 0) {
      return Expanded(
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: List.generate(
            quantidadeAtividades,
            (index) {
              return atividadeWidget(index);
            },
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Center(child: Text("Seu professor ainda não postou uma atividade, tente novamente mais tarde!", style: TextStyle(fontSize: 28))),
            Center(
              child: Loading(indicator: BallPulseIndicator(), size: 150.0, color: Colors.blue),
            ),
          ],
        ),
      );
    }
  }

  Widget atividadeWidget(int index) {
    if (Student.listAtv[index].concluded) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: FlatButton(
          onPressed: () {
            AppWidget.screenChange(context, QuestionPage(atividadeAtual: Student.listAtv[index]));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (index + 1).toString() + " ",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              )
            ],
          ),
          shape: new CircleBorder(),
          color: Color.fromRGBO(0, 83, 156, 1),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: FlatButton(
          onPressed: () {
            AppWidget.screenChange(context, QuestionPage(atividadeAtual: Student.listAtv[index]));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (index + 1).toString() + " ",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              Icon(
                Icons.highlight_off,
                color: Colors.red,
              )
            ],
          ),
          shape: new CircleBorder(),
          color: Color.fromRGBO(0, 83, 156, 1),
        ),
      );
    }
  }
}
