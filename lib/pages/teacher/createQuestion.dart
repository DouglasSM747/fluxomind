import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluxoMind/pages/teacher/menuTeacher.dart';
import 'package:fluxoMind/services/atividades.dart';
import 'package:fluxoMind/services/firebaseCloud.dart';
import 'package:fluxoMind/services/teacherClass.dart';
import 'package:fluxoMind/widgets/AppWidget.dart';
import 'package:image_picker/image_picker.dart';

class CreateQuestionPage extends StatefulWidget {
  @override
  _CreateQuestionPageState createState() => _CreateQuestionPageState();
}

class _CreateQuestionPageState extends State<CreateQuestionPage> {
  File _image;
  final _picker = ImagePicker();
  TextEditingController textEditingControllerEnunciado = new TextEditingController();
  List<String> listImagePath = new List<String>();
  List<TextEditingController> listTextEdit = new List<TextEditingController>();
  List<bool> listBoolAlternativas = new List<bool>();
  ServiceCrudFireStore serviceCrudFireStore = new ServiceCrudFireStore();

  // Captura uma imagem da galeria do celular
  Future imgFromGallery() async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    if (image == null) {
      print('No image selected.');
    } else {
      setState(() {
        listImagePath.add(image.path);
      });
    }
  }

  // Converte imagem para base 64, para enviar para o banco de dados
  Future<String> convertToBase64(String path) async {
    print(path);
    ByteData bytes = await rootBundle.load(path);
    var buffer = bytes.buffer;
    return base64.encode(Uint8List.view(buffer));
  }

  //Remove imagem
  removeImageFromList(int index) {
    setState(() {
      listImagePath.removeAt(index);
    });
  }

  // Adiciona questão
  addQuestionsCheckBox() {
    setState(() {
      listBoolAlternativas.add(false);
      listTextEdit.add(new TextEditingController());
    });
  }

  removeQuestionCheckBox(int index) {
    setState(() {
      listBoolAlternativas.removeAt(index);
      listTextEdit.removeAt(index);
    });
  }

  createQuestion() async {
    Atividade atividade = new Atividade();
    //Adicionando questões
    for (var i = 0; i < listTextEdit.length; i++) {
      if (listTextEdit[i].text.isNotEmpty) {
        atividade.alternativas[listTextEdit[i].text] = listBoolAlternativas[i];
        atividade.respostas.add(listBoolAlternativas[i]);
      }
    }
    // Adicionando imagens
    for (int i = 0; i < listImagePath.length; i++) {
      await convertToBase64(listImagePath[i]).then((value) => atividade.pathImages.add(value));
    }
    atividade.concluded = false;
    atividade.message = textEditingControllerEnunciado.text;
    serviceCrudFireStore.insertQuestionToStudents(Teacher.id, atividade);
    AppWidget.dialog(context, "Alerta", "Atividade criada com sucesso!", voidCallback: () => AppWidget.screenChange(context, MenuTeacherPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 214, 98, 1),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Text("Tela de criação de atividades", style: TextStyle(fontSize: 25)),
            SizedBox(height: 10),
            AppWidget.formText(context, textEditingControllerEnunciado, "Digite o enunciado da questão", Icons.description),
            Text(" Selecione os fluxogramas que deseja adicionar à atividade"),
            SizedBox(height: 10),
            AppWidget.button("Inserir imagem", () {
              imgFromGallery();
            }, sizeFont: 16),
            SizedBox(height: 10),
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: listImagePath.length,
                itemBuilder: (context, index) {
                  return cardImage(index);
                },
              ),
            ),
            SizedBox(height: 10),
            AppWidget.button(
              "Inserir questão",
              () {
                addQuestionsCheckBox();
              },
              sizeFont: 16,
            ),
            SizedBox(height: 10),
            Container(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: listTextEdit.length,
                separatorBuilder: (BuildContext context, int index) => Divider(),
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: 250,
                          child: TextFormField(
                            decoration: new InputDecoration(
                              hintText: "Digite a questão " + (index + 1).toString(),
                            ),
                            controller: listTextEdit[index],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: listBoolAlternativas[index],
                        onChanged: (bool value) {
                          setState(() {
                            listBoolAlternativas[index] = value;
                          });
                        },
                      ),
                      FlatButton(
                        onPressed: () => removeQuestionCheckBox(index),
                        child: Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            AppWidget.button(
              "Criar Atividade",
              () {
                createQuestion();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget cardImage(int index) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        Container(
          height: 100,
          child: Card(
            child: Image.file(
              File(listImagePath[index]),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              removeImageFromList(index);
            },
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 14.0,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.close, color: Colors.red),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 90),
          child: Text(
            "Fluxo " + (index + 1).toString(),
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
