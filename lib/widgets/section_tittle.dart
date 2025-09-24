import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionTitle({super.key, required this.title, this.subtitle = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (subtitle.isNotEmpty)
          Text(subtitle, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
