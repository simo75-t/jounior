import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jounior/controllers/incomeExpenseController.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeExpensePage extends StatefulWidget {
  const IncomeExpensePage({super.key});

  @override
  State<IncomeExpensePage> createState() => _IncomeExpensePageState();
}

class _IncomeExpensePageState extends State<IncomeExpensePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Shared category lists (replace with dynamic loading if needed)
  List<String> incomeCategories = [];
  List<String> expenseCategories = [];

  // Income form controllers & state
  final _incomeFormKey = GlobalKey<FormState>();
  TextEditingController _incomeAmountController = TextEditingController();
  TextEditingController _incomeDescriptionController = TextEditingController();
  String? _selectedIncomeCategory;
  DateTime _incomeSelectedDate = DateTime.now();

  // Expense form controllers & state
  final _expenseFormKey = GlobalKey<FormState>();
  TextEditingController _expenseAmountController = TextEditingController();
  TextEditingController _expenseDescriptionController = TextEditingController();
  String? _selectedExpenseCategory;
  DateTime _expenseSelectedDate = DateTime.now();
  bool _expenseRecurrence = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      incomeCategories = prefs.getStringList('incomeCategories') ??
          ['Salary', 'Bonus', 'Investment'];
      expenseCategories = prefs.getStringList('expenseCategories') ??
          ['Food', 'Transport', 'Entertainment'];
      _selectedIncomeCategory =
          incomeCategories.isNotEmpty ? incomeCategories[0] : null;
      _selectedExpenseCategory =
          expenseCategories.isNotEmpty ? expenseCategories[0] : null;
    });
  }

  Future<void> _saveCategories(bool isIncome) async {
    final prefs = await SharedPreferences.getInstance();
    if (isIncome) {
      await prefs.setStringList('incomeCategories', incomeCategories);
    } else {
      await prefs.setStringList('expenseCategories', expenseCategories);
    }
  }

  Future<void> _showCategoryDialog({
    required bool isIncome,
    String? categoryToEdit,
  }) async {
    TextEditingController _categoryController =
        TextEditingController(text: categoryToEdit ?? '');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(categoryToEdit == null ? 'Add Category' : 'Edit Category'),
        content: TextField(
          controller: _categoryController,
          decoration: const InputDecoration(hintText: 'Enter Category Name'),
        ),
        actions: [
          if (categoryToEdit != null)
            TextButton(
              onPressed: () {
                setState(() {
                  List<String> categories =
                      isIncome ? incomeCategories : expenseCategories;
                  categories.remove(categoryToEdit);
                  if (isIncome) {
                    incomeCategories = categories;
                    _selectedIncomeCategory =
                        categories.isNotEmpty ? categories[0] : null;
                  } else {
                    expenseCategories = categories;
                    _selectedExpenseCategory =
                        categories.isNotEmpty ? categories[0] : null;
                  }
                  _saveCategories(isIncome);
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          TextButton(
            onPressed: () {
              final text = _categoryController.text.trim();
              if (text.isEmpty) return;
              setState(() {
                List<String> categories =
                    isIncome ? incomeCategories : expenseCategories;
                if (categoryToEdit == null) {
                  categories.add(text);
                } else {
                  int index = categories.indexOf(categoryToEdit);
                  if (index >= 0) categories[index] = text;
                }
                if (isIncome) {
                  incomeCategories = categories;
                  _selectedIncomeCategory = text;
                } else {
                  expenseCategories = categories;
                  _selectedExpenseCategory = text;
                }
                _saveCategories(isIncome);
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(bool isIncome) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isIncome ? _incomeSelectedDate : _expenseSelectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isIncome) {
          _incomeSelectedDate = picked;
        } else {
          _expenseSelectedDate = picked;
        }
      });
    }
  }

  void _submitIncome() {
    if (_incomeFormKey.currentState?.validate() ?? false) {
      double amount = double.tryParse(_incomeAmountController.text) ?? 0;
      String date = DateFormat('yyyy-MM-dd').format(_expenseSelectedDate);
      String category = _selectedIncomeCategory ?? '';
      String description = _incomeDescriptionController.text;

      print('Income submitted: Amount=$amount, Category=$category, Date=$date');

      ExpenseIncomeController.createIncome(
          amount, date, category, description, false);
    }
  }

  void _submitExpense() {
    if (_expenseFormKey.currentState?.validate() ?? false) {
      double amount = double.tryParse(_expenseAmountController.text) ?? 0;
      String date = DateFormat('yyyy-MM-dd').format(_expenseSelectedDate);
      String category = _selectedExpenseCategory ?? '';
      String description = _expenseDescriptionController.text;
      bool recurence = _expenseRecurrence;

      print(
          'Expense submitted: Amount=$amount, Category=$category, Date=$date, Recurrence=$recurence');

      ExpenseIncomeController.createExpense(
          amount, date, category, description, recurence);
    }
  }

  @override
  Widget build(BuildContext context) {
    final greenColor = Colors.green;
    final redColor = Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Income & Expense'),
        // backgroundColor: const Color.fromARGB(255, 37, 116, 78),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Income'),
            Tab(text: 'Expense'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Income Form Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _incomeFormKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _incomeAmountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixIcon: Icon(Icons.add, color: greenColor),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter amount' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _incomeDescriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedIncomeCategory,
                    items: incomeCategories
                        .map((cat) =>
                            DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedIncomeCategory = value),
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showCategoryDialog(isIncome: true),
                        child: const Text('Add Category'),
                      ),
                      ElevatedButton(
                        onPressed: _selectedIncomeCategory == null
                            ? null
                            : () => _showCategoryDialog(
                                isIncome: true,
                                categoryToEdit: _selectedIncomeCategory),
                        child: const Text('Edit/delete Category'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('EEE d MMM yyyy')
                          .format(_incomeSelectedDate)),
                      ElevatedButton(
                        onPressed: () => _selectDate(true),
                        child: const Text(
                          'Pick Date',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: greenColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _submitIncome,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: greenColor),
                    child: const Text(
                      'Submit Income',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expense Form Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _expenseFormKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _expenseAmountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixIcon: Icon(Icons.remove, color: redColor),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter amount' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _expenseDescriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedExpenseCategory,
                    items: expenseCategories
                        .map((cat) =>
                            DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedExpenseCategory = value),
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showCategoryDialog(isIncome: false),
                        child: const Text('Add Category'),
                      ),
                      ElevatedButton(
                        onPressed: _selectedExpenseCategory == null
                            ? null
                            : () => _showCategoryDialog(
                                isIncome: false,
                                categoryToEdit: _selectedExpenseCategory),
                        child: const Text('Edit/delete Category'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _expenseRecurrence,
                        onChanged: (val) =>
                            setState(() => _expenseRecurrence = val ?? false),
                        activeColor: redColor,
                      ),
                      Text('Recursive Expense',
                          style: TextStyle(color: redColor)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('EEE d MMM yyyy')
                          .format(_expenseSelectedDate)),
                      ElevatedButton(
                        onPressed: () => _selectDate(false),
                        child: const Text(
                          'Pick Date',
                          style: TextStyle(color: Colors.white),
                        ),
                        style:
                            ElevatedButton.styleFrom(backgroundColor: redColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _submitExpense,
                    style: ElevatedButton.styleFrom(backgroundColor: redColor),
                    child: const Text(
                      'Submit Expense',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
