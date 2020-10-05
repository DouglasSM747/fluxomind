import 'dart:convert';

import 'package:fluxoMind/services/firebaseCloud.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Atividade {
  static final int numberAtividades = 9;

  Atividade(int number, bool status) {
    this.number = number;
    this.status = status;
  }

  int number = 0;
  bool status = false;
  String message = "";
  int numTentativas = 0;
  int numErros = 0;

  List<String> pathImages = new List<String>();
  Map<String, dynamic> alternativas;
  List<bool> respostas = List<bool>();

  Atividade.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    status = json['status'];
    message = json['message'];
    numTentativas = json['numTentativas'];
    numErros = json['numErros'];
    alternativas = json['alternativas'];
    pathImages = json['pathImages'].cast<String>();
    respostas = json['respostas'].cast<bool>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['status'] = this.status;
    data['alternativas'] = this.alternativas;
    data['message'] = this.message;
    data['numTentativas'] = this.numTentativas;
    data['numErros'] = this.numErros;
    data['pathImages'] = this.pathImages;
    data['respostas'] = this.respostas;
    return data;
  }

  static bool _isLock(List<Atividade> list, int index) {
    if (list[index].status == false) return true;
    return false;
  }

  static desbloquearAtividade(List<Atividade> list, int index) {
    if (_isLock(list, index)) list[index].status = true;
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
    // Inicializa Atividade 1
    Atividade atividade = new Atividade(0, true);
    atividade.message = "Analise o seguinte algoritmo, para indentificar se o número é impar ou par";
    atividade.alternativas = {"Teste1": false, "Teste2": false, "Teste3": false, "Teste4": false, "Teste5": false};
    atividade.respostas = [true, true, true, false, false];
    atividade.pathImages = ["assets/images/Atv1/1.png", "assets/images/Atv1/2.png", "assets/images/Atv1/3.png"];
    listAtividades.add(atividade);
    // Inicializa Atividade 2
    atividade = new Atividade(1, false);
    // atividade.respostas = ["resp2", "resp2", "resp2", "resp2", "resp2"];
    // atividade.pathImages = "assets/images/atividade1.png";
    listAtividades.add(atividade);
    // Inicializa Atividade 3
    atividade = new Atividade(2, false);
    // atividade.respostas = ["resp3", "resp3", "resp3", "resp3", "resp3"];
    // atividade.pathImage = "assets/images/atividade1.png";
    listAtividades.add(atividade);
    // Inicializa Atividade 4
    atividade = new Atividade(3, false);
    // atividade.respostas = ["resp4", "resp4", "resp4", "resp4", "resp4"];
    // atividade.pathImage = "assets/images/atividade1.png";
    listAtividades.add(atividade);
    // Inicializa Atividade 5
    atividade = new Atividade(4, false);
    // atividade.respostas = ["resp5", "resp5", "resp5", "resp5", "resp5"];
    // atividade.pathImage = "assets/images/atividade1.png";
    listAtividades.add(atividade);
    // Inicializa Atividade 6
    atividade = new Atividade(6, false);
    // atividade.respostas = ["resp6", "resp6", "resp6", "resp6", "resp6"];
    // atividade.pathImage = "assets/images/atividade1.png";
    listAtividades.add(atividade);
    // Inicializa Atividade 7
    atividade = new Atividade(7, false);
    // atividade.respostas = ["resp7", "resp7", "resp7", "resp7", "resp7"];
    // atividade.pathImage = "assets/images/atividade1.png";
    listAtividades.add(atividade);
    // Inicializa Atividade 8
    atividade = new Atividade(8, false);
    // atividade.respostas = ["resp8", "resp8", "resp8", "resp8", "resp8"];
    // atividade.pathImage = "assets/images/atividade1.png";
    listAtividades.add(atividade);
    // Inicializa Atividade 9
    atividade = new Atividade(9, false);
    // atividade.respostas = ["resp9", "resp9", "resp9", "resp9", "resp9"];
    // atividade.pathImage = "assets/images/atividade1.png";
    listAtividades.add(atividade);

    //---------------------- Atualizar informações  --------------//

    await _getDataBaseValues(userId).then(
      (listResult) {
        if (listResult != null) {
          if (listResult.length != 0) {
            for (var i = 0; i < listResult.length; i++) {
              Map atividadeMap = jsonDecode(listResult[i]);
              listAtividades[i] = Atividade.fromJson(atividadeMap);
            }
          }
        }
      },
    );
    print(listAtividades[0].alternativas);
    return listAtividades;
  }
}
