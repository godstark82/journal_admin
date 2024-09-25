import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown(
      {super.key,
      required this.label,
      this.items = const [],
      this.onSelected,
      this.width = double.infinity});
  final List<DropdownMenuEntry<T>> items;
  final void Function(T?)? onSelected;
  final double width;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      return Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Container(
              color: Colors.white,
              child: DropdownMenu<T>(
                
                dropdownMenuEntries: items,
                onSelected: onSelected,
                initialSelection: items.first.value,
                width: (sizingInfo.isDesktop || sizingInfo.isTablet)
                    ? width
                    : context.width,
              ),
            ),
          ],
        ),
      );
    });
  }
}
/**
 * 
 *     DropdownMenuEntry(value: '', label: '--Select--'),
        DropdownMenuEntry(value: 'Dr.', label: 'Dr.'),
        DropdownMenuEntry(value: 'Prof.', label: 'Prof.'),
        DropdownMenuEntry(value: 'Mr.', label: 'Mr.'),
        DropdownMenuEntry(value: 'Ms.', label: 'Ms.'),
 */
