import 'package:flutter_catalogue/core/store.dart';
import 'package:flutter_catalogue/models/catalog.dart';
import 'package:velocity_x/velocity_x.dart';

//Catalog field
class CartModel {
  // static final cartModel = CartModel._internal();

  // CartModel._internal();

  // factory CartModel() => cartModel;

  late CatalogModel _catalog;

  //Collecting IDs
  final List<int> _itemID = [];

  //Get Catalog
  CatalogModel get catalog => _catalog;

  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
  }

  //Items in cart
  List<Product> get products =>
      _itemID.map((id) => _catalog.getById(id)).toList();

  //Calculate total prize
  num get totalPrice =>
      products.fold(0, (total, current) => total + current.price);


}

class AddMutation extends VxMutation<MyStore> {
  final Product product;

  AddMutation(this.product);
  @override
  perform() {
    store?.cart._itemID.add(product.id);
  }
}

class RemoveMutation extends VxMutation<MyStore> {
  final Product product;

  RemoveMutation(this.product);
  @override
  perform() {
    store?.cart._itemID.remove(product.id);
  }
}
