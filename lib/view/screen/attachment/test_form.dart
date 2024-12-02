import 'package:flutter/material.dart';

class TestFormScreen extends StatefulWidget {
  const TestFormScreen({super.key});

  @override
  State<TestFormScreen> createState() => _TestFormScreenState();
}

class _TestFormScreenState extends State<TestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _challanNo = TextEditingController();
  final List<String> _customerList = ["A", "B", "C", "D"];
  String? _selectedCustomer = "A"; // Default value matches one in the list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Form'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButtonFormField(
                  value: _selectedCustomer, // Set a matching default value
                  items: _customerList.map((String customer) {
                    return DropdownMenuItem(
                      value: customer, // Ensure `value` matches
                      child: Row(
                        children: [
                          Icon(Icons.star),
                          SizedBox(width: 8),
                          Text(customer),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCustomer = newValue; // Update selected value
                      print('Selected Customer: $_selectedCustomer');
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Customer',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a customer';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _challanNo,
                  decoration: InputDecoration(
                    labelText: 'Challan No:',
                    hintText: '25124500245',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter challan no';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('Form Submitted');
                      print('Selected Customer: $_selectedCustomer');
                      print('Challan No: ${_challanNo.text}');
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
