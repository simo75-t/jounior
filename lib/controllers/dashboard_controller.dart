class DashboardController {
  // Simulated backend data (replace with real API calls)
  static Future<Map<String, double>> getIncomeCategories() async {
    return {
      'Salary': 1000.0,
      'Freelance': 500.0,
    };
  }

  static Future<Map<String, double>> getExpenseCategories() async {
    return {
      'Food': 200.0,
      'Transport': 150.0,
      'Entertainment': 100.0,
    };
  }

  static Future<double> getTotalIncome() async {
    return 1500.0;
  }

  static Future<double> getTotalExpenses() async {
    return 450.0;
  }

  // Call these functions in your view (DashboardPage) to get real data
}
