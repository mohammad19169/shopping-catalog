import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepository;

  ProductProvider({required ProductRepository productRepository})
      : _productRepository = productRepository;

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String? _selectedCategory;
  bool _isLoading = false;

  List<Product> get products => _filteredProducts;
  List<Product> get favoriteProducts => _products.where((product) => product.isFavorite).toList();
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productRepository.fetchProducts();
      _categories = await _productRepository.fetchCategories();
      _categories.insert(0, 'All');
      _filteredProducts = List.from(_products);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;
    if (category == null || category == 'All') {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products
          .where((product) => product.category == category)
          .toList();
    }
    notifyListeners();
  }

  void toggleFavorite(int productId) async {
    final index = _products.indexWhere((product) => product.id == productId);
    if (index != -1) {
      _products[index].isFavorite = !_products[index].isFavorite;
      
      final filteredIndex = _filteredProducts.indexWhere((product) => product.id == productId);
      if (filteredIndex != -1) {
        _filteredProducts[filteredIndex].isFavorite = _products[index].isFavorite;
      }
      
      final favoriteIds = _products
          .where((product) => product.isFavorite)
          .map((product) => product.id)
          .toList();
      
      await _productRepository.saveFavorites(favoriteIds);
      notifyListeners();
    }
  }
}