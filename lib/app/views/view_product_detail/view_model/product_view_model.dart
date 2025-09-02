import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductDetailViewModel extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailViewModel() : super(ProductDetailInitial()) {
    on<LoadProductDetail>((event, emit) async {
      emit(ProductDetailLoading());
      try {
        // Burada async veri çekme işlemi yapabilirsin
        // Şimdilik direkt event içindeki ürünü yüklüyoruz
        await Future.delayed(const Duration(milliseconds: 500));
        emit(ProductDetailLoaded(event.product));
      } catch (e) {
        emit(ProductDetailError('Failed to load product details.'));
      }
    });
  }
}

