// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:cool_alert/cool_alert.dart';
import '../models/models.dart';

import '../providers/product_form_provider.dart';

import '../services/services.dart';
import '../widgets/widgets.dart';
import 'package:provider/provider.dart';

class InsertProductScreen extends StatefulWidget {
  const InsertProductScreen({Key? key}) : super(key: key);

  @override
  State<InsertProductScreen> createState() => _InsertProductScreenState();
}

class _InsertProductScreenState extends State<InsertProductScreen> {
  List<CategoryAndProducts> categories = [];
  final categoriesService = GetCategoriesServices();
  Future refresh() async {
    setState(() => categories.clear());
    await categoriesService.getCategories();
    setState(() {
      categories = categoriesService.categories;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

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
                      const Text('Create product',
                          style: TextStyle(
                              fontSize: 34,
                              color: Color.fromARGB(255, 18, 201, 159))),
                      const SizedBox(height: 10),
                      ChangeNotifierProvider(
                        create: (_) => ProductFormProvider(),
                        child: _InsertProductForm(categories),
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
                    Navigator.pushReplacementNamed(context, 'adminProducts'),
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

class _InsertProductForm extends StatelessWidget {
  List<CategoryAndProducts> listOfCategories = [];
  _InsertProductForm(List<CategoryAndProducts> categories) {
    listOfCategories = categories;
  }
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final categoryService =
        Provider.of<GetCategoryAndProductsServices>(context);
    return Form(
        key: productForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Product name',
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
              onChanged: (value) => productForm.name = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the product name';
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Product description',
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
              onChanged: (value) => productForm.description = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the product description';
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                    hintText: 'Categories',
                    labelText: 'Category',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 18, 201, 159))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 18, 201, 159))),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 18, 201, 159)),
                    ),
                    prefixIcon: Icon(Icons.auto_awesome_motion_sharp,
                        color: Color.fromARGB(255, 18, 201, 159))),
                items: listOfCategories.map((e) {
                  /// Ahora creamos "e" y contiene cada uno de los items de la lista.
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 18, 201, 159))),
                  );
                }).toList(),
                onChanged: (value) async {
                  await categoryService.getCategoryAndProducts(value);
                  productForm.category = {
                    "id": categoryService.category!.id,
                    "name": categoryService.category!.name,
                    "description": categoryService.category!.description,
                    "categoryId": [],
                  };
                },
                validator: (value) {
                  return (value != null && value != 0)
                      ? null
                      : 'Please, select a category';
                },
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Product price',
                  labelText: 'Price',
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
                  prefixIcon: Icon(Icons.price_check,
                      color: Color.fromARGB(255, 18, 201, 159))),
              onChanged: (value) => productForm.price = double.parse(value),
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the product price';
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
                  final insertProductService =
                      Provider.of<InsertProductServices>(context,
                          listen: false);
                  if (productForm.isValidForm()) {
                    final String? errorMessage =
                        await insertProductService.postInsertProduct(
                            productForm.category?.values.toList().first,
                            1,
                            productForm.name,
                            productForm.description,
                            productForm.category,
                            productForm.price,
                            false);

                    if (errorMessage == "OK") {
                      Navigator.pushReplacementNamed(context, 'adminProducts');
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
                child: const Center(child: Text('Create')),
              ),
            ),
          ],
        ));
  }
}
