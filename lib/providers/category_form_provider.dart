// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class CategoryFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
