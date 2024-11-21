import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DolphinDropdownMenu1<T> extends StatefulWidget {
  final TextEditingController? controller;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final String? label;
  final void Function(T?)? onChanged;

  const DolphinDropdownMenu1(
      {super.key,
      this.controller,
      required this.dropdownMenuEntries,
      this.label,
      this.onChanged});

  @override
  State<DolphinDropdownMenu1<T>> createState() =>
      _DolphinDropdownMenu1State<T>();
}

class _DolphinDropdownMenu1State<T> extends State<DolphinDropdownMenu1<T>> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context).textTheme.labelLarge;
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.black12.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<T>(
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: style?.copyWith(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
              value:
                  widget.dropdownMenuEntries.first.value, // Default selection
              items: widget.dropdownMenuEntries.map((entry) {
                return DropdownMenuItem<T>(
                  value: entry.value,
                  child: Text(entry.label), // Display text for each item
                );
              }).toList(),
              onChanged: (value) {
                if (widget.onChanged != null) widget.onChanged!(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
