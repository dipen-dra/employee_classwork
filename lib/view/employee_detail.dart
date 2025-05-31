import 'package:flutter/material.dart';
import '../model/employee_model.dart';

class EmployeeDetail extends StatefulWidget {
  final EmployeeModel employee;

  const EmployeeDetail({super.key, required this.employee});

  @override
  State<EmployeeDetail> createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.employee.isFavourite;
  }

  void toggleFavourite() {
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final employee = widget.employee;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, isFavourite);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(employee.name),
          backgroundColor: Colors.blue.shade700,
          actions: [
            IconButton(
              icon: Icon(
                isFavourite ? Icons.star : Icons.star_border,
                color: isFavourite ? Colors.amber : Colors.white,
              ),
              onPressed: toggleFavourite,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(employee.photo),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    employee.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(employee.role),
                    backgroundColor: Colors.blue.shade100,
                  ),
                  const Divider(height: 30),
                  _infoTile(icon: Icons.email, label: 'Email', value: employee.email),
                  const SizedBox(height: 8),
                  _infoTile(icon: Icons.phone, label: 'Phone', value: employee.phone),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade700),
        const SizedBox(width: 10),
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}