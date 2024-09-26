import 'package:flutter/material.dart';
import 'package:flutter_catalogue/models/catalog.dart';
import 'package:flutter_catalogue/pages/detail_page.dart';
import 'package:flutter_catalogue/widgets/catalog_product.dart';

class CatalogList extends StatelessWidget {
  const CatalogList({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: CatalogModel.products.length,
        itemBuilder: (context, index) {
          final catalog = CatalogModel.products[index];
          return InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(catalog: catalog))),
            child: CatalogProduct(
              catalog: catalog,
            ),
          );
        });
  }
}
