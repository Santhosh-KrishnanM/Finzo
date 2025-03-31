import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = "0";
  double _num1 = 0;
  double _num2 = 0;
  String _operator = "";

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _display = "0";
        _num1 = 0;
        _num2 = 0;
        _operator = "";
      } else if (buttonText == "=") {
        _num2 = double.parse(_display);
        switch (_operator) {
          case "+":
            _display = (_num1 + _num2).toString();
            break;
          case "-":
            _display = (_num1 - _num2).toString();
            break;
          case "✖":
            _display = (_num1 * _num2).toString();
            break;
          case "➗":
            _display = (_num1 / _num2).toString();
            break;
        }
        _operator = "";
      } else if (["+", "-", "✖", "➗"].contains(buttonText)) {
        _num1 = double.parse(_display);
        _operator = buttonText;
        _display = "0";
      } else {
        if (_display == "0") {
          _display = buttonText;
        } else {
          _display += buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            textStyle:
                const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            minimumSize: const Size(88, 88),
          ),
          onPressed: () => _onButtonPressed(buttonText),
          child: Text(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            alignment: Alignment.centerRight,
            child: Text(_display,
                style: const TextStyle(
                    fontSize: 48.0, fontWeight: FontWeight.bold)),
          ),
          const Expanded(child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton("7"),
              buildButton("8"),
              buildButton("9"),
              buildButton("➗")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton("4"),
              buildButton("5"),
              buildButton("6"),
              buildButton("✖")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton("1"),
              buildButton("2"),
              buildButton("3"),
              buildButton("-")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton("C"),
              buildButton("0"),
              buildButton("="),
              buildButton("+")
            ],
          ),
        ],
      ),
    );
  }
}
