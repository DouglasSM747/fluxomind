import 'dart:convert';

import 'package:fluxoMind/services/atividades.dart';
import 'package:fluxoMind/services/firebaseCloud.dart';

class Teacher {
  static String id = "";
  static String email = "";
  static int quantAlunos = 0;
  static int quantQuestion = 0;
  static int numAcertos = 0;
  static int numErros = 0;
  static List<int> listQuestionTentivas;
  static Map<String, int> listQuestionTentivasIndividual = new Map<String, int>();

  //! Função precisa de refatoramento de código, no momento atende as necessidades
  // Carrega as informações do estudantes para serem utilizadas para analise de dados
  static get loadStudentsInformations async {
    ServiceCrudFireStore serviceCrudFireStore = new ServiceCrudFireStore();
    await serviceCrudFireStore.getStudents(Teacher.id).then(
      (value) async {
        Teacher.quantAlunos = value.length;
        // Teacher.quantQuestion = value[0]['listaAtv'];
        await serviceCrudFireStore.getQuantidadeAtividades(Teacher.id).then((value) => quantQuestion = value);
        listQuestionTentivas = new List<int>(quantQuestion);
        for (int i = 0; i < listQuestionTentivas.length; i++) {
          listQuestionTentivas[i] = 0;
        }
        for (int i = 0; i < value.length; i++) {
          for (int j = 0; j < quantQuestion; j++) {
            Map atividadeMap = jsonDecode(value[i]['listaAtv'][j]);
            Atividade atividade = Atividade.fromJson(atividadeMap);
            if (!listQuestionTentivasIndividual.containsKey(value[i]['email'])) {
              listQuestionTentivasIndividual[value[i]['email']] = 0;
            }
            listQuestionTentivasIndividual[value[i]['email']] += atividade.numErros;
            numErros += atividade.numErros;
            listQuestionTentivas[j] += atividade.numErros;
            if (atividade.concluded) {
              numAcertos++;
            }
          }
        }
      },
    );
  }
}
