// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catalogue/core/store.dart';
import 'package:flutter_catalogue/models/cart.dart';
import 'package:flutter_catalogue/utils/routes.dart';
import 'package:flutter_catalogue/widgets/home%20widgets/catalog_header.dart';
import 'package:flutter_catalogue/widgets/home%20widgets/catalog_list.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_catalogue/models/catalog.dart';
import 'package:flutter_catalogue/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final url = "https://api.jsonbin.io/v3/b/66eda50ae41b4d34e433e9d5";
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    final json = await rootBundle.loadString("assets/files/catalog.json");
    // final response = await http.get(Uri.parse(url));
    // // final response = await http.get(Uri.parse(url));
    // final json = response.body;
    final decodedjson = jsonDecode(json);
    var productsdata = decodedjson["products"];
    CatalogModel.products = List.from(productsdata)
        .map<Product>(
          (product) => Product.fromMap(product),
        )
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _cart = (VxState.store as MyStore).cart;
    return Scaffold(
      backgroundColor: context.canvasColor,
      floatingActionButton: VxBuilder(
        mutations: {AddMutation, RemoveMutation},
        builder: (context, MyStore, _) => FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, Routes.CartRoute),
          shape: StadiumBorder(),
          backgroundColor: context.theme.shadowColor,
          child: const Icon(
            CupertinoIcons.bag_fill,
            color: Colors.white,
          ),
        ).badge(
            color: context.theme.hintColor,
            size: 22,
            count: _cart.products.length,
            textStyle: TextStyle(
                fontWeight: FontWeight.bold, color: context.theme.cardColor)),
      ),
      appBar: AppBar(
        backgroundColor: context.theme.canvasColor,
        title: Text(
          "FlipTronics",
          style: TextStyle(
              color: context.theme.highlightColor, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Container(
          // color: MyTheme.creamcolor,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(),
              if (CatalogModel.products != null &&
                  CatalogModel.products.isNotEmpty)
                Expanded(
                  child: CatalogList().py8(),
                )
              else
                CircularProgressIndicator().centered().expand(),
            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
      // backgroundColor: Colors.black,
    );
  }
}
