// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter_catalogue/models/catalog.dart';

import '../widgets/home widgets/add_to_cart.dart';

class DetailPage extends StatelessWidget {
  final Product catalog;
  const DetailPage({
    Key? key,
    required this.catalog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: context.theme.canvasColor,
      bottomNavigationBar: Container(
        color: context.theme.cardColor,
        child: OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          // buttonPadding: Vx.mOnly(right: 8),
          children: [
            "Rs.${catalog.price}"
                .text
                .xl3
                .color(context.theme.hintColor)
                .extraBold
                .make(),
            AddToCart(catalog: catalog).wh(80, 50),
          ],
        ).p32(),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Hero(
                    tag: Key(catalog.id.toString()),
                    child: Image.asset(catalog.img))
                .h32(context),
            Expanded(
              child: VxArc(
                height: 30,
                arcType: VxArcType.convey,
                edge: VxEdge.top,
                child: Container(
                  color: context.theme.cardColor,
                  width: context.screenWidth,
                  child: Column(
                    children: [
                      catalog.name.text.xl4.bold.make().py8(),
                      catalog.desc.text.xl.make(),
                      10.heightBox,
                      "For further information regarding this product, please visit our official website. For inquiries related to the shipment process, kindly contact us at customer.care@fliptronics.com."
                          .text
                          .make()
                          .p16()
                    ],
                  ).p32(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
