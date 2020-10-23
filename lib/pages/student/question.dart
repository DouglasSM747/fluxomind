import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluxoMind/pages/student/selection.dart';
import 'package:fluxoMind/services/atividades.dart';
import 'package:fluxoMind/services/studentClass.dart';
import 'package:fluxoMind/widgets/AppWidget.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

class QuestionPage extends StatefulWidget {
  final Atividade atividadeAtual;

  const QuestionPage({Key key, this.atividadeAtual}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class DetailScreen extends StatelessWidget {
  @override
  DetailScreen(Uint8List image) {
    this.imageMemory = image;
  }
  Uint8List imageMemory;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Center(child: Text("Você pode interagir com a imagem para dar Zoom")),
          Container(
            child: PinchZoomImage(
              image: Image.memory(
                imageMemory,
                fit: BoxFit.fitWidth,
              ),
              zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
              hideStatusBarWhileZooming: true,
              onZoomStart: () {
                print('Zoom started');
              },
              onZoomEnd: () {
                print('Zoom finished');
              },
            ),
          )
        ],
      ),
    );
  }
}

class _QuestionPageState extends State<QuestionPage> {
  int current = 0; //atual index from card
  int quantidadeAtividades = 0;
  List<bool> respostasOrdem = new List<bool>();
  @override
  void initState() {
    super.initState();
    setState(() {
      quantidadeAtividades = Atividade.numberAtividades;
      // ! Solução temporaria para zerar alternativas
      widget.atividadeAtual.alternativas.forEach((key, value) {
        widget.atividadeAtual.alternativas[key] = false;
      });
    });
  }

  // Transforma a String em Base 64 em Imagem
  Uint8List _createImagemFromBase64(String b64) {
    Uint8List bytes = base64.decode(b64);
    return bytes;
  }

  void validaResp(List<dynamic> listaResposta, List<dynamic> listaSolucao) {
    Function eq = const ListEquality().equals;
    widget.atividadeAtual.numTentativas++;
    if (eq(listaResposta, listaSolucao)) {
      widget.atividadeAtual.concluded = true;
      //Resposta Correta
      if (widget.atividadeAtual.number < quantidadeAtividades) {
        Atividade.attDataBaseValues(Student.listAtv, Student.id); // Atualiza o banco de atividades
        AppWidget.dialog(
          context,
          "Alerta",
          "Parabéns, atividade respondida com sucesso!",
          voidCallback: () {
            AppWidget.screenChange(context, SelectionPage());
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
            AppWidget.screenChange(context, SelectionPage());
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
      backgroundColor: Color.fromRGBO(255, 214, 98, 1),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          FlatButton(child: Icon(Icons.info), onPressed: () => AppWidget.dialog(context, "Informação", widget.atividadeAtual.message)),
          Text(
            "Arraste para o lado e visualize os outros fluxogramas, caso deseje dar Zoom, basta clicar no desejado!",
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider.builder(
              itemCount: widget.atividadeAtual.pathImages.length,
              itemBuilder: (BuildContext context, int itemIndex) {
                return FlatButton(
                    onPressed: () {
                      AppWidget.screenChange(context, DetailScreen(_createImagemFromBase64(widget.atividadeAtual.pathImages[itemIndex])));
                    },
                    child: Image.memory(_createImagemFromBase64(widget.atividadeAtual.pathImages[itemIndex])));
              },
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.5,
                aspectRatio: 1.9,
                initialPage: 0,
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  setState(() {
                    current = index;
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
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child:
                AppWidget.button("Responder", () => validaResp(widget.atividadeAtual.respostas, widget.atividadeAtual.alternativas.values.toList())),
          )
        ],
      ),
    );
  }
}
