import 'dart:convert';

import 'package:fluxoMind/services/firebaseCloud.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Atividade {
  static int numberAtividades = 0;
  Atividade() {}
  bool concluded = false;
  int number = 0;
  String message = "";
  int numTentativas = 0;
  int numErros = 0;

  List<String> pathImages = new List<String>();
  Map<String, dynamic> alternativas = new Map<String, dynamic>();
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

  static attDataBaseValues(List<Atividade> listAtividades, String userId) async {
    List<String> atividadesJson = List<String>();

    for (int i = 0; i < numberAtividades; i++) {
      String json = jsonEncode(listAtividades[i].toJson());
      atividadesJson.add(json);
    }
    //! Descontinuado no momento, motivo = NÃO É UM REQUISITO DE GRANDE IMPORTÂNCIA
    //! REQUISITO = ALÉM DE SALVAR LOCALMENTE, O STATUS DO ESTUDANTE DEVE SER ONLINE
    //* FOI ESCOLHIDO NO MOMENTO SOMENTE SALVAR ONLINE OU SEJA(O SISTEMA NECESSITA DE INTERNET)
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setStringList("atividadesList", atividadesJson);

    ServiceCrudFireStore serviceCrudFireStore = new ServiceCrudFireStore();
    serviceCrudFireStore.updateAtividadesList(userId, atividadesJson);
  }

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

  static Future<List<Atividade>> carregarFasesUser(String userId) async {
    List<Atividade> listAtividades = new List<Atividade>();

    //---------------------- Atualizar informações  --------------//

    await _getDataBaseValues(userId).then(
      (listResult) {
        if (listResult != null) {
          if (listResult.length != 0) {
            Atividade.numberAtividades = listResult.length;
            print(listResult.length);
            for (var i = 0; i < listResult.length; i++) {
              Map atividadeMap = jsonDecode(listResult[i]);
              listAtividades.add(Atividade.fromJson(atividadeMap));
            }
          }
        }
      },
    );
    return listAtividades;
  }
}
