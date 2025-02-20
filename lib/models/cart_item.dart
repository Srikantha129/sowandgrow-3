import 'dart:ui';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  int quantity;
  final String supplier;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.supplier,
    this.quantity = 1, // Default quantity to 1
  });

  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.id == id &&
        other.name == name &&
        other.image == image &&
        other.supplier == supplier &&
        other.price == price;
  }

  // Calculate the total price of this item (quantity * price)
  double get totalPrice => quantity * price;

  // Create a copy of the CartItem with updated quantity
  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      price: price,
      image: image,
      supplier: supplier,
      quantity: quantity ?? this.quantity,
    );
  }
}