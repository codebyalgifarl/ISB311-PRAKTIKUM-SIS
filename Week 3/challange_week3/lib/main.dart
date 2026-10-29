import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  int counter = 0;

    void incrementCounter(){
      setState(() {
        counter++;
      });
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Stateless widget and Stateful widget'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                color : Colors.blue,
                height: 2,
                width: double.infinity,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.amber,
                child: Column(
                  children: <Widget>[
                    Text('Stateless', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text('Ini adalah contoh Stateless Widget pada Flutter.',style: TextStyle(fontSize: 18)),
                  ]
                )
              ),
              SizedBox(height: 16),
              Container(
                color : Colors.blue,
                height : 2,
                width : double.infinity
              ),
              SizedBox(height : 16),
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.orange,
                child: Column(
                  children: <Widget>[
                    Text('Stateful', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text('Nilai Counter: $counter',style: TextStyle(fontSize: 18)),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: incrementCounter,
                      child: Text('Tambah Counter', style: TextStyle(fontSize: 18)),
                    )
                  ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}