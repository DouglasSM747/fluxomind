import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            Center(child: Text("FluxoMind", style: TextStyle(fontSize: 70))),
            SizedBox(height: 60),
            AppWidget.formText(emailInput, "Digite email", Icons.email),
            SizedBox(height: 20),
            AppWidget.formText(passwordInput, "Digite sua senha", Icons.lock, password: true),
            SizedBox(height: 20),
            Text("Eu sou: ", style: TextStyle(fontSize: 20)),
            radioButtons(),
            SizedBox(height: 20),
            AppWidget.button("Entrar", () {
              serviceConnection.signInWithEmailAndPassword(emailInput.text, passwordInput.text).then((value) async {
                if (value != null) {
                  serviceCrudFireStore.isValidUser(email: emailInput.text, tipoUser: tipoUserLogando).then((resp) async {
                    if (resp != "") {
                      if (tipoUserLogando == "aluno") {
                        Student.id = resp;
                        await Atividade.carregarFasesUser(resp).then((value) => Student.listAtv = value);
                        await AppWidget.screenChange(context, Selection());
                      } else if (tipoUserLogando == "professor") {
                        await AppWidget.screenChange(context, MenuTeacherPage());
                      }
                    } else {
                      AppWidget.dialog(context, "Alerta", "Usuario não cadastrado no sistema!");
                    }
                  });
                } else {
                  AppWidget.dialog(context, "Alerta", "Verifique suas credenciais!");
                }
              });
            }, sizeFont: 25)
          ],
        ),
      ),
    );
  }

  Widget radioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text("Professor"),
            Radio(
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
            Text("Aluno"),
            Radio(
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