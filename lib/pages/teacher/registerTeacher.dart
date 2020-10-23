import 'package:flutter/material.dart';
import 'package:fluxoMind/pages/teacher/menuTeacher.dart';
import 'package:fluxoMind/services/firebaseAuth.dart';
import 'package:fluxoMind/services/firebaseCloud.dart';
import 'package:fluxoMind/services/teacherClass.dart';
import 'package:fluxoMind/widgets/AppWidget.dart';

class RegisterStudentPage extends StatefulWidget {
  @override
  _RegisterStudentState createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudentPage> {
  TextEditingController emailInput = new TextEditingController();
  TextEditingController passwordInput = new TextEditingController();
  TextEditingController passwordConfirmationInput = new TextEditingController();
  ServiceConnection serviceConnection = new ServiceConnection();
  ServiceCrudFireStore serviceCrudFireStore = new ServiceCrudFireStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 214, 98, 1),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            Text("Cadastro de estudante", style: TextStyle(fontSize: 30)),
            AppWidget.formText(context, emailInput, "Email", Icons.email),
            SizedBox(height: 10),
            Center(
                child: Text("Atenção, não é possível alterar está senha futuramente!",
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.red))),
            AppWidget.formText(context, passwordInput, "Senha", Icons.lock, password: true),
            SizedBox(height: 10),
            AppWidget.formText(context, passwordConfirmationInput, "Confirmação da senha", Icons.lock, password: true),
            SizedBox(height: 15),
            AppWidget.button(
              "Cadastrar",
              () {
                if (passwordInput.text == passwordConfirmationInput.text) {
                  //Cria a conta caso entradas ok
                  serviceConnection.createUserWithEmailAndPassword(emailInput.text, passwordInput.text).then(
                    (resp) {
                      if (resp != null) {
                        serviceCrudFireStore.createStudent(emailInput.text, passwordInput.text, Teacher.id);
                        AppWidget.dialog(
                          context,
                          "Alerta",
                          "Conta criada com sucesso!",
                          voidCallback: () => AppWidget.screenChange(context, MenuTeacherPage()),
                        );
                      } else {
                        AppWidget.dialog(context, "Alerta",
                            "Verifique suas credenciais, a senha deve ter mais de 6 digitos e o email deve estar no padrão 'exemplo@exemplo.com'");
                      }
                    },
                  );
                } else {
                  AppWidget.dialog(context, "Alerta", "Senhas não correspondem!");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
