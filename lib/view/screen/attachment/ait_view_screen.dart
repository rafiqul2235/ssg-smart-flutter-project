import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssg_smart2/view/screen/attachment/smart_dropdown.dart';

class AitViewScreen extends StatefulWidget {
   final bool isBackButtonExist;

   const AitViewScreen({Key? key, this.isBackButtonExist = true})
       : super(key: key);

  @override
  State<AitViewScreen> createState() => _AitViewScreenState();
}

class _AitViewScreenState extends State<AitViewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedCountry;
  String? selectedValue;

  final List<String> _countries = [
    'Bangladesh',
    'Saudi Arabia',
    'Qatar',
    'UAE',
    'IRAQ',
    'IRAN',
  ];
  final List<Map<String, String>> _countries2 = [
    {'name': 'United States', 'flag': '🇺🇸'},
    {'name': 'United Kingdom', 'flag': '🇬🇧'},
    {'name': 'Canada', 'flag': '🇨🇦'},
    {'name': 'Australia', 'flag': '🇦🇺'},
    {'name': 'Germany', 'flag': '🇩🇪'},
    {'name': 'France', 'flag': '🇫🇷'},
    {'name': 'Japan', 'flag': '🇯🇵'},
    {'name': 'India', 'flag': '🇮🇳'},
    {'name': 'Brazil', 'flag': '🇧🇷'},
    {'name': 'Other', 'flag': '🌍'},
  ];


  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  static final eamilRegix = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]'
  );

  static final phoneRegex = RegExp(
    r'^\+?[\d\s-]{10,}$'
  );

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AIT Records'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16,),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email *',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!eamilRegix.hasMatch(value)) {
                      return 'Please enter a valid email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16,),

                // Phone number field
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number *',
                    hintText: 'Enter your phone number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d\s-+]'))
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16,),

                DropdownButtonFormField(
                    value: _selectedCountry,
                    decoration: const InputDecoration(
                      labelText: 'Country *',
                      hintText: 'Select your country',
                      prefixIcon: Icon(Icons.public),
                      border: OutlineInputBorder()
                    ),
                    items: _countries.map((String country) {
                      return DropdownMenuItem<String>(
                          value: country,
                          child: Text(country)
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCountry = newValue;
                      });
                    }
                ),
                const SizedBox(height: 16,),
                Theme(
                  data: Theme.of(context).copyWith(
                    // Customize the popup menu theme
                    popupMenuTheme: PopupMenuThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCountry,
                    decoration: InputDecoration(
                      labelText: 'Country *',
                      hintText: 'Select your country',
                      prefixIcon: const Icon(Icons.public),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    items: _countries2.map((country) {
                      return DropdownMenuItem<String>(
                        value: country['name'],
                        child: Row(
                          children: [
                            Text(country['flag']!), // Flag emoji
                            const SizedBox(width: 8),
                            Text(
                              country['name']!,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a country';
                      }
                      return null;
                    },
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCountry = newValue;
                      });
                    },
                    // Customize dropdown appearance
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    isExpanded: false, // Prevent full width expansion
                    menuMaxHeight: 300, // Limit menu height
                    dropdownColor: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16,),
                ButtonTheme(
                  alignedDropdown: true,  // Aligns dropdown with button
                  child: DropdownButtonFormField<String>(
                    value: _selectedCountry,
                    decoration: const InputDecoration(
                      labelText: 'Country *',
                      hintText: 'Select your country',
                      prefixIcon: Icon(Icons.public),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                    menuMaxHeight: 300,
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down),
                    isExpanded: true,  // This ensures the field takes full width
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    items: _countries.map<DropdownMenuItem<String>>((String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(
                          country,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a country';
                      }
                      return null;
                    },
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCountry = newValue;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16,),

                SmartDropdown<String>(
                  items: ['Apple', 'Banana', 'Cherry', 'Date','Peyara','Badam'],
                  value: selectedValue,
                  displayStringForOption: (String item) => item,
                  enableSearch: false,
                  onChanged: (String? v ) {
                    setState(() {
                      selectedValue = v;
                    });
                  },
                ),
                const SizedBox(height: 16,),
                DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  decoration: const InputDecoration(
                    labelText: 'Country *',
                    hintText: 'Select your country',
                    prefixIcon: Icon(Icons.public),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  menuMaxHeight: 300, // Limits the dropdown height
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.arrow_drop_down),
                  isExpanded: false, // Prevents horizontal expansion
                  alignment: AlignmentDirectional.centerStart,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  selectedItemBuilder: (BuildContext context) {
                    return _countries.map<Widget>((String item) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        constraints: const BoxConstraints(minWidth: 100),
                        child: Text(
                          item,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList();
                  },
                  items: _countries.map<DropdownMenuItem<String>>((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                          maxWidth: 200, // Maximum width of dropdown items
                        ),
                        child: Text(
                          country,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a country';
                    }
                    return null;
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCountry = newValue;
                    });
                  },
                ),
                // Age Field
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age *',
                    hintText: 'Enter your age',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3)
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null) {
                      return 'Please enter valid age';
                    }
                    if (age <18) {
                      return 'You must be at least 18 years old.';
                    }
                    if (age> 120) {
                      return 'Please enter a valid age';
                    }
                  },
                ),
                const SizedBox(height: 24,),


                ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 16),
                    )
                )
              ],
            )
        ),
      ),
    );
  }
}

