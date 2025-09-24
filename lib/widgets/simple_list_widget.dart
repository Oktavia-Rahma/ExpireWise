import 'package:flutter/material.dart';

class SimpleListWidget extends StatelessWidget {
  final List<String> list;
  final IconData icon;
  const SimpleListWidget({super.key, required this.list, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(icon, color: Colors.teal),
          title: Text(list[index]),
        );
      },
    );
  }
}
