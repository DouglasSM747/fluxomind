import 'dart:math';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluxoMind/Utils/design.dart';
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
  DetailScreen(this.imageMemory);
  final Uint8List imageMemory;

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
              zoomedBackgroundColor: Design.corLaranja,
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

  List<bool> respostasUser;
  @override
  void initState() {
    super.initState();
    setState(() {
      // Inicializa a lista de resposta do usuario como "false" para as alternativas da questão
      respostasUser = List.filled(widget.atividadeAtual.alternativas.length, false);
    });
  }

  // Transforma a String em Base 64 em Imagem
  Uint8List _transformImageFromBase64(String b64) {
    Uint8List bytes = base64.decode(b64);
    return bytes;
  }

  void validaResp(List<dynamic> listaResposta, List<dynamic> listaSolucao) {
    Function eq = const ListEquality().equals;
    widget.atividadeAtual.numTentativas++;
    // Verifica se a resposta é igual a solução do usuario
    if (eq(listaResposta, listaSolucao)) {
      widget.atividadeAtual.concluded = true; // Marca a atividade como concluida

      // Mostra a informação para o usuario
      if (widget.atividadeAtual.number < Atividade.numberAtividades) {
        Atividade.attDataBaseValues(Student.listAtv, Student.id); // Atualiza o banco de atividades
        AppWidget.dialog(
          context,
          "Alerta",
          "Parabéns, atividade respondida com sucesso!",
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
      backgroundColor: Design.corAzul,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Text("Enunciado", style: TextStyle(fontSize: 20, color: Colors.white)),
          Container(
            height: 70,
            width: MediaQuery.of(context).size.width - 50,
            child: Card(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.atividadeAtual.message),
                ),
              ),
            ),
          ),
          Text("Caso deseje dar Zoom, basta clicar no desejado!", style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center),
          Container(
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider.builder(
              itemCount: widget.atividadeAtual.pathImages.length,
              itemBuilder: (BuildContext context, int itemIndex) {
                return FlatButton(
                    onPressed: () {
                      AppWidget.screenChange(context, DetailScreen(_transformImageFromBase64(widget.atividadeAtual.pathImages[itemIndex])));
                    },
                    child: Image.memory(_transformImageFromBase64(widget.atividadeAtual.pathImages[itemIndex])));
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
            style: TextStyle(fontSize: 15, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Flexible(
            fit: FlexFit.tight,
            child: ListView.builder(
              itemCount: widget.atividadeAtual.alternativas.length,
              itemBuilder: (context, index) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Card(
                      color: Design.corRoxo,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: Text(
                            widget.atividadeAtual.alternativas[index],
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -10,
                      child: Checkbox(
                        value: respostasUser[index],
                        onChanged: (bool value) {
                          setState(() {
                            respostasUser[index] = value;
                          });
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppWidget.button(
              "Responder",
              voidCallback: () => validaResp(widget.atividadeAtual.respostas, respostasUser),
            ),
          )
        ],
      ),
    );
  }
}
