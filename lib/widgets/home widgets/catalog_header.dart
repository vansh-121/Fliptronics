import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Trending Products"
            .text
            .bold
            .xl4
            .color(context.theme.primaryColor)
            .make(),
        "New Apple Products Now Available!"
            .text
            .bold
            .xl
            .color(context.theme.focusColor)
            .make()
            .p4(),
      ],
    );
  }
}
