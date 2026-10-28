import 'package:flutter/material.dart' ;
import 'package:go_router/go_router.dart';
class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() {
    return HomePageState() ;
  }
}

class HomePageState extends State<HomePage>{

  @override
  void initState() {
    print(" start Home");
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    print(" finish Home");
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        Column(
          children: [
            Text("welcome to Home Page"),
            ElevatedButton(onPressed: (){
              context.pop() ;
            }, child: Text("go back"))
          ],
        ),
      ),
    );
  }
}