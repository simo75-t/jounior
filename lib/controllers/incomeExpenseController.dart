// expense_income_controller.dart
import 'dart:convert';
import 'package:jounior/controllers/AppController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ExpenseIncomeController {
  static Future<void> createExpense(double amount, String date, String category,
      String description, bool recurence) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? "";

    final url = Uri.parse('${AppController.baseUrl}/api/expenses/expenses/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'amount': amount,
          'date': date,
          'category': category,
          'description': description,
          'is_recurring': recurence,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Expense submitted: $data");
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("An Error Occurred $e");
    }
  }

  static Future<void> createIncome(double amount, String date, String category,
      String description, bool recurence) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? "";

    final url = Uri.parse('${AppController.baseUrl}/api/expenses/incomes/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'amount': amount,
          'date': date,
          'category': category,
          'description': description,
          'is_recurring': recurence,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Income submitted: $data");
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("An Error Occurred $e");
    }
  }

  static Future<List<String>> fetchExpenseCategories() async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? "";

    final url =
        Uri.parse('${AppController.baseUrl}/api/expenses/expense-categories/');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data);
      } else {
        print("Error fetching expense categories: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception fetching expense categories: $e");
      return [];
    }
  }

  static Future<List<String>> fetchIncomeCategories() async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? "";

    final url =
        Uri.parse('${AppController.baseUrl}/api/expenses/income-categories/');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data);
      } else {
        print("Error fetching income categories: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception fetching income categories: $e");
      return [];
    }
  }
}
