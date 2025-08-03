import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/transactionProvider.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  String? _selectedCategory;
  String? _selectedMonth;
  double? _predictedValue;

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              hint: const Text('Select Category'),
              value: _selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue;
                  _predictedValue = null; // reset previous prediction
                });
              },
              items: transactionProvider.getCategories().map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text('Select Month'),
              value: _selectedMonth,
              onChanged: (newValue) {
                setState(() {
                  _selectedMonth = newValue;
                  _predictedValue = null; // reset previous prediction
                });
              },
              items: List.generate(12, (index) {
                return DropdownMenuItem(
                  value: (index + 1).toString(),
                  child: Text('Month ${index + 1}'),
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedCategory != null && _selectedMonth != null) {
                  // Get the historical value for selected category and month
                  double historicalValue =
                      transactionProvider.getHistoricalValue(
                    category: _selectedCategory!,
                    month: _selectedMonth!,
                  );

                  // Predict next month expense (simple 10% increase example)
                  setState(() {
                    _predictedValue = historicalValue * 1.1;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select both category and month'),
                    ),
                  );
                }
              },
              child: const Text('Predict Next Month Expense'),
            ),
            const SizedBox(height: 20),
            if (_predictedValue != null)
              Text(
                'Predicted Expense for next month: \$${_predictedValue!.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
