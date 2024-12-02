import 'package:flutter/material.dart';

class CustomDropdownForm extends StatefulWidget {
  @override
  _CustomDropdownFormState createState() => _CustomDropdownFormState();
}

class _CustomDropdownFormState extends State<CustomDropdownForm> {
  String? _selectedCustomer = "A";
  final List<String> _customerList = ["A", "B", "C", "D"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Dropdown')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                _showCustomDialog();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCustomer ?? "Select Customer",
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView(
            shrinkWrap: true,
            children: _customerList.map((String customer) {
              return ListTile(
                leading: Icon(Icons.star, color: Colors.blue),
                title: Text(customer),
                onTap: () {
                  setState(() {
                    _selectedCustomer = customer;
                  });
                  Navigator.pop(context); // Close dialog
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
