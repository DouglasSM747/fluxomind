import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceCrudFireStore {
  final _db = FirebaseFirestore.instance;

  Future<QuerySnapshot> get getUsers async => await FirebaseFirestore.instance.collection("user").get();

  updateAtividadesList(String userId, List<String> atividadesList) async {
    await _db.collection("user").doc(userId).update({"listaAtv": atividadesList});
    print("Atividade Upada");
  }

  Future<String> isValidUser({String email, String tipoUser}) async {
    QuerySnapshot querySnapshot = await _db.collection(tipoUser).get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].data()['email'] == email.trim()) {
        return querySnapshot.docs[i].id;
      }
    }
    return "";
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
}
