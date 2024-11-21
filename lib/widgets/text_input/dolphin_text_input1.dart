import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DolphinTextInput1 extends StatefulWidget {
  final TextEditingController? controller;
  final bool? focusWhenOpen;
  final TextInputType? keyboardType;
  final String? label;
  final void Function(String)? onChanged;

  const DolphinTextInput1({
    super.key,
    this.controller,
    this.focusWhenOpen,
    this.keyboardType,
    this.label,
    this.onChanged,
  });

  @override
  State<DolphinTextInput1> createState() => _DolphinTextInput1State();
}

class _DolphinTextInput1State extends State<DolphinTextInput1> {
  late TextEditingController controller;
  late FocusNode focusNode;
  late TextInputType keyboardType;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? TextEditingController();
    focusNode = FocusNode();
    keyboardType = widget.keyboardType ?? TextInputType.text;

    if (widget.focusWhenOpen == true) focusNode.requestFocus();
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
      child: TextFormField(
        controller: controller,
        style: style?.copyWith(
            color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          label: widget.label != null ? Text(widget.label!) : null,
          labelStyle: style?.copyWith(
              color: Colors.black.withOpacity(0.5),
              fontSize: 18.sp,
              fontWeight: FontWeight.w400),
          alignLabelWithHint: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Colors.black)),
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  controller.text = '';
                });
                widget.onChanged!(controller.text);
              },
              color: Colors.black,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.clear_outlined)),
        ),
        focusNode: focusNode,
        keyboardType: keyboardType,
        onChanged: widget.onChanged != null
            ? (value) => widget.onChanged!(value)
            : null,
        onTapOutside: (_) => focusNode.unfocus(),
      ),
    );
  }
}
