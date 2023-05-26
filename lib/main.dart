import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realm/realm.dart';

import 'car.dart';

late Realm database;


void main() {
  final config = Configuration.local([Car.schema]);
  database = Realm(config);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + Realm Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Realm Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String maker = '';
  String model = '';
  String miles = '';
  List<dynamic> cars = [];

  @override
  void initState() {
    final allCars = database.all<Car>();
    for (var index=0; index < allCars.length; index++ ) {
      cars.add('${allCars[index].make} ${allCars[index].model} ${allCars[index].miles}');
    }
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      database.write(() {
        final car = Car(ObjectId(), maker, model: model, miles: int.parse(miles));
        database.add(car);
        cars.add('${car.make} ${car.model} ${car.miles}');
        maker = '';
        model = '';
        miles = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Total Cars: ${cars.length.toString()}'),
              SizedBox(
                  height : 300,
                  width : 400,
                  child : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        for (var details in cars) Text(details.toString()),
                      ],
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Maker',
                  ),
                  onChanged: (text) {
                    setState(() {
                      maker = text;
                    });
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Model',
                  ),
                  onChanged: (text) {
                    setState(() {
                      model = text;
                    });
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Miles(numbers only)',
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (text) {
                    setState(() {
                      miles = text;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
