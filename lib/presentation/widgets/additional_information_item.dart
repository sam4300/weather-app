import 'package:flutter/material.dart';

class AdditionalInformationItem extends StatelessWidget {
  final Icon icon;
  final String label;
  final String value;
  const AdditionalInformationItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon,
        Text(label),
        Text(
          value.toString(),
        ),
      ],
    );
  }
}
