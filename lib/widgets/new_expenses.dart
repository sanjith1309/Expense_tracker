import 'dart:html';

import 'package:exptracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class newExpense extends StatefulWidget {
  const newExpense({super.key, required this.onaddExpense});

  final void Function(Expense expense) onaddExpense;

  @override
  State<newExpense> createState() => _newExpenseState();
}

class _newExpenseState extends State<newExpense> {
  final _titleController = TextEditingController();
  final _amtController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  Widget build(BuildContext context) {
    void _showdatepicker() async {
      final now = DateTime.now();
      final firstdate = DateTime(now.year - 1, now.month, now.day);
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstdate,
        lastDate: now,
      );
      setState(() {
        _selectedDate = pickedDate;
      });
    }

    void _submitExpenseData() {
      final enteredAmt = double.tryParse(_amtController.text);
      final amountIsInvalid = enteredAmt == null || enteredAmt <= 0;
      if (_titleController.text.trim().isEmpty ||
          amountIsInvalid ||
          _selectedDate == null) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text('give some correct input to fields'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('CLOSE'),
              )
            ],
          ),
        );
        return;
      }
      widget.onaddExpense(
        Expense(
            title: _titleController.text,
            amount: enteredAmt,
            date: _selectedDate!,
            category: _selectedCategory),
      );
      Navigator.pop(context);
    }

    @override
    void dispose() {
      _titleController.dispose();
      _amtController.dispose();
      super.dispose();
    }

    final keyboardsize = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, Constraints) {
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardsize + 16),
            child: Column(
              children: [
                if (Constraints.maxWidth >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text("Title"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amtController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: "₹",
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                  ),
                if (Constraints.maxWidth >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (_selectedCategory == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(_selectedDate == null
                                ? 'No date Selected'
                                : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: _showdatepicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amtController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: "₹",
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(_selectedDate == null
                                ? 'No date Selected'
                                : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: _showdatepicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                if (Constraints.maxWidth >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: Text("Save Expense"),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (_selectedCategory == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: Text("Save Expense"),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
