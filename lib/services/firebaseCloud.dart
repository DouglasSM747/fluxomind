import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluxoMind/services/atividades.dart';
import 'package:fluxoMind/services/studentClass.dart';
import 'package:fluxoMind/services/teacherClass.dart';

class ServiceCrudFireStore {
  final _db = FirebaseFirestore.instance;

  //******************** Cloud Teacher functions ********************//

  // Retorna a lista String de questões que o professor adicionou no sistema
  Future<List<dynamic>> getQuestionTeacher(String idTeacher) async {
    DocumentSnapshot documentSnapshot = await _db.collection("professor").doc(idTeacher).get();
    List<dynamic> listStringAtividades = documentSnapshot.data()['listQuestionTeacher'];
    return listStringAtividades;
  }

  void createStudent(
    String email,
    String password,
    String idTeacher,
  ) async {
    List<dynamic> listAtividadesdaTurma;

    await getQuestionTeacher(idTeacher).then((respLista) {
      print(respLista);
      listAtividadesdaTurma = respLista;
    });

    await _db.collection("aluno").add({
      "email": email.trim(),
      "password": password.trim(),
      "idTeache": idTeacher,
      "emailTeacher": Teacher.email,
      "listaAtv": listAtividadesdaTurma
    });
  }

  Future<List<Map<String, dynamic>>> getStudents(String idTeacher) async {
    QuerySnapshot querySnapshot = await _db.collection("aluno").get();
    List<Map<String, dynamic>> listStudentsthisTeacher = new List<Map<String, dynamic>>();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].data()['idTeache'] == idTeacher) {
        listStudentsthisTeacher.add(querySnapshot.docs[i].data());
      }
    }
    return listStudentsthisTeacher;
  }

  // Sobe para o firebase a nova atividade adicionada pelo professor
  attQuestionsTeacher(String idTeacher, String newAtividade) async {
    DocumentSnapshot documentSnapshot = await _db.collection("professor").doc(idTeacher).get();
    List<dynamic> list = documentSnapshot.data()['listQuestionTeacher'];
    list.add(newAtividade);
    await _db.collection("professor").doc(idTeacher).update({"listQuestionTeacher": list});
  }

  // Insere uma nova questão para os estundades. Obs.: Questão criada pelo professor
  insertQuestionToStudents(String idTeacher, Atividade newAtividade) async {
    String atividadeToJson = jsonEncode(newAtividade.toJson()); //Transforma a classe atividade em Json
    print(atividadeToJson);
    QuerySnapshot querySnapshot = await _db.collection("aluno").get();
    attQuestionsTeacher(idTeacher, atividadeToJson); //Atualiza questão na lista do professor
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      //Busca os alunos do professor, caso ache insere a atividade
      if (querySnapshot.docs[i].data()['idTeache'] == idTeacher) {
        List<dynamic> listaAtividadeAuxiliar = querySnapshot.docs[i].data()['listaAtv'];
        listaAtividadeAuxiliar.add(atividadeToJson);
        updateAtividadesList(querySnapshot.docs[i].id, listaAtividadeAuxiliar);
      }
    }
  }

  Future<int> getQuantidadeAtividades(String idTeacher) async {
    DocumentSnapshot documentSnapshot = await _db.collection("professor").doc(idTeacher).get();
    List<dynamic> list = documentSnapshot.data()['listQuestionTeacher'];
    return list.length;
  }

  //******************** Cloud Student functions ********************//

  Future<dynamic> get getEmailTeacher async {
    DocumentSnapshot documentSnapshot = await _db.collection("aluno").doc(Student.id).get();
    return documentSnapshot.data()['emailTeacher'];
  }

  updateAtividadesList(String userId, List<dynamic> atividadesList) async {
    await _db.collection("aluno").doc(userId).update({"listaAtv": atividadesList});
  }

  Future<List<String>> getListAtvUser(String userId) async {
    DocumentSnapshot documentSnapshot = await _db.collection('aluno').doc(userId).get();
    try {
      var list = documentSnapshot.data()['listaAtv'];
      if (list != null) {
        return List<String>.from(list);
      } else {
        return null;
      }
    } on Exception catch (e) {
      return null;
    }
  }

  //******************** Cloud general functions ********************//

  Future<String> isValidUser({String email, String tipoUser}) async {
    QuerySnapshot querySnapshot = await _db.collection(tipoUser).get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].data()['email'] == email.trim()) {
        return querySnapshot.docs[i].id;
      }
    }
    return "";
  }
}
