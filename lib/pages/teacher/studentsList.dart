import 'package:flutter/material.dart';
import 'package:fluxoMind/Utils/design.dart';
import 'package:fluxoMind/services/firebaseCloud.dart';
import 'package:fluxoMind/services/teacherClass.dart';

class ListStudentsPage extends StatefulWidget {
  @override
  _ListStudentsPageState createState() => _ListStudentsPageState();
}

class _ListStudentsPageState extends State<ListStudentsPage> {
  ServiceCrudFireStore serviceCrudFireStore = new ServiceCrudFireStore();
  List<Map<String, dynamic>> listEstudents = new List<Map<String, String>>(); // Armazena um MAP contendo o e-mail e senha do usuario

  // Carrega as credenciais dos alunos que estão na turma do atual professor
  void loadStudentsCredentials(String idTeacher) async {
    await serviceCrudFireStore.getStudents(idTeacher).then(
      (resp) {
        setState(() {
          listEstudents = resp;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadStudentsCredentials(Teacher.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.corAzul,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            Text("Lista de seus estudantes", style: TextStyle(fontSize: 30, color: Colors.white)),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.separated(
                itemCount: listEstudents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "Email: " + listEstudents[index]['email'],
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Senha: " + listEstudents[index]['password'],
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.white,
                    height: 20,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
