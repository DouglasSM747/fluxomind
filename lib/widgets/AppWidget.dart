import 'package:flutter/material.dart';
import 'package:fluxoMind/services/atividades.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static TextFormField formText(TextEditingController textEditingController, String text, IconData icon, {bool password = false}) {
    return TextFormField(
      controller: textEditingController,
      autofocus: false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.black, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.black, width: 1.5),
        ),
        hintText: text,
        prefixIcon: Icon(
          icon,
          color: Colors.black,
        ),
        hintStyle: TextStyle(color: Colors.black),
      ),
      style: TextStyle(color: Colors.black),
      obscureText: password,
      textAlign: TextAlign.start,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some value';
        }
        return null;
      },
    );
  }

  static Widget button(String text, VoidCallback voidCallback, {double sizeFont, double width = 200, double height = 50}) {
    return SizedBox(
      width: width,
      height: height,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: Text(text, style: TextStyle(fontSize: sizeFont)),
        onPressed: voidCallback,
      ),
    );
  }

  static dialog(BuildContext context, String title, String message, {VoidCallback voidCallback}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                if (voidCallback == null) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  voidCallback();
                }
              },
              child: Text("Ok"),
            )
          ],
        );
      },
    );
  }

  static screenChange(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }
}
