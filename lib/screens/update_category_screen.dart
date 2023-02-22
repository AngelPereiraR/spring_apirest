// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:cool_alert/cool_alert.dart';
import '../models/models.dart';

import '../providers/category_form_provider.dart';

import '../services/services.dart';
import '../widgets/widgets.dart';
import '../screens/screens.dart';
import 'package:provider/provider.dart';

class ScreenArguments {
  final int id;

  ScreenArguments(this.id);
}

class UpdateCategoryScreen extends StatelessWidget {
  const UpdateCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AuthBackground(
            child: SingleChildScrollView(
                child: Column(
          children: [
            const SizedBox(height: 180),
            CardContainer(
                child: SizedBox(
              width: 300,
              child: DecoratedBox(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                        // ignore: prefer_const_literals_to_create_immutables
                        boxShadow: [
                      const BoxShadow(
                        color: Colors.white,
                        blurRadius: 5,
                        offset: Offset(0, 0),
                      )
                    ]),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text('Update category',
                          style: TextStyle(
                              fontSize: 34,
                              color: Color.fromARGB(255, 18, 201, 159))),
                      const SizedBox(height: 10),
                      ChangeNotifierProvider(
                        create: (_) => CategoryFormProvider(),
                        child: _UpdateCategoryForm(),
                      )
                    ],
                  ),
                ),
              ),
            )),
            const SizedBox(
              height: 5,
            ),
            TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'adminCategories'),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.indigo.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                child: const Text(
                  'Return',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 18, 201, 159),
                  ),
                ))
          ],
        ))));
  }
}

class _UpdateCategoryForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int? args = ModalRoute.of(context)?.settings.arguments as int?;
    final categoryForm = Provider.of<CategoryFormProvider>(context);
    return Form(
        key: categoryForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Category name',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelText: 'Name',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 18, 201, 159))),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 18, 201, 159))),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 18, 201, 159)),
                  ),
                  prefixIcon: Icon(Icons.account_circle,
                      color: Color.fromARGB(255, 18, 201, 159))),
              onChanged: (value) => categoryForm.name = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the category name';
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Category description',
                  labelText: 'Description',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 18, 201, 159))),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 18, 201, 159))),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 18, 201, 159)),
                  ),
                  prefixIcon: Icon(Icons.description,
                      color: Color.fromARGB(255, 18, 201, 159))),
              onChanged: (value) => categoryForm.description = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the category description';
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 18, 201, 159)),
                  fixedSize: MaterialStateProperty.all(
                      const Size(double.infinity, 30)),
                ),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final updateCategoryService =
                      Provider.of<UpdateCategoryServices>(context,
                          listen: false);
                  if (categoryForm.isValidForm()) {
                    final String? errorMessage =
                        await updateCategoryService.putUpdateCategory(
                            args, categoryForm.name, categoryForm.description);

                    if (errorMessage == "OK") {
                      Navigator.pushReplacementNamed(
                          context, 'adminCategories');
                    } else {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        text: errorMessage,
                        borderRadius: 30,
                        loopAnimation: true,
                        confirmBtnColor: Colors.red,
                      );
                    }
                  }
                },
                child: const Center(child: Text('Update')),
              ),
            ),
          ],
        ));
  }
}
