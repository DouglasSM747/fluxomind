import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluxoMind/Utils/design.dart';
import 'package:fluxoMind/services/teacherClass.dart';

class StatusStudentPage extends StatefulWidget {
  @override
  _StatusStudentState createState() => _StatusStudentState();
}

class _StatusStudentState extends State<StatusStudentPage> {
  final List<charts.Series> seriesList = _createSampleData();
  final List<charts.Series> seriesList1 = _createSampleData1();
  final List<charts.Series> seriesList2 = _createSampleData2();

  final bool animate = true;

  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, Teacher.numErros),
      new LinearSales(1, Teacher.numAcertos),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.sales}',
      )
    ];
  }

  /// Create series list with single series
  static List<charts.Series<QuestionTentativa, String>> _createSampleData1() {
    List<QuestionTentativa> listQuestionsTentativas = new List<QuestionTentativa>();
    for (int i = 0; i < Teacher.quantQuestion; i++) {
      listQuestionsTentativas.add(new QuestionTentativa((i + 1).toString(), Teacher.listQuestionTentivas[i]));
    }

    return [
      new charts.Series<QuestionTentativa, String>(
        id: 'Global Revenue',
        domainFn: (QuestionTentativa sales, _) => sales.question,
        measureFn: (QuestionTentativa sales, _) => sales.numTentativas,
        data: listQuestionsTentativas,
      ),
    ];
  }

  /// Create series list with single series
  static List<charts.Series<QuestionTentativaIndividual, String>> _createSampleData2() {
    List<QuestionTentativaIndividual> listQuestionsTentativas = new List<QuestionTentativaIndividual>();
    Teacher.listQuestionTentivasIndividual.forEach((key, value) {
      listQuestionsTentativas.add(new QuestionTentativaIndividual(key, value));
    });
    return [
      new charts.Series<QuestionTentativaIndividual, String>(
        id: 'Global Revenue',
        domainFn: (QuestionTentativaIndividual sales, _) => sales.student,
        measureFn: (QuestionTentativaIndividual sales, _) => sales.numTentativas,
        data: listQuestionsTentativas,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.corAzul,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            Center(child: Text("Status Turma", style: TextStyle(fontSize: 30, color: Colors.white))),
            Center(
              child: Text("Quantidade erros e acertos",
                  style: TextStyle(fontSize: 20, color: Color.fromRGBO(242, 152, 41, 0.95)), textAlign: TextAlign.center),
            ),
            Center(
              child: Text("Obs.: O Azul mais escuro representa a quantidade de erros e o azul mais escuro a quantidade de acertos",
                  style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.center),
            ),
            Container(
              width: 300,
              height: 300,
              child: charts.PieChart(seriesList,
                  animate: animate,
                  defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60, arcRendererDecorators: [new charts.ArcLabelDecorator()])),
            ),
            Center(
              child: Text("Quantidade de tentivas por questão",
                  style: TextStyle(fontSize: 20, color: Color.fromRGBO(242, 152, 41, 0.95)), textAlign: TextAlign.center),
            ),
            Container(
              width: 300,
              height: 300,
              child: charts.BarChart(
                seriesList1,
                animate: animate,
                primaryMeasureAxis: new charts.NumericAxisSpec(
                    renderSpec: new charts.SmallTickRendererSpec(
                        // Tick and Label styling here.
                        )),
              ),
            ),
            Center(
              child: Text("Quantidade de tentivas individual",
                  style: TextStyle(fontSize: 20, color: Color.fromRGBO(242, 152, 41, 0.95)), textAlign: TextAlign.center),
            ),
            Container(
              width: 300,
              height: 300,
              child: charts.BarChart(
                seriesList2,
                animate: animate,
                primaryMeasureAxis: new charts.NumericAxisSpec(
                    renderSpec: new charts.SmallTickRendererSpec(
                        // Tick and Label styling here.
                        )),
              ),
            ),
          ],
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
