import 'package:flutter/material.dart';
import 'package:untitled/algorithm.dart';
import 'package:untitled/model/attributes.dart';

import 'keys.dart';

void main() {
  // runApp(const MyApp());
  _incrementCounter();
}

void _incrementCounter() {
  // List<Attributes> relation = Attributes.stringToAttributes('A, B, C, D, E').toList();
  // // String fdString = "A,B->C,D; D,E-> C,E; C,D-> A,E; D,E-> A,B; D->E";
  // String fdString = "B-> D; A->B; C-> B";
  // final fds = stringToFds(fdString);
  //
  // Set<Set<Attributes>> decompose = decomposeSet(Attributes.attributesToListString(relation));
  // // print(decompose.join('\n'));
  //
  // // print(decompose.first);
  // // Tính bao đóng của tập
  // // Set<String> closureOfR = closure(relation, fds, decompose);
  // final result = closureOfSet(fds, [Attributes.of('A')]);
  // print('Closure of R: ${result.join(',')}'); // ABD
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  
  void _incrementCounter() {
  }

  @override
  Widget build(BuildContext context) {
    _incrementCounter();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Check ac',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
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
