import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluxoMind/pages/student/selection.dart';
import 'package:fluxoMind/services/atividades.dart';
import 'package:fluxoMind/services/studentClass.dart';
import 'package:fluxoMind/widgets/AppWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import 'package:photo_view/photo_view.dart';

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

class DetailScreen extends StatelessWidget {
  @override
  DetailScreen(String image) {
    this.imagePath = image;
  }
  String imagePath;
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(backgroundDecoration: new BoxDecoration(color: Colors.transparent), imageProvider: AssetImage(imagePath)),
    );
  }
}

class _QuestionPageState extends State<QuestionPage> {
  int _current = 0; //atual index from card

  void validaResp(List<dynamic> listaResposta, List<dynamic> listaSolucao) {
    Function eq = const ListEquality().equals;
    widget.atividadeAtual.numTentativas++;
    // widget.atividadeAtual.numTentativas += 1;
    if (eq(listaResposta, listaSolucao)) {
      //Resposta Correta
      if (widget.atividadeAtual.number < Atividade.numberAtividades) {
        Atividade.desbloquearAtividade(Student.listAtv, widget.atividadeAtual.number + 1);
        Atividade.attDataBaseValues(Student.listAtv, Student.id); // Atualiza o banco de atividades
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
        Atividade.attDataBaseValues(Student.listAtv, Student.id); // Atualiza o banco de atividades
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
      Atividade.attDataBaseValues(Student.listAtv, Student.id); // Atualiza o banco de atividades
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
          Container(
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider.builder(
              itemCount: widget.atividadeAtual.pathImages.length,
              itemBuilder: (BuildContext context, int itemIndex) {
                return FlatButton(
                    onPressed: () async {
                      await AppWidget.screenChange(context, DetailScreen(widget.atividadeAtual.pathImages[itemIndex]));
                    },
                    child: Image.asset(widget.atividadeAtual.pathImages[itemIndex]));
              },
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.5,
                aspectRatio: 1.9,
                initialPage: 0,
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ),
          Text(
            "Selecione a alternativas corretas sobre os fluxogramas apresentados: ",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
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
