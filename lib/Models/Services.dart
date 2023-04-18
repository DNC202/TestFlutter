import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Employee.dart';

class Services {
  static const ROOT = 'http://localhost/EmployeesDB/employee_actions.php';
  static const _Create_Table_Action = 'Create_Table';
  static const _Get_all_Action = 'Get_all';
  static const _Add_emp_Action = 'Add_emp';
  static const _Update_emp_Action = 'Update_emp';
  static const _Delete_emp_Action = 'Delete_emp';

  // Create table Employees
  static Future<String> createTable() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _Create_Table_Action;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Create table Response: ${response.body}');
      return response.body;
    } catch (e) {
      return "error";
    }
  }

  static Future<List<Employee>?> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _Get_all_Action;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Get Employees Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Employee>? list = parseResponse(response.body);
        return list;
      }
    } catch (e) {
      print(e);
    }
  }

  static List<Employee> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.Map<Employee>((json) => Employee.fromJson(json)).toList();
  }

  static Future<String?> addEmployee(String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _Add_emp_Action;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Add Employee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String?> updateEmployee(
      int empId, String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _Update_emp_Action;
      map['emp_id'] = empId;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Add Employee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}
