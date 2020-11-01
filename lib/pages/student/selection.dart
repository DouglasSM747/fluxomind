import 'package:flutter/material.dart';
import 'package:fluxoMind/Utils/design.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.corAzul,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Text("Email do professor: " + emailTeacher, style: TextStyle(color: Colors.white)),
          Center(child: Text("Selecione Uma Atividade", textAlign: TextAlign.center, style: TextStyle(fontSize: 32, color: Colors.white))),
          loadAtividades(),
        ],
      ),
    );
  }

  Widget loadAtividades() {
    // Caso tenha atividades para o usuario, mostra elas
    if (Atividade.numberAtividades > 0) {
      return Expanded(
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: List.generate(
            Atividade.numberAtividades,
            (index) {
              return atividadeWidget(index);
            },
          ),
        ),
      );
    } else {
      // Caso não tenha atividades no momento, notifica o usuario
      return Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Center(
              child: Text(
                "Seu professor ainda não postou uma atividade, tente novamente mais tarde!",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),
            Center(
              child: Loading(indicator: BallPulseIndicator(), size: 150.0, color: Colors.blue),
            ),
          ],
        ),
      );
    }
  }

  Widget circleAtividade(int index, IconData icon) {
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
              icon,
            )
          ],
        ),
        shape: new CircleBorder(),
        color: Design.corLaranja,
      ),
    );
  }

  Widget atividadeWidget(int index) {
    if (Student.listAtv[index].concluded) {
      return circleAtividade(index, Icons.check_circle_outline);
    } else {
      return circleAtividade(index, Icons.highlight_off);
    }
  }
}
