import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class ProductRepository {
  final ApiService _apiService;
  final LocalStorageService _localStorageService;

  ProductRepository({
    required ApiService apiService,
    required LocalStorageService localStorageService,
  })  : _apiService = apiService,
        _localStorageService = localStorageService;

  Future<List<Product>> fetchProducts() async {
    try {
      final products = await _apiService.fetchProducts();
      final favoriteIds = await _localStorageService.loadFavorites();
      
      for (var product in products) {
        product.isFavorite = favoriteIds.contains(product.id);
      }
      
      return products;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      return await _apiService.fetchCategories();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveFavorites(List<int> favoriteIds) async {
    try {
      await _localStorageService.saveFavorites(favoriteIds);
    } catch (e) {
      rethrow;
    }
  }
}