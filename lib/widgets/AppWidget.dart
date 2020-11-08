import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class AppWidget extends StatelessWidget {
  static double sizeScreenWidth = 0;
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static Widget formText(BuildContext context, TextEditingController textEditingController, String text, IconData icon, {bool password = false}) {
    return SizedBox(
      height: 70,
      width: MediaQuery.of(context).size.width - 30,
      child: Container(
        decoration: new BoxDecoration(color: Color.fromRGBO(242, 152, 41, 0.95), borderRadius: new BorderRadius.all(new Radius.circular(20))),
        child: TextFormField(
          controller: textEditingController,
          autofocus: false,
          decoration: InputDecoration(
            hoverColor: Colors.red,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Color.fromRGBO(242, 152, 41, 0.95), width: 2.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Color.fromRGBO(242, 152, 41, 0.95), width: 2.5),
            ),
            hintText: text,
            prefixIcon: Icon(
              icon,
              color: Colors.white,
            ),
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(
            color: Colors.white,
          ),
          obscureText: password,
          textAlign: TextAlign.start,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some value';
            }
            return null;
          },
        ),
      ),
    );
  }

  static Widget button(String text, {@required VoidCallback voidCallback, double sizeFont, double width = 300, double height = 50}) {
    return SizedBox(
      width: width,
      height: height,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        color: Color.fromRGBO(242, 152, 41, 0.95),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: sizeFont,
          ),
        ),
        onPressed: voidCallback,
      ),
    );
  }

  static dialog(BuildContext context, String title, String message, {VoidCallback voidCallback}) {
    showDialog(
      context: context,
      builder: (context) => NetworkGiffyDialog(
        image: Image.asset('assets/images/gif.gif'),
        title: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
        description: Text(
          message,
          textAlign: TextAlign.center,
        ),
        onlyOkButton: true,
        buttonOkColor: Color.fromRGBO(217, 89, 123, 1),
        entryAnimation: EntryAnimation.TOP,
        onOkButtonPressed: () {
          if (voidCallback == null) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pop();
            voidCallback();
          }
        },
      ),
    );
  }

  //* Função responsavel por fazer a mudança de telas, recebe como parâmetro um Widget(Deve ser uma screen, caso não, resulta em erro)
  static screenChange(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }
}
