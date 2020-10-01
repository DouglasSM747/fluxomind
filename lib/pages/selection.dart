import 'package:flutter/material.dart';
import 'package:fluxoMind/pages/question.dart';
import 'package:fluxoMind/services/atividades.dart';
import 'package:fluxoMind/services/user.dart';
import 'package:google_fonts/google_fonts.dart';

class Selection extends StatelessWidget {
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
      home: SelectionPage(),
    );
  }
}

class SelectionPage extends StatefulWidget {
  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Center(child: Text("Selecione Uma Atividade", style: TextStyle(fontSize: 25))),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: List.generate(
                Atividade.numberAtividades,
                (index) {
                  return atividadeWidget(index);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget atividadeWidget(int index) {
    if (User.listAtv[index].status == true) {
      return FlatButton(
        onPressed: () {
          print(User.listAtv[1].status);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Question(User.listAtv[index])));
        },
        child: Text(
          (index + 1).toString(),
          style: TextStyle(fontSize: 30),
        ),
        shape: new CircleBorder(),
        color: Colors.black12,
      );
    } else {
      return FlatButton(
        onPressed: () => null,
        child: Icon(Icons.lock),
        shape: new CircleBorder(),
        color: Colors.black12,
      );
    }
  }
}
