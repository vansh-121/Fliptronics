import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catalogue/core/store.dart';
import 'package:flutter_catalogue/models/cart.dart';
import 'package:velocity_x/velocity_x.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.cardColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: "My Cart".text.bold.make(),
      ),
      body: Column(
        children: [_CartList().p32().expand(), Divider(), _CartTotal()],
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  const _CartTotal({super.key});

  @override
  Widget build(BuildContext context) {
    final CartModel _cart = (VxState.store as MyStore).cart;
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: "Coming Soon".text.xl.color(Colors.white).make(),
                backgroundColor: context.theme.shadowColor,
              ));
            },
            style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(context.theme.shadowColor),
            ),
            child: "Place Order".text.color(Colors.white).bold.make(),
          ).wh(140, 35),
          30.widthBox,
          VxConsumer(
            notifications: {},
            mutations: {RemoveMutation},
            builder: (context, MyStore, _) {
              return "Rs.${_cart.totalPrice}"
                  .text
                  .color(context.theme.hintColor)
                  .bold
                  .xl4
                  .make();
            },
          ),
        ],
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  _CartList({super.key});

  final CartModel _cart = (VxState.store as MyStore).cart;
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [RemoveMutation]);
    return _cart.products.isEmpty
        ? "Cart is Empty !".text.makeCentered()
        : ListView.builder(
            itemCount: _cart.products?.length,
            itemBuilder: (context, index) => ListTile(
                  title: _cart.products[index].name.text.make().px32(),
                  trailing: IconButton(
                      onPressed: () => RemoveMutation(_cart.products[index]),
                      icon: const Icon(CupertinoIcons.delete)),
                  leading: Icon(Icons.done),
                ));
  }
}
