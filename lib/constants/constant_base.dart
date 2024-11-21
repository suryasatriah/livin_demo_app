import 'package:flutter/material.dart';

class ConstantBase {
  static const List<DropdownMenuEntry<String>> kListBankDropdownMenu =
      <DropdownMenuEntry<String>>[
    DropdownMenuEntry(value: "mandiri", label: "Bank Mandiri"),
    DropdownMenuEntry(value: "xyz", label: "Bank XYZ"),
    DropdownMenuEntry(value: "bca", label: "Bank BCA"),
  ];
}
