import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FunctionIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onPressed;

  FunctionIconButton(
      {required this.icon,
      required this.label,
      required this.onPressed,
      Key? key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: const [
              Icon(CupertinoIcons.person_alt),
              Text("Upload Your Photo")
            ],
          ),
        ));
  }
}
