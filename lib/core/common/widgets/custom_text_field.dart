import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final double width;
  final Function(String)? onChanged;
  const CustomTextField(
      {super.key,
      required this.label,
      this.onChanged,
      this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      return Container(
        margin: EdgeInsets.all(10),
        width: (sizingInfo.isDesktop || sizingInfo.isTablet)
            ? width
            : double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Container(
              color: Colors.white,
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: label),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
                autofocus: false,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      );
    });
  }
}
