import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catalogue/core/store.dart';
import 'package:flutter_catalogue/models/cart.dart';
import 'package:flutter_catalogue/models/catalog.dart';
import 'package:velocity_x/velocity_x.dart';

class AddToCart extends StatelessWidget {
  final Product catalog;

  AddToCart({super.key, required this.catalog});

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [AddMutation, RemoveMutation]);
    final CartModel _cart = (VxState.store as MyStore).cart;
    bool isAdded = _cart.products.contains(catalog) ?? false;
    return ElevatedButton(
            onPressed: () {
              if (!isAdded) {
                AddMutation(catalog);
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(context.theme.shadowColor),
              shape: const WidgetStatePropertyAll(StadiumBorder()),
            ),
            child: isAdded
                ? const Icon(
                    Icons.done,
                    color: Colors.white,
                  )
                : const Icon(
                    CupertinoIcons.cart_badge_plus,
                    color: Colors.white,
                  ))
        .wh(70, 40);
  }
}
