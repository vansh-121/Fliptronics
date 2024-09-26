class Product {
  final String name;
  final int id;
  final String desc;
  final int price;
  final String color;
  final String img;

  Product(
      {required this.name,
      required this.id,
      required this.desc,
      required this.price,
      required this.color,
      required this.img});

  factory Product.fromMap(Map<String, dynamic> map) {
    //decode
    return Product(
      id: map["id"],
      name: map["name"],
      desc: map["desc"],
      price: map["price"],
      color: map["color"],
      img: map["img"],
    );
  }

  toMap() => {
        "name": name,
        "id": id,
        "desc": desc,
        "price": price,
        "color": color,
        "img": img,
      };
}

class CatalogModel {
  // static final catalogModel = CatalogModel._internal();

  // CatalogModel._internal();

  // factory CatalogModel() => catalogModel;

  static List<Product> products = [];

  //Get item by ID
  Product getById(int id) =>
      products.firstWhere((element) => element.id == id, orElse: null);

  //Get Item by Product
  Product getByPosition(int pos) => products[pos];

  static var items;
}
