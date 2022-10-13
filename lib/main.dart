
import 'package:flutter/material.dart';
import 'package:new_notepad/one.dart';


void main()
{
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: splashs(),
  ));
}
class splashs extends StatefulWidget {
  const splashs({Key? key}) : super(key: key);

  @override
  State<splashs> createState() => _splashsState();
}

class _splashsState extends State<splashs> {

  @override
  void initState() {
  super.initState();

  gonext();
  }

  gonext() async {
    await Future.delayed(Duration(seconds: 10));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    return one();
    },));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color(0xD6E7E551),
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xFFFFFFFF),
              valueColor: AlwaysStoppedAnimation(Color(0xFF060505)),
              strokeWidth: 5,
            ),
          ),
        ));
  }


}
