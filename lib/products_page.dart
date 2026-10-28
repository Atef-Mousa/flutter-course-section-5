import 'package:flutter/material.dart' ;
import 'package:go_router/go_router.dart';
class ProductsPage extends StatefulWidget{
  @override
  State<ProductsPage> createState() {
    return ProductsPageState() ;
  }
}

class ProductsPageState extends State<ProductsPage>{

  @override
  void initState() {
    print(" start Products");
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    print(" finish Products");
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
            Text("welcome to Products Page"),
            ElevatedButton(onPressed: (){
              context.pop();
            }, child: Text("go back"))
          ],
        ),
      ),
    );
  }
}