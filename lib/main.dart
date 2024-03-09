import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String equation = '';
  String result = '';

  void onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        equation = '';
        result = '';
      } else if (buttonText == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(equation);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = 'Error';
        }
      } else {
        equation += buttonText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    equation,
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 8.0),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      result,
                      style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1.0, color: Colors.black),
          GridView.builder(
            shrinkWrap: true,
            itemCount: buttonValues.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 1.0,
            ),
            itemBuilder: (context, index) {
              return CalculatorButton(
                buttonText: buttonValues[index],
                onPressed: () => onButtonPressed(buttonValues[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;

  CalculatorButton({required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(16.0),
        backgroundColor: isOperator(buttonText)
            ? Colors.orange
            : isSpecial(buttonText)
            ? Colors.grey[300]
            : null,
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: isSpecial(buttonText) ? FontWeight.bold : FontWeight.normal,
          color: isOperator(buttonText) ? Colors.white : null,
        ),
      ),
    );
  }

  bool isOperator(String buttonText) {
    return buttonText == '+' || buttonText == '-' || buttonText == '*' || buttonText == '/';
  }

  bool isSpecial(String buttonText) {
    return buttonText == 'C' || buttonText == '=';
  }
}

List<String> buttonValues = [
  '%', 'x^2', '<', '/',
  '7', '8', '9', '*',
  '4', '5', '6', '-',
  '1', '2', '3', '+',
  '0', '.', 'C', '=',
];
