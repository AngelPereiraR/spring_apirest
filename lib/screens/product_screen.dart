import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:like_button/like_button.dart';

import 'package:provider/provider.dart';
import 'package:spring_apirest/providers/company_form_provider.dart';
import 'package:spring_apirest/services/insert_productfavorite_services.dart';

import '../models/models.dart';
import '../services/services.dart';

var _counter = 0;
late int idArticulo = 0;

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];
  List<CategoryAndProducts> categories = [];
  final productsService = GetProductsServices();

  Future refresh() async {
    setState(() => products.clear());
    await productsService.getProducts();

    setState(() {
      products = productsService.products;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return productsService.isLoading
        ? const Center(
            child: SpinKitWave(color: Color.fromRGBO(0, 153, 153, 1), size: 50))
        : Scaffold(
            appBar: _appbar(context),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const SizedBox(height: 5),
                      // const ProductsSearchUser(),
                      const listProducts1()
                    ],
                  )
                ],
              ),
            ));
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        color: Colors.black,
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, 'userscreen', (route) => false);
        },
        icon: const Icon(Icons.logout),
      ),
      title: Row(
        children: [
          Spacer(),
          IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'favoritescreen');
            },
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class _dividerLine extends StatelessWidget {
  const _dividerLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.black,
              gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.centerLeft,
                  colors: [Colors.black, Colors.black38])),
          height: 1,
          width: 130,
          margin: const EdgeInsets.only(left: 20, bottom: 5, top: 5),
        ),
        Container(
          decoration: const BoxDecoration(
              color: Colors.black,
              gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.centerRight,
                  colors: [Colors.black, Colors.black38])),
          height: 1,
          width: 180,
          margin: const EdgeInsets.only(right: 20, bottom: 5, top: 5),
        ),
      ],
    );
  }
}

// ignore: camel_case_types
class _searchBar extends StatefulWidget {
  const _searchBar({super.key});

  @override
  State<_searchBar> createState() => __searchBarState();
}

// ignore: camel_case_types
class __searchBarState extends State<_searchBar> {
  void updateList(String value) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(
        top: 20,
      ),
      height: 30,
      width: 200,
      child: TextField(
        onSubmitted: (value) =>
            Navigator.pushReplacementNamed(context, 'userscreen'),
        textInputAction: TextInputAction.search,
        onChanged: ((value) => updateList(value)),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          focusColor: Colors.black87,
          border: InputBorder.none,
          hintText: "Buscar",
        ),
      ),
    );
  }
}

class listProducts1 extends StatefulWidget {
  const listProducts1({super.key});

  @override
  State<listProducts1> createState() => _listProductsState();
}

class _listProductsState extends State<listProducts1> {
  List<Product> products = [];
  List<CategoryAndProducts> categories = [];
  final productsCompanyService = GetProductsOfCompanyServices();
  final categoryService = GetCategoriesServices();
  final productsService = GetProductsServices();
  Future refresh() async {
    setState(() => products.clear());
    await categoryService.getCategories();
    await productsService.getProducts();
    setState(() {
      categories = categoryService.categories;
      products = productsService.products;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final companyForm = Provider.of<CompanyFormProvider>(context);
    refreshProducts(int value) async {
      products.clear();
      await productsCompanyService.getGetProducts(value);
      setState(() {
        products = productsCompanyService.products;

        // print(products.toString());

        products = productsService.products;
      });
    }

    return Form(
      key: companyForm.formKey,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsetsDirectional.only(
                  start: 40,
                  top: 20,
                ),
                height: 30,
                width: 200,
                child: DropdownButtonFormField(
                  items: categories.map((e) {
                    /// Ahora creamos "e" y contiene cada uno de los items de la lista.

                    return DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name.toString(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 18, 201, 159))),
                    );
                  }).toList(),
                  onChanged: (value) {
                    companyForm.id = value!;
                  },
                  validator: (value) {
                    return (value != null && value != 0)
                        ? null
                        : 'Select Category';
                  },
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 18, 201, 159))),
                onPressed: () {
                  setState(() {
                    refreshProducts(companyForm.id);
                  });
                },
                child: const Text('Submit', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
          Visibility(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 600,
                width: 400,
                child: GridView.builder(
                  itemBuilder: ((context, index) {
                    TextEditingController customController =
                        TextEditingController();

                    return GestureDetector(
                      /*  onTap: () {
                        final articuloService =
                            Provider.of<ArticuloService>(context, listen: false);
                        setState(() {
                          idArticulo = products[index].id!;
                          articuloService.addVistaArticulo(idArticulo);
              
                          productsCompanyService.loadArticulo(idArticulo);
                        });
                        Navigator.pushReplacementNamed(context, 'productscreen');
                      },*/
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: 10,
                          height: 330,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              // ignore: prefer_const_literals_to_create_immutables
                              boxShadow: [
                                const BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 5,
                                  offset: Offset(0, 0),
                                )
                              ]),
                          child: Column(
                            children: [
                              Stack(children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.yellow,
                                  ),
                                  width: 300,
                                  height: 200,
                                  child: const ClipRRect(
                                    child: FadeInImage(
                                      placeholder:
                                          AssetImage('assets/no-image.png'),
                                      image: AssetImage('assets/no-image.png'),
                                      width: 300,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ]),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(products[index].name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Row(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(products[index].description,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 0.5,
                                color: Colors.black54,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    /*  onTap: () async {
                                      final compraService =
                                          Provider.of<CompraServices>(context,
                                              listen: false);
                                      final userService =
                                          Provider.of<LoginServices>(context,
                                              listen: false);
                                      int userId =
                                          int.parse(await userService.readId());
              
                                      String? msg = await compraService.addCompra(
                                          userId, products[index].id!, 1);
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.warning,
                                        title: msg,
              
                                        borderRadius: 30,
                                        //loopAnimation: true,
                                        confirmBtnColor: Colors.blueAccent,
                                        confirmBtnText: 'Aceptar',
              
                                        onConfirmBtnTap: () {
                                          Navigator.pop(context);
                                        },
                                        showCancelBtn: true,
                                        onCancelBtnTap: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    },*/
                                    child: const Text(
                                      'Compra \n Rapida',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  const Spacer(),
                                  LikeButton(
                                    onTap: ((isLiked) async {
                                      final getCategoryAndProductsServices =
                                          Provider.of<
                                                  GetCategoryAndProductsServices>(
                                              context,
                                              listen: false);
                                      await GetCategoryAndProductsServices()
                                          .getCategoryAndProducts(
                                              companyForm.id);
                                      CategoryAndProducts? category =
                                          getCategoryAndProductsServices
                                              .category;

                                      Map<String, dynamic> categoryMap = {
                                        "id": category!.id,
                                        "name": category.name,
                                        "description": category.description,
                                        "categoryId": []
                                      };

                                      // ignore: use_build_context_synchronously
                                      final insertProductService = Provider.of<
                                              InsertProductFavoriteServices>(
                                          context,
                                          listen: false);

                                      return await insertProductService
                                          .postInsertProductFavorite(
                                              companyForm.id,
                                              products[index].id,
                                              products[index].name,
                                              categoryMap,
                                              products[index].description,
                                              products[index].price,
                                              products[index].favorite);
                                    }),
                                    isLiked: products[index].favorite,
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.favorite,
                                        color:
                                            isLiked ? Colors.green : Colors.red,
                                        size: 40,
                                      );
                                    },
                                  )
                                  /*IconButton(
                                      onPressed: () async {
                                          final compraService =
                                            Provider.of<CompraServices>(context,
                                                listen: false);
                                        final userService =
                                            Provider.of<LoginServices>(context,
                                                listen: false);
                                        int userId =
                                            int.parse(await userService.readId());
              
                                        String? msg = await compraService.addCompra(
                                            userId, products[index].id!, 1);
                                        String msg = 'mensaje';
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.warning,
                                          title: msg,
              
                                          borderRadius: 30,
                                          //loopAnimation: true,
                                          confirmBtnColor: Colors.blueAccent,
                                          confirmBtnText: 'Aceptar',
              
                                          onConfirmBtnTap: () {
                                            Navigator.pop(context);
                                          },
                                          showCancelBtn: true,
                                          onCancelBtnTap: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.add_shopping_cart))*/
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 350,
                      mainAxisSpacing: 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardSearch extends StatelessWidget {
  const CardSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 10,
        height: 220,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                color: Colors.black38,
                blurRadius: 5,
                offset: Offset(0, 0),
              )
            ]),
        child: Column(
          children: [
            Stack(children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                ),
                width: 300,
                height: 145,
                // ignore: prefer_const_literals_to_create_immutables
                child: Stack(children: [
                  const ClipRRect(
                    child: FadeInImage(
                      placeholder: AssetImage('assets/no-image.jpg'),
                      image: AssetImage('assets/no-image.jpg'),
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ]),
              ),
            ]),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 50,
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'Descripcion',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    '45€',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 1,
              color: Colors.black45,
              width: 200,
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 50,
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                            context, 'userscreen'),
                        child: const Text(
                          'Compra \n Rapida',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            _counter = _counter++;
                          },
                          icon: const Icon(Icons.add_shopping_cart))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
