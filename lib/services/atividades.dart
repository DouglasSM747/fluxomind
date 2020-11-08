import 'dart:convert';

import 'package:fluxoMind/services/firebaseCloud.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Atividade {
  static int numberAtividades = 0;
  // ignore: empty_constructor_bodies
  Atividade() {}
  bool concluded = false;
  int number = 0;
  String message = "";
  int numTentativas = 0;
  int numErros = 0;

  List<String> pathImages = new List<String>();
  List<dynamic> alternativas = new List<dynamic>();
  List<bool> respostas = List<bool>();

  Atividade.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    message = json['message'];
    numTentativas = json['numTentativas'];
    numErros = json['numErros'];
    alternativas = json['alternativas'];
    concluded = json['concluded'];
    pathImages = json['pathImages'].cast<String>();
    respostas = json['respostas'].cast<bool>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['alternativas'] = this.alternativas;
    data['message'] = this.message;
    data['concluded'] = this.concluded;
    data['numTentativas'] = this.numTentativas;
    data['numErros'] = this.numErros;
    data['pathImages'] = this.pathImages;
    data['respostas'] = this.respostas;
    return data;
  }

  // Funcão que ao ser chamada atualiza o status das atividades do presente usuario
  static attDataBaseValues(List<Atividade> listAtividades, String userId) async {
    List<String> atividadesJson = List<String>();

    for (int i = 0; i < numberAtividades; i++) {
      // Transforma a classe Atividade do estudante em Json, para depois ser possivel recuperar o dado
      String json = jsonEncode(listAtividades[i].toJson());
      atividadesJson.add(json);
    }
    //! Descontinuado no momento, motivo = NÃO É UM REQUISITO DE GRANDE IMPORTÂNCIA
    //! REQUISITO = ALÉM DE SALVAR LOCALMENTE, O STATUS DO ESTUDANTE DEVE SER ONLINE
    //* FOI ESCOLHIDO NO MOMENTO SOMENTE SALVAR ONLINE OU SEJA(O SISTEMA NECESSITA DE INTERNET)
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setStringList("atividadesList", atividadesJson);

    ServiceCrudFireStore serviceCrudFireStore = new ServiceCrudFireStore();

    // * SOBE AS ATIVIDADES PARA O FIREBASE EM FORMATO DE JSON
    serviceCrudFireStore.updateAtividadesList(userId, atividadesJson);
  }

  // Retorna as atividades(e seus status) do presente usuario
  static Future<List<String>> _getDataBaseValues(String userId) async {
    List<String> listAtividades = new List<String>();
    ServiceCrudFireStore serviceCrudFireStore = new ServiceCrudFireStore();
    await serviceCrudFireStore.getListAtvUser(userId).then((resp) {
      if (resp != null) {
        listAtividades = resp;
      }
    });
    return listAtividades;
  }

  // Carrega as atividades que o usuario possui
  static Future<List<Atividade>> loadTasksStudent(String userId) async {
    List<Atividade> listAtividades = new List<Atividade>();

    //---------------------- Atualizar informações  --------------//

    await _getDataBaseValues(userId).then(
      (listResult) {
        if (listResult != null) {
          if (listResult.length != 0) {
            Atividade.numberAtividades = listResult.length;
            for (var i = 0; i < listResult.length; i++) {
              if (listResult[i] != "") {
                Map atividadeMap = jsonDecode(listResult[i]);
                listAtividades.add(Atividade.fromJson(atividadeMap));
              }
            }
          }
        }
      },
    );
    return listAtividades;
  }
}
