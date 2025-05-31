import 'package:employee_classwork/model/employee_model.dart';
import 'package:employee_classwork/state/employee_state.dart';
import 'package:employee_classwork/view/employee_detail.dart';
 
import 'package:flutter/material.dart';

class EmployeeView extends StatefulWidget {
  const EmployeeView({super.key});

  @override
  State<EmployeeView> createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final photoUrl =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnSA1zygA3rubv-VK0DrVcQ02Po79kJhXo_A&s";

  String? selectedRole;

  final lstRole = const [
    DropdownMenuItem(value: "Admin", child: Text("Admin")),
    DropdownMenuItem(value: "Manager", child: Text("Manager")),
    DropdownMenuItem(value: "Employee", child: Text("Employee")),
  ];

  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final employee = EmployeeModel(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        role: selectedRole!,
        photo: photoUrl,
        isFavourite: false,
      );

      setState(() {
        EmployeeState.lstEmployee.add(employee);
        _formKey.currentState!.reset();
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        selectedRole = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Information'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildFormCard(),
              const SizedBox(height: 16),
              const Divider(thickness: 1.5),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Employee List",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: EmployeeState.lstEmployee.isEmpty
                    ? const Center(child: Text("No Employee Found", style: TextStyle(fontSize: 16)))
                    : ListView.builder(
                        itemCount: EmployeeState.lstEmployee.length,
                        itemBuilder: (context, index) {
                          final emp = EmployeeState.lstEmployee[index];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(emp.photo),
                              ),
                              title: Text(emp.name),
                              subtitle: Text("${emp.role} • ${emp.phone}"),
                              trailing: Icon(
                                emp.isFavourite ? Icons.star : Icons.star_border,
                                color: emp.isFavourite ? Colors.amber : Colors.grey,
                              ),
                              onTap: () async {
                                final updatedFavourite = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmployeeDetail(employee: emp),
                                  ),
                                );

                                if (updatedFavourite != null) {
                                  setState(() {
                                    EmployeeState.lstEmployee[index] = EmployeeModel(
                                      name: emp.name,
                                      email: emp.email,
                                      phone: emp.phone,
                                      role: emp.role,
                                      photo: emp.photo,
                                      isFavourite: updatedFavourite,
                                      color: emp.color,
                                    );
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Add New Employee",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(controller: nameController, label: "Name"),
              const SizedBox(height: 10),
              _buildTextField(
                  controller: emailController, label: "Email", keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 10),
              _buildTextField(
                  controller: phoneController, label: "Phone", keyboardType: TextInputType.phone),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: selectedRole,
                items: lstRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
                decoration: _inputDecoration("Role"),
                validator: (value) => value == null ? 'Please select a role' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  
                  label: const Text("Add Employee"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (label == "Email" && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        if (label == "Phone" && !RegExp(r'^\d{10}$').hasMatch(value)) {
          return 'Enter a valid 10-digit phone number';
        }
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      hintText: "Enter your $label",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
