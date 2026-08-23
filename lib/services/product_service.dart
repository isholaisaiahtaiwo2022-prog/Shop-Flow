import 'package:jordan/model/product.dart';

class ProductService {
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return const [
      Product(
        id: 1,
        name: 'Nike Air Max',
        description: 'Comfortable Running Shoe',
        price: 120,
        imageUrl:
            'https://i.pinimg.com/736x/d0/96/14/d096149da4340c211c0a20f244fd5e12.jpg',
      ),
      Product(
        id: 2,
        name: 'Addidas UltraBoost ',
        description: 'Premium Running Shoe',
        price: 150,
        imageUrl:
            'https://i.pinimg.com/736x/59/21/fb/5921fbe14b0bc5ca00b33da79335824a.jpg',
      ),
      Product(
        id: 3,
        name: 'Puma Running Shoe',
        description: 'LightWeight and Durable',
        price: 95,
        imageUrl:
            'https://i.pinimg.com/1200x/68/0e/d4/680ed40b5d09b9fefb0deb4a2fd2a6f0.jpg',
      ),
      Product(
        id: 4,
        name: 'New Balance 574',
        description: 'Classic Confort and Style',
        price: 110,
        imageUrl:
            'https://i.pinimg.com/736x/55/bd/87/55bd87c2398577fb4d287b60bf46db4e.jpg',
      ),
      Product(
        id: 5,
        name: 'Nike Air Max',
        description: 'Comfortable Running Shoe',
        price: 120,
        imageUrl:
            'https://i.pinimg.com/736x/d0/96/14/d096149da4340c211c0a20f244fd5e12.jpg',
      ),
      Product(
        id: 6,
        name: 'Nike Air Max',
        description: 'Comfortable Running Shoe',
        price: 120,
        imageUrl:
       'https://i.pinimg.com/1200x/68/0e/d4/680ed40b5d09b9fefb0deb4a2fd2a6f0.jpg',

      ),
            Product(
        id: 7,
        name: 'Addidas UltraBoost ',
        description: 'Premium Running Shoe',
        price: 150,
        imageUrl:
            'https://i.pinimg.com/736x/59/21/fb/5921fbe14b0bc5ca00b33da79335824a.jpg',
      ),
            Product(
        id: 8,
        name: 'Addidas UltraBoost ',
        description: 'Premium Running Shoe',
        price: 150,
        imageUrl:
            'https://i.pinimg.com/736x/59/21/fb/5921fbe14b0bc5ca00b33da79335824a.jpg',
      ),
            Product(
        id: 9,
        name: 'Addidas UltraBoost ',
        description: 'Premium Running Shoe',
        price: 150,
        imageUrl:
            'https://i.pinimg.com/736x/59/21/fb/5921fbe14b0bc5ca00b33da79335824a.jpg',
      ),
            Product(
        id: 10,
        name: 'Addidas UltraBoost ',
        description: 'Premium Running Shoe',
        price: 150,
        imageUrl:
            'https://i.pinimg.com/736x/59/21/fb/5921fbe14b0bc5ca00b33da79335824a.jpg',
      ),
    ];
  }
}
