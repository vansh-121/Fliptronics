import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catalogue/core/store.dart';
import 'package:flutter_catalogue/models/cart.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:upi_india/upi_india.dart';
import 'package:uuid/uuid.dart';

final Uuid uuid = Uuid();
String transactionRefId = uuid.v4();

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

class _CartTotal extends StatefulWidget {
  const _CartTotal({super.key});

  @override
  State<_CartTotal> createState() => _CartTotalState();
}

class _CartTotalState extends State<_CartTotal> {
  late UpiIndia _upiIndia;
  UpiResponse? _transaction;
  final CartModel _cart = (VxState.store as MyStore).cart;

  @override
  void initState() {
    super.initState();
    _upiIndia = UpiIndia();
  }

  Future<void> _startPayment() async {
    double totalPrice = _cart.totalPrice.toDouble();

    // Check if the amount is within the valid range
    if (totalPrice < 1 || totalPrice > 100000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              "Due to UPI Restrictions !! We can consider payments upto 1 lakh only."
                  .text
                  .color(Colors.white)
                  .make(),
          backgroundColor: Colors.red,
        ),
      );
      return; // Do not proceed with payment if amount is invalid
    }

    UpiApp app = UpiApp.googlePay; // Choosing Google Pay
    _transaction = await _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "vansh.sethi98760-1@okicici", // Replace with actual UPI ID
      receiverName: "Vansh Sethi",
      transactionRefId: transactionRefId, // A unique transaction ID
      transactionNote: "Payment for items in the cart",
      amount: totalPrice,
    );

    setState(() {
      // To update the UI after receiving the transaction response
    });

    _handleTransactionResponse(_transaction!);
  }

  void _handleTransactionResponse(UpiResponse response) {
    String message = '';
    switch (response.status) {
      case UpiPaymentStatus.SUCCESS:
        message = "Payment Successful!";
        break;
      case UpiPaymentStatus.FAILURE:
        message = "Payment Failed!";
        break;
      case UpiPaymentStatus.SUBMITTED:
        message = "Payment Submitted!";
        break;
      default:
        message = "Unknown status: ${response.status}";
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: message.text.make(),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: _startPayment, // Start UPI payment on button tap
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
