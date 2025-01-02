import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';

import '../home/dashboard_screen.dart';
import 'ait_hisotry.dart';

class AITAutomationForm extends StatefulWidget {
  final bool isBackButtonExist;
  const AITAutomationForm({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  State<AITAutomationForm> createState() => _AITAutomationFormState();
}

class _AITAutomationFormState extends State<AITAutomationForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCustomer;
  String? _selectedFinancialYear;
  final _challanController = TextEditingController();
  final _dateController = TextEditingController();
  final _invoiceAmountController = TextEditingController();
  final _aitAmountController = TextEditingController();
  final _taxController = TextEditingController();
  final _differenceController = TextEditingController();
  final _remarksController = TextEditingController();

  // Sample data for dropdowns
  final List<String> _customers = [
    'Bengal Development Corporation',
    'Customer 2',
    'Customer 3',
  ];

  final List<String> _financialYears = [
    'FY: 2023-24',
    'FY: 2024-25',
    'FY: 2025-26',
  ];

  @override
  void dispose() {
    _challanController.dispose();
    _dateController.dispose();
    _invoiceAmountController.dispose();
    _aitAmountController.dispose();
    _taxController.dispose();
    _differenceController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _calculateDifference() {
    if (_invoiceAmountController.text.isNotEmpty &&
        _aitAmountController.text.isNotEmpty) {
      final invoiceAmount = double.parse(_invoiceAmountController.text);
      final aitAmount = double.parse(_aitAmountController.text);
      final difference = aitAmount - (invoiceAmount * 0.02);
      _differenceController.text = difference.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
              title: 'AIT Automation',
              isBackButtonExist: widget.isBackButtonExist,
              widget: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white,),
                onSelected: (value) {
                  if (value == 'History') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AitHistory())
                    );
                  }else if( value == 'Home') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashBoardScreen())
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'History',
                      child: Text('History'),
                    ),
                    PopupMenuItem<String>(
                      value: 'Home',
                      child: Text('Home'),
                    ),
                  ];
                },
              ),

          ),
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildDropdownField(
                  label: 'Customer Name',
                  value: _selectedCustomer,
                  items: _customers,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCustomer = value;
                    });
                  },
                  isRequired: true,
                ),
                _buildTextField(
                  controller: _challanController,
                  label: 'Challan Number',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icon(Icons.numbers)
                ),
                _buildDropdownField(
                  label: 'Financial Year',
                  value: _selectedFinancialYear,
                  items: _financialYears,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedFinancialYear = value;
                    });
                  },
                  isRequired: true,
                ),
                _buildTextField(
                  controller: _dateController,
                  label: 'Date',
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _invoiceAmountController,
                        label: 'Invoice Amount',
                        keyboardType: TextInputType.number,
                        isRequired: true,
                        onChanged: (value) => _calculateDifference(),
                        prefixIcon: Icon(Icons.numbers)
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _aitAmountController,
                        label: 'AIT Amount',
                        keyboardType: TextInputType.number,
                        isRequired: true,
                        onChanged: (value) => _calculateDifference(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _taxController,
                        label: 'Tax(%)',
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _differenceController,
                        label: 'Difference',
                        readOnly: true,
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                _buildTextField(
                  controller: _remarksController,
                  label: 'Remarks',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildAttachmentField(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    bool readOnly = false,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    Widget? suffixIcon,
    VoidCallback? onTap,
    void Function(String)? onChanged,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
        validator: isRequired
            ? (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        }
            : null,
        onTap: onTap,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: isRequired
            ? (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        }
            : null,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildAttachmentField() {
    return InkWell(
      onTap: () {
        // Handle attachment selection
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: const [
            Icon(Icons.attach_file, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Attachment',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}