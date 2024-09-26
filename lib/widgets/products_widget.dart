import 'package:flutter/material.dart';
import 'package:flutter_catalogue/models/catalog.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductWidget extends StatelessWidget {
  final Product product;

  const ProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        onTap: () {
          print("${product.name} pressed");
        },
        leading: Image.network(product.img),
        title: Text(
          product.name,
          style: TextStyle(
              fontFamily: GoogleFonts.lato().fontFamily,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          product.desc,
          style: TextStyle(
            color: const Color.fromARGB(255, 8, 110, 11),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          product.price.toString(),
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 2, 99, 144),
              fontSize: 16),
        ),
      ),
    );
  }
}
