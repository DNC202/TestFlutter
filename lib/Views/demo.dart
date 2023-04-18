import 'package:flutter/material.dart';
import 'package:test/Models/Employee.dart';
import 'package:test/Models/Services.dart';

class DataTableDemo extends StatefulWidget {
  DataTableDemo() : super();

  final String title = 'Flutter Data Table';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  List<Employee>? _employees;
  GlobalKey<ScaffoldMessengerState>? _scaffoldKey;
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  Employee? _selectedEmployee;
  bool _isUpdating = false;
  String _titleProgress = "";
  @override
  void initState() {
    super.initState();
    _employees = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey?.currentState?.showSnackBar(SnackBar(content: message));
  }

  _createTable() {
    _showProgress("Creating Table...");
    Services.createTable().then((result) {
      if ('success' == result) {
        //show a snackbar
        _showSnackBar(context, result);
        _showProgress(widget.title);
      }
    });
  }

  _addEmployee() {
    if (_firstNameController!.text.isEmpty ||
        _lastNameController!.text.isEmpty) {
      print("Empty Fields");
      return;
    }
    _showProgress("Adding Employee...");
    Services.addEmployee(_firstNameController!.text, _lastNameController!.text)
        .then((result) {
      if ('success' == result) {}
      _clearValues();
    });
  }

  _getEmployees() {}

  _updateEmployee() {}

  _deleteEmployee() {}

  _clearValues() {
    _lastNameController?.text = '';
    _firstNameController?.text = '';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var isUpdating = _isUpdating;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _createTable();
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              _getEmployees();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration.collapsed(hintText: 'First Name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration.collapsed(hintText: 'Last Name'),
              ),
            ),
            // Add an Update bu
            isUpdating
                ? Row(
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () {
                          _updateEmployee();
                        },
                        child: Text('UPDATE'),
                      ),
                      SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isUpdating = false;
                          });
                          _clearValues();
                        },
                        child: Text('CANCEL'),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEmployee();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
