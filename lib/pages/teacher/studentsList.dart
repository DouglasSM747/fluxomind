import 'package:flutter/material.dart';
import 'package:fluxoMind/services/firebaseCloud.dart';
import 'package:fluxoMind/services/teacherClass.dart';

class ListStudentsPage extends StatefulWidget {
  @override
  _ListStudentsPageState createState() => _ListStudentsPageState();
}

class _ListStudentsPageState extends State<ListStudentsPage> {
  ServiceCrudFireStore serviceCrudFireStore = new ServiceCrudFireStore();
  List<Map<String, dynamic>> listEstudents = new List<Map<String, String>>();

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
    // TODO: implement initState
    super.initState();
    loadStudentsCredentials(Teacher.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 214, 98, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            Text("Lista de seus estudantes", style: TextStyle(fontSize: 30)),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.separated(
                itemCount: listEstudents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Email: " + listEstudents[index]['email']),
                    subtitle: Text("Senha: " + listEstudents[index]['password']),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
