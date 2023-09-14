import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo de dados',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _lados = 0;
  int _vitorias = 0;
  int _derrotas = 0;
  TextEditingController _palpiteController = TextEditingController();
  List<String> imagens = [
    'images/dado1.png',
    'images/dado2.png',
    'images/dado3.png',
    'images/dado4.png',
    'images/dado5.png',
    'images/dado6.png',
  ];

  bool _botaoPressionado = false;
  bool _mostrarResultado = false;

  void _dadoAleatorio() {
    String palpite = _palpiteController.text;
    if (int.tryParse(palpite) == null ||
        int.parse(palpite) < 1 ||
        int.parse(palpite) > 6) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro!'),
            content: Text('Por favor, digite um número entre 1 e 6'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      Random random = Random();
      int resultadoDado = random.nextInt(6) + 1;
      setState(() {
        _lados = resultadoDado - 1;
        _botaoPressionado = true;
        _mostrarResultado = true;
      });
      _atualizarContagem(resultadoDado, int.parse(palpite));
    }
  }

  void _atualizarContagem(int resultadoDado, int palpite) {
    if (palpite == resultadoDado) {
      setState(() {
        _vitorias++;
      });
    } else {
      setState(() {
        _derrotas++;
      });
    }
  }

  Widget _buildResultadoImage(int valorPalpite) {
    if (_mostrarResultado) {
      if (_lados + 1 == valorPalpite) {
        return Image.asset(
          'images/acertou.jpg',
          width: 200,
          height: 200,
        );
      } else {
        return Image.asset(
          'images/errou.jpg',
          width: 200,
          height: 200,
        );
      }
    } else {
      return SizedBox(); // Se não mostrar o resultado, retorna um widget vazio
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Jogo de Dados',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            heightFactor: 8,
            child: Text(
              'Qual a sua aposta?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: TextField(
              controller: _palpiteController,
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(labelText: 'Digite um número entre 1 e 6'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text('Vitórias: $_vitorias'),
          Text('Derrotas: $_derrotas'),
          Expanded(
            child: _botaoPressionado
                ? Image.asset(
                    imagens[_lados],
                  )
                : Image.asset(
                    'images/principal.png',
                    width: 200,
                    height: 200,
                  ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: _buildResultadoImage(
                int.tryParse(_palpiteController.text) ?? 0),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _dadoAleatorio,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
