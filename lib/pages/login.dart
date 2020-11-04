import 'package:flutter/material.dart';
import 'package:fluxoMind/Utils/design.dart';
import 'package:fluxoMind/pages/student/selection.dart';
import 'package:fluxoMind/pages/teacher/menuTeacher.dart';
import 'package:fluxoMind/services/atividades.dart';
import 'package:fluxoMind/services/firebaseAuth.dart';
import 'package:fluxoMind/services/firebaseCloud.dart';
import 'package:fluxoMind/services/studentClass.dart';
import 'package:fluxoMind/services/teacherClass.dart';
import 'package:fluxoMind/widgets/AppWidget.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.gloriaHallelujahTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: "Login Screen",
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String tipoUserLogando = "aluno";

  TextEditingController emailInput = new TextEditingController();
  TextEditingController passwordInput = new TextEditingController();
  ServiceConnection serviceConnection = new ServiceConnection();
  ServiceCrudFireStore serviceCrudFireStore = new ServiceCrudFireStore();

  void validateLoginGetDateUser() async {
    await serviceConnection.signInWithEmailAndPassword(emailInput.text, passwordInput.text).then((value) async {
      if (value != null) {
        serviceCrudFireStore.isValidUser(email: emailInput.text, tipoUser: tipoUserLogando).then((idUser) async {
          if (idUser != "") {
            // Verifica o tipo de usuario que está logado
            if (tipoUserLogando == "aluno") {
              Student.id = idUser;
              await Atividade.loadTasksStudent(idUser).then((value) {
                Student.listAtv = value;
              });
              AppWidget.screenChange(context, SelectionPage());
            } else if (tipoUserLogando == "professor") {
              Teacher.id = idUser;
              Teacher.email = emailInput.text;
              Teacher.loadStudentsInformations; // Carrega as informações utilizadas para analises da turma na classe [Status]
              AppWidget.screenChange(context, MenuTeacherPage());
            }
          } else {
            AppWidget.dialog(context, "Alerta", "Usuario não cadastrado no sistema!");
          }
        });
      } else {
        AppWidget.dialog(context, "Alerta", "Verifique suas credenciais!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Design.corAzul,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70),
            Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
            ),
            SizedBox(height: 30),
            AppWidget.formText(context, emailInput, "Digite email", Icons.email),
            SizedBox(height: 20),
            AppWidget.formText(context, passwordInput, "Digite sua senha", Icons.lock, password: true),
            SizedBox(height: 20),
            radioButtons(),
            SizedBox(height: 20),
            AppWidget.button("Entrar", voidCallback: validateLoginGetDateUser, sizeFont: 25, width: screenWidth - 30)
          ],
        ),
      ),
    );
  }

  Widget radioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Eu sou: ", style: TextStyle(fontSize: 15, color: Colors.white)),
        Row(
          children: [
            Text("Professor", style: TextStyle(color: Colors.white)),
            Radio(
              activeColor: Colors.white,
              groupValue: tipoUserLogando,
              onChanged: (String value) {
                setState(
                  () {
                    tipoUserLogando = value;
                  },
                );
              },
              value: "professor",
            )
          ],
        ),
        Row(
          children: [
            Text("Aluno", style: TextStyle(color: Colors.white)),
            Radio(
              activeColor: Colors.white,
              groupValue: tipoUserLogando,
              onChanged: (String value) {
                setState(
                  () {
                    tipoUserLogando = value;
                  },
                );
              },
              value: "aluno",
            )
          ],
        )
      ],
    );
  }
}
