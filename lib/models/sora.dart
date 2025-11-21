import 'package:flutter/material.dart';
import 'package:test_fe_sora/utils/utils.dart';

class Sora {
  String? name;
  String? description;
  String? price;
  String? imageUrl;
  String? category;
  Color? color;
  Sora({
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.category,
    this.color,
  });
}

final List<Sora> soraList = [
  Sora(
    name: 'Burger',
    description: 'Figma ipsum component variant main layer.',
    price: '45.000',
    imageUrl: 'assets/images/burger.png',
    category: 'Food',
    color: redColor,
  ),
  Sora(
    name: 'Orange',
    description: 'Figma ipsum component variant main layer.',
    price: '15.000',
    imageUrl: 'assets/images/orange_juice.png',
    category: 'Drink',
    color: yellowColor,
  ),
  Sora(
    name: 'Straw Cake',
    description: 'Figma ipsum component variant main layer.',
    price: '25.000',
    imageUrl: 'assets/images/straw_cake.png',
    category: 'Dessert',
    color: purpleColor,
  ),
  Sora(
    name: 'Tamago Soup',
    description: 'Figma ipsum component variant main layer.',
    price: '30.000',
    imageUrl: 'assets/images/tofu_soup.png',
    category: 'Food',
    color: orangeColor,
  ),
  Sora(
    name: 'Sushi Bento',
    description: 'Delicious sushi with fresh ingredients.',
    price: '60.000',
    imageUrl: 'assets/images/sushi_bento.png',
    category: 'Bento',
    color: primaryColor,
  ),
  Sora(
    name: 'Grilled Chicken',
    description: 'Juicy grilled chicken with herbs.',
    price: '50.000',
    imageUrl: 'assets/images/grilled_chicken.png',
    category: 'Food',
    color: secondaryColor,
  ),
  Sora(
    name: 'Chocolate Cake',
    description: 'Rich chocolate cake with creamy frosting.',
    price: '35.000',
    imageUrl: 'assets/images/chocolate_cake.png',
    category: 'Dessert',
    color: chocolateColor,
  ),
  Sora(
    name: 'Fruit Smoothie',
    description: 'Refreshing blend of fresh fruits.',
    price: '20.000',
    imageUrl: 'assets/images/fruit_smothie.png',
    category: 'Drink',
    color: smoothieColor,
  ),
  Sora(
    name: 'Veggie Bento',
    description: 'Healthy bento box with assorted vegetables.',
    price: '55.000',
    imageUrl: 'assets/images/veggie_bento.png',
    category: 'Bento',
    color: vegieColor,
  ),
  Sora(
    name: 'Ice Cream Sundae',
    description: 'Delicious ice cream with toppings.',
    price: '18.000',
    imageUrl: 'assets/images/ice_cream_sundae.png',
    category: 'Dessert',
    color: iceCreamColor,
  ),
  Sora(
    name: 'Topping Extra Cheese',
    description: 'Add extra cheese to your meal.',
    price: '10.000',
    imageUrl: 'assets/images/extra_cheese.png',
    category: 'Topping',
    color: cheeseColor,
  ),
  Sora(
    name: 'Lemonade',
    description: 'Freshly squeezed lemonade.',
    price: '12.000',
    imageUrl: 'assets/images/lemonade.png',
    category: 'Drink',
    color: lemonadeColor,
  ),
];
