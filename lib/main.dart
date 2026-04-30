```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ù',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _firstOperand = '';
  String _operator = '';
  String _secondOperand = '';
  bool _isNewOperation = true;

  void _onDigitPressed(String digit) {
    setState(() {
      if (_isNewOperation) {
        _display = digit;
        _isNewOperation = false;
      } else {
        if (_display.length < 12) {
          _display += digit;
        }
      }
    });
  }

  void _onOperatorPressed(String op) {
    setState(() {
      if (_operator.isNotEmpty && !_isNewOperation) {
        _calculateResult();
      }
      _firstOperand = _display;
      _operator = op;
      _isNewOperation = true;
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (!_display.contains('.')) {
        _display += '.';
        _isNewOperation = false;
      }
    });
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _firstOperand = '';
      _operator = '';
      _secondOperand = '';
      _isNewOperation = true;
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
        _isNewOperation = true;
      }
    });
  }

  void _onEqualsPressed() {
    setState(() {
      if (_operator.isNotEmpty) {
        _calculateResult();
        _operator = '';
        _isNewOperation = true;
      }
    });
  }

  void _calculateResult() {
    final double first = double.tryParse(_firstOperand) ?? 0;
    final double second = double.tryParse(_display) ?? 0;
    double result;

    switch (_operator) {
      case '+':
        result = first + second;
        break;
      case '-':
        result = first - second;
        break;
      case 'Ã':
        result = first * second;
        break;
      case 'Ã·':
        result = second != 0 ? first / second : double.nan;
        break;
      default:
        result = second;
    }

    if (result.isNaN || result.isInfinite) {
      _display = 'Ø®Ø·Ø£';
    } else {
      _display = result == result.roundToDouble()
          ? result.toInt().toString()
          : result.toStringAsFixed(4);
    }
  }

  Widget _buildButton(String text, {Color? color, double? width}) {
    return SizedBox(
      width: width ?? 70,
      height: 70,
      child: ElevatedButton(
        onPressed: () {
          if (text == 'C') {
            _onClearPressed();
          } else if (text == 'â«') {
            _onDeletePressed();
          } else if (text == '=') {
            _onEqualsPressed();
          } else if (text == '+' || text == '-' || text == 'Ã' || text == 'Ã·') {
            _onOperatorPressed(text);
          } else if (text == '.') {
            _onDecimalPressed();
          } else {
            _onDigitPressed(text);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
          foregroundColor: color != null ? Colors.white : Theme.of(context).colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ø­Ø§Ø³Ø¨Ù'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Display
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              _display,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
              textAlign: TextAlign.right,
              maxLines: 1,
            ),
          ),
          const Divider(height: 1),
          // Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRow(['C', 'â«', 'Ã·']),
                const SizedBox(height: 12),
                _buildRow(['7', '8', '9', 'Ã']),
                const SizedBox(height: 12),
                _buildRow(['4', '5', '6', '-']),
                const SizedBox(height: 12),
                _buildRow(['1', '2', '3', '+']),
                const SizedBox(height: 12),
                _buildRow(['0', '.', '='], lastRow: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> buttons, {bool lastRow = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
        if (button == '0' && lastRow) {
          return _buildButton(button, width: 152);
        }
        if (button == 'C') {
          return _buildButton(button, color: Colors.red.shade400);
        }
        if (button == '=') {
          return _buildButton(button, color: Theme.of(context).colorScheme.primary);
        }
        if (button == '+' || button == '-' || button == 'Ã' || button == 'Ã·') {
          return _buildButton(button, color: Theme.of(context).colorScheme.primaryContainer);
        }
        return _buildButton(button);
      }).toList(),
    );
  }
}
```