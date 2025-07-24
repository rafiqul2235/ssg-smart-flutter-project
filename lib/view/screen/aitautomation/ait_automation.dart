import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/body/customer_details.dart';
import 'package:ssg_smart2/data/model/body/financial_year.dart';
import 'package:ssg_smart2/data/model/response/user_info_model.dart';
import 'package:ssg_smart2/utill/number_formatter.dart';
import 'package:ssg_smart2/view/screen/aitautomation/widgets/pdf_preview.dart';
import '../../../data/model/body/ait_details.dart';
import '../../../provider/user_provider.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/file_security_helper.dart';
import '../home/dashboard_screen.dart';
import 'ait_hisotry.dart';
import '../../../provider/attachment_provider.dart';

class AITAutomationScreen extends StatefulWidget {
  final AitDetail? editAitDetail;


  const AITAutomationScreen({Key? key, this.editAitDetail}) : super(key: key);

  @override
  _AITAutomationScreenState createState() => _AITAutomationScreenState();
}

class _AITAutomationScreenState extends State<AITAutomationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();


  // Controllers for form fields
  late TextEditingController _challanNumberController =
  TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late TextEditingController _challanDateController = TextEditingController();
  late TextEditingController _invoiceAmountController =
  TextEditingController();
  late TextEditingController _baseAmountController = TextEditingController();
  late TextEditingController _aitAmountController = TextEditingController();
  late TextEditingController _taxController = TextEditingController();
  late TextEditingController _differenceController = TextEditingController();
  late TextEditingController _remarksController = TextEditingController();
  bool _isExcludedVat = false;

  UserInfoModel? userInfoModel;

  // Form state variables
  CustomerDetails? _selectedCustomer;
  List<CustomerDetails> _filteredCustomers = [];
  late List<FinancialYear> financialYears;
  String? _selectedFinancialYear;
  bool _isLoading = false;




  @override
  void initState() {
    super.initState();
    _addOldAit();
    _intData();
    _setupCommaFormatting(_invoiceAmountController);
    _setupCommaFormatting(_baseAmountController);
    _setupCommaFormatting(_aitAmountController);
    print('fn-year(initSt): ${_selectedFinancialYear}');
  }
  void _setupCommaFormatting(TextEditingController controller) {
    controller.addListener((){
      final text = controller.text;
      final formatted = NumberFormatterUtil.format(text);
      if (text != formatted) {
        controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length)
        );
      }
    });
  }
  _addOldAit() async {
    _selectedCustomer = CustomerDetails(
        customerId: widget.editAitDetail?.customerId,
        customarName: widget.editAitDetail?.customerName,
        accountNumber: widget.editAitDetail?.customerAccount
    );
    _selectedFinancialYear = widget.editAitDetail?.financialYear;
    _challanNumberController = TextEditingController(text: widget.editAitDetail?.challanNo ?? '');
    _challanDateController = TextEditingController(text: widget.editAitDetail?.challanDate ?? '');
    _invoiceAmountController = TextEditingController(text: widget.editAitDetail?.invoiceAmount ?? '');
    _aitAmountController = TextEditingController(text: widget.editAitDetail?.aitAmount ?? '');
    _baseAmountController = TextEditingController(text: widget.editAitDetail?.baseAmount ?? '');
    _taxController = TextEditingController(text: widget.editAitDetail?.tax ?? '');
    _differenceController = TextEditingController(text: widget.editAitDetail?.difference ?? '');
    _remarksController = TextEditingController(text: widget.editAitDetail?.remarks ?? '');

  }

  _intData() async {
    // Provider.of<UserProvider>(context, listen: false).resetLoading();
    userInfoModel = Provider.of<UserProvider>(context,listen: false).userInfoModel;
    print("userinfo: ${userInfoModel}");
    final provider = Provider.of<AttachmentProvider>(context, listen: false);
    // final provider = context.watch<AttachmentProvider>();
    provider.fetchAitEssentails(userInfoModel!.orgId!, userInfoModel!.salesRepId!);
    financialYears = provider.financialYearsList;

    setState(() {
      _selectedFinancialYear = financialYears.isNotEmpty ? financialYears.first.description : null;
    });
  }


  // Number formatter for currency
  final _currencyFormatter = NumberFormat("#,##0.00", "en_US");

  // Customer search dialog
  void _showCustomerDialog(List<CustomerDetails> customers) {
    _filteredCustomers = customers;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text(
                      'Select Customer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search customers...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.grey[50],
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          // Filter customer baseed on search text
                          _filteredCustomers = customers.where((customer) {
                            final customerName = customer.customarName?.toLowerCase() ?? '';
                            final accountNumber = customer.accountNumber?.toLowerCase() ?? '';
                            final searchText = value.toLowerCase();
                            return customerName.contains(searchText) || accountNumber.contains(searchText);
                          }).toList();
                        });
                      },
                    ),
                  ],
                ),
                content: Container(
                  width: double.maxFinite,
                  height: 300,
                  child: ListView.builder(
                    itemCount: _filteredCustomers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          '${_filteredCustomers[index].customarName!}(${_filteredCustomers[index].accountNumber})',
                          style: TextStyle(fontSize: 16),
                        ),
                        leading: Icon(Icons.business),
                        selected: customers[index] == _selectedCustomer,
                        selectedTileColor: Colors.blue.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedCustomer = _filteredCustomers[index];
                          });
                          this.setState(() {});
                          Navigator.pop(context);
                          _searchController.clear();
                        },
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _searchController.clear();
                    },
                    child: Text('Cancel'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // file picker variable
  PlatformFile? _attachmentFile;
  final List<String> _allowedExtensions = [
    'pdf',
  ];

  Future<void> _pickFile() async {
    try {
      final secureFile = await pickSecureFile(context);

      if (secureFile != null) {
        // Check if file is PDF
        if (secureFile.extension?.toLowerCase() != 'pdf') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Only PDF files are allowed'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        //Check file size again as an additional safety measure
        if (secureFile.size > FileSecurityHelper.MAX_FILE_SIZE) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File is large. Maximum size allowed is ${(FileSecurityHelper.MAX_FILE_SIZE / (1024 * 1024)).toStringAsFixed(1)}MB'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Handle image compression if needed
        if (['jpg', 'jpeg', 'png'].contains(secureFile.extension?.toLowerCase())) {
          final compressedFile = await _compressImageFile(secureFile);
          if (compressedFile != null) {
            // Check compressed file size
            final compressedSize = await compressedFile.length();
            if (compressedSize > FileSecurityHelper.MAX_FILE_SIZE) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Compressed file is still too large. Please select a smaller image.'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            setState(() {
              _attachmentFile = PlatformFile(
                  name: compressedFile.path.split('/').last,
                  path: compressedFile.path,
                  size: compressedSize
              );
            });
          }
        } else {
          setState(() {
            _attachmentFile = secureFile;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing file: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      print("Error: $e");
    }
  }

  // Compression for images
  Future<File?> _compressImageFile(PlatformFile file) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath = "${tempDir.path}/compressed_${file.path?.split('/').last}";
    var compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.path!,
        targetPath,
        quality: 70
    );
    if (compressedFile != null && compressedFile is XFile) {
      return File(compressedFile.path);
    }else {
      return compressedFile as File?;
    }
  }

  // Helper method to show loading dialog
  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  void _calculatedBaseAmount() {
    if (_invoiceAmountController.text.isNotEmpty) {
      final invoiceAmount = double.tryParse(NumberFormatterUtil.unformat(_invoiceAmountController.text)) ?? 0.0;
      final baseAmount = (invoiceAmount * 100) /115;
      _baseAmountController.text = baseAmount.toStringAsFixed(2);
    }else {
      _baseAmountController.clear();
    }
  }

  // Calculate difference amount
  void _calculateDifference() {
    if (_baseAmountController.text.isNotEmpty &&
        _aitAmountController.text.isNotEmpty &&
        _taxController.text.isNotEmpty) {
      try {
        final baseAmount =
        double.parse(_baseAmountController.text.replaceAll(',', ''));
        final aitAmount =
        double.parse(_aitAmountController.text.replaceAll(',', ''));
        final tax = double.parse(_taxController.text.replaceAll(',', ''));
         final difference = ((baseAmount * tax) /100) - aitAmount;
        _differenceController.text = _currencyFormatter.format(difference);
      } catch (e) {
        _differenceController.text = '';
      }
    }
  }

  // Form submission
  Future<void> _submitForm() async {
    print('fn-year(submitForm): $_selectedFinancialYear');

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Map<String, dynamic> data = {
        'customerId' : _selectedCustomer?.customerId,
        'customerAccount': _selectedCustomer?.accountNumber,
        'customerName' : _selectedCustomer?.customarName,
        'customerType' : _selectedCustomer?.customerType,
        'customerCategory' : _selectedCustomer?.customerCategory,
        'billToAddress' : _selectedCustomer?.billToAddress,
        'salesSection' : _selectedCustomer?.salesSection,
        'statusFlg' : 'Initiated',
        'challanNo' : _challanNumberController.text,
        'challanDate': _challanDateController.text,
        'financialYear': _selectedFinancialYear,
        'invoiceType': !_isExcludedVat ? 'General' : 'Excluding VAT',
        'invoiceAmount' : NumberFormatterUtil.unformat(_invoiceAmountController.text),
        'baseAmount': NumberFormatterUtil.unformat(_baseAmountController.text),
        'aitAmount' : NumberFormatterUtil.unformat(_aitAmountController.text),
        'tax' : _taxController.text,
        'difference' : _differenceController.text,
        'remarks': _remarksController.text,
        'empId': userInfoModel?.employeeNumber,
        'empName': userInfoModel?.fullName,
        'personId': userInfoModel?.personId,
        'userId': userInfoModel?.userId,
        'deptName': userInfoModel?.department,
        'designation': userInfoModel?.designation,
        'orgId': userInfoModel?.orgId,
        'orgName': userInfoModel?.orgName,
        'attachment': _attachmentFile != null ? File(_attachmentFile!.path!) : null
      };

      try {
        // TODO: Implement your API call here
        final provider = Provider.of<AttachmentProvider>(context, listen: false);
        bool isDuplicate = await provider.checkDuplicatechallan(_challanNumberController.text);

        if (isDuplicate && widget.editAitDetail == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Challan number is already exist'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          return;
        }

        // update: and entry
        if (widget.editAitDetail != null) {
          await provider.updateAitEnty(widget.editAitDetail!.headerId,data);
        }else {
          await provider.submitAITAutomationForm(data);
        }


        if (provider.aitResponse!.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.editAitDetail != null ? 'Updated successfully':'Submitted successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
        // Wait for snackbar to display
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AitHistory())
        );

        // Reset form after successful submission
        _formKey.currentState!.reset();
        setState(() {
          _selectedCustomer = null;
          _selectedFinancialYear = null;
          _isExcludedVat = false;
          _attachmentFile = null;
          _challanDateController.clear();
          _invoiceAmountController.clear();
          _baseAmountController.clear();
          _aitAmountController.clear();
          _taxController.clear();
          _differenceController.clear();
          _remarksController.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting form: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttachmentProvider>();
    final customers = provider.customersList;
    // final financialYears = provider.financialYearsList;
    // print('fn-year(build): $_selectedFinancialYear');
    // if (widget.editAitDetail == null && financialYears.isNotEmpty){
    //   _selectedFinancialYear = financialYears[0].description;
    //   print('fn-year(buildIn): $_selectedFinancialYear');
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editAitDetail != null ? 'Edit AIT Automation':'AIT Automation'),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)
        ),
        backgroundColor: Colors.red,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        actions: [
          PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == 'history') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AitHistory())
                  );
                } else if (value == 'home') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashBoardScreen())
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                    value: 'history',
                    child: Text('History')
                ),
                PopupMenuItem<String>(
                    value: 'home',
                    child: Text('Home')
                )
              ]
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Name
                  _buildFormLabel('Customer Name *'),
                  TextFormField(
                    readOnly: true,
                    decoration: _buildInputDecoration(
                      _selectedCustomer?.customarName ?? 'Select customer',
                      Icons.business_outlined,
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    onTap: () => _showCustomerDialog(customers),
                    validator: (value) {
                      print('click on button for customer: ${_selectedCustomer}');
                      if (_selectedCustomer?.customerId == null) {
                        return 'Please select a customer';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Challan Number
                  _buildFormLabel('Challan Number *'),
                  TextFormField(
                    controller: _challanNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d{1,15}'))
                    ],
                    decoration: _buildInputDecoration(
                      'Enter challan number',
                      Icons.receipt_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter challan number';
                      }
                      if (value.length < 15) {
                        return 'Challan number must be 15 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Financial Year
                  _buildFormLabel('Financial Year *'),
                  DropdownButtonFormField<String>(
                    value: _selectedFinancialYear,
                    decoration: _buildInputDecoration(
                      'Select financial year',
                      Icons.calendar_today_outlined,
                    ),
                    items: financialYears.map((FinancialYear year) {
                      return DropdownMenuItem<String>(
                        value: year.description,
                        child: Text(year.description ?? ''),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedFinancialYear = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select financial year';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Challan Date
                  _buildFormLabel('Challan Date *'),
                  TextFormField(
                    controller: _challanDateController,
                    readOnly: true,
                    decoration: _buildInputDecoration(
                      'Select challan date',
                      Icons.event_outlined,
                    ),
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              dialogTheme: DialogThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setState(() {
                          _challanDateController.text =
                              DateFormat('MMM dd, yyyy').format(date);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select challan date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Excluding VAT Checkbox
                  CheckboxListTile(
                    title: Text(
                      'Excluding VAT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    value: _isExcludedVat,
                    onChanged: (value) {
                      setState(() {
                        _isExcludedVat = value!;
                        if (!_isExcludedVat) {
                          _calculatedBaseAmount();
                        }else {
                          _baseAmountController.clear();
                        }
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Invoice Amount
                  _buildFormLabel('Invoice Amount *'),
                  TextFormField(
                    controller: _invoiceAmountController,
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          // RegExp(r'^\d+\.?\d{0,2}')
                          RegExp(r'^\d+\.?\d{0,2}$|^[0-9,]+\.?\d{0,2}$')
                      )
                    ],
                    decoration: _buildInputDecoration(
                      'Enter invoice amount',
                      Icons.attach_money_outlined,
                    ),
                    onChanged: (value) {
                      if (!_isExcludedVat) {
                        _calculatedBaseAmount();
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter invoice amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Base Amount
                  _buildFormLabel('Base Amount *'),
                  TextFormField(
                    controller: _baseAmountController,
                    readOnly: !_isExcludedVat,
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          // RegExp(r'^\d+\.?\d{0,2}')
                          RegExp(r'^\d+\.?\d{0,2}$|^[0-9,]+\.?\d{0,2}$')
                      )
                    ],
                    decoration: _buildInputDecoration(
                      'Enter base amount',
                      Icons.calculate_outlined,
                    ),
                    onChanged: (value) {

                      _calculateDifference();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter base amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  // AIT Amount
                  _buildFormLabel('AIT Amount *'),
                  TextFormField(
                    controller: _aitAmountController,
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          // RegExp(r'^\d+\.?\d{0,2}')
                          RegExp(r'^\d+\.?\d{0,2}$|^[0-9,]+\.?\d{0,2}$')
                      )
                    ],
                    decoration: _buildInputDecoration(
                      'Enter AIT amount',
                      Icons.money_outlined,
                    ),
                    onChanged: (value) {

                      _calculateDifference();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter AIT amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Tax Amount
                  _buildFormLabel('Tax(%) *'),
                  TextFormField(
                    controller: _taxController,
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    decoration: _buildInputDecoration(
                      'Enter tax amount',
                      Icons.receipt_long_outlined,
                    ),
                    onChanged: (value) {
                      _calculateDifference();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter tax amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Difference (Read-only)
                  _buildFormLabel('Difference'),
                  TextFormField(
                    controller: _differenceController,
                    readOnly: true,
                    decoration: _buildInputDecoration(
                      'Calculated difference',
                      Icons.difference_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Difference field can not be empty.";
                      }
                    },
                  ),
                  SizedBox(height: 24),

                  // Remarks
                  _buildFormLabel('Remarks'),
                  TextFormField(
                    controller: _remarksController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter any additional remarks...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(height: 24),

                  // File Attachment
                  _buildFormLabel('Attachment'),
                  _buildAttachmentFormField(),
                  SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text(widget.editAitDetail != null ? 'Update':'Submit',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildAttachmentFormField() {
    return FormField<PlatformFile?>(
      initialValue: _attachmentFile,
      validator: (value) {
        print('logic1:${value==null}');
        print('logic2:${widget.editAitDetail == null}');
        if (value == null && widget.editAitDetail == null) {
          return 'Please select an attachment file';
        }
        return null;
      },
      builder: (FormFieldState<PlatformFile?> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: state.hasError ? Colors.red : Colors.black26,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Allowed file types: ${_allowedExtensions.join(', ')}',
                      style: titilliumRegular.copyWith(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (_attachmentFile != null)
                    ListTile(
                      title: Text(
                        _attachmentFile!.name,
                        maxLines: 1,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PdfPreviewPage(fileName: _attachmentFile!.name!,filePath: _attachmentFile!.path!)
                            )
                        );
                      },
                      subtitle: Text(
                        'Size: ${(_attachmentFile!.size / 1024).toStringAsFixed(2)} KB',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _attachmentFile = null;
                          });
                          state.didChange(null); // Update FormField state
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  if (_attachmentFile == null)
                    ListTile(
                      title: Text(
                        'No file chosen',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _pickFile();
                        state.didChange(_attachmentFile); // Update FormField state
                      },
                      icon: Icon(Icons.upload_file),
                      label: Text(_attachmentFile == null ? 'Choose File' : 'Replace File'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 5),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon,
      {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      errorStyle: TextStyle(height: 0.8),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _challanNumberController.dispose();
    _searchController.dispose();
    _challanDateController.dispose();
    _invoiceAmountController.dispose();
    _baseAmountController.dispose();
    _aitAmountController.dispose();
    _taxController.dispose();
    _differenceController.dispose();
    _remarksController.dispose();
    super.dispose();
  }
}
