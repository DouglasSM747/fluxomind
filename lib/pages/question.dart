import 'package:flutter/material.dart';
import 'package:fluxoMind/pages/selection.dart';
import 'package:fluxoMind/services/atividades.dart';
import 'package:fluxoMind/services/user.dart';
import 'package:fluxoMind/widgets/AppWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';

class Question extends StatelessWidget {
  Question(this.myAtividadeAtual);
  final Atividade myAtividadeAtual;
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
      title: "Login Screen",
      home: QuestionPage(
        atividadeAtual: myAtividadeAtual,
      ),
    );
  }
}

class QuestionPage extends StatefulWidget {
  final Atividade atividadeAtual;

  const QuestionPage({Key key, this.atividadeAtual}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  void dialogFluxogramas(int numFluxograma, String pathImage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Fluxograma " + numFluxograma.toString()),
          content: SingleChildScrollView(
            child: Image.asset(pathImage, fit: BoxFit.contain),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ok"),
            )
          ],
        );
      },
    );
  }

  void validaResp(List<bool> listaResposta, List<bool> listaSolucao) {
    Function eq = const ListEquality().equals;
    widget.atividadeAtual.numTentativas++;
    // widget.atividadeAtual.numTentativas += 1;
    if (eq(listaResposta, listaSolucao)) {
      //Resposta Correta
      if (widget.atividadeAtual.number < Atividade.numberAtividades) {
        Atividade.desbloquearAtividade(User.listAtv, widget.atividadeAtual.number + 1);
        Atividade.attDataBaseValues(User.listAtv, User.id); // Atualiza o banco de atividades
        AppWidget.dialog(
          context,
          "Alerta",
          "Parabéns, atividade respondida com sucesso, pressione voltar pois uma nova atividade foi desbloqueada!",
          voidCallback: () {
            AppWidget.screenChange(context, Selection());
          },
        );
      } else {
        // Finalizou todas atividades
        Atividade.attDataBaseValues(User.listAtv, User.id); // Atualiza o banco de atividades
        AppWidget.dialog(
          context,
          "Alerta",
          "Parabéns, você finalizou todas atividades até o momento. Bom trabalho!",
          voidCallback: () {
            AppWidget.screenChange(context, Selection());
          },
        );
      }
    } else {
      // Resposta incorreta
      widget.atividadeAtual.numErros++;
      Atividade.attDataBaseValues(User.listAtv, User.id); // Atualiza o banco de atividades
      AppWidget.dialog(context, "Alerta", "Verique sua resposta, infelizmente tem um erro!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          FlatButton(child: Icon(Icons.info), onPressed: () => AppWidget.dialog(context, "Informação", widget.atividadeAtual.message)),
          Flexible(
            fit: FlexFit.tight,
            child: ListView.builder(
              itemCount: widget.atividadeAtual.pathImages.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: AppWidget.button(
                      "Ver fluxograma " + (index + 1).toString(), () => dialogFluxogramas(index + 1, widget.atividadeAtual.pathImages[index])),
                );
              },
            ),
          ),
          Center(child: Text("Selecione a alternativas corretas sobre os fluxogramas apresentados: ", style: TextStyle(fontSize: 16))),
          Flexible(
            fit: FlexFit.tight,
            child: ListView(
              children: widget.atividadeAtual.alternativas.keys.map((String key) {
                return new CheckboxListTile(
                  title: new Text(key),
                  value: widget.atividadeAtual.alternativas[key],
                  onChanged: (bool value) {
                    setState(() {
                      widget.atividadeAtual.alternativas[key] = value;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          AppWidget.button("Responder", () => validaResp(widget.atividadeAtual.respostas, widget.atividadeAtual.alternativas.values.toList()))
        ],
      ),
    );
  }
}
