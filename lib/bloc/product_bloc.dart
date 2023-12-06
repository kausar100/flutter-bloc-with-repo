import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hello_flutter/data/model/product.dart';
import 'package:hello_flutter/data/repository/products_repo.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductsRepository productsRepository;

  ProductBloc({required this.productsRepository}) : super(ProductInitial()) {
    _init();
    on<AddProduct>(_addProduct);
    on<GetProduct>(_getProducts);
  }

  _init() async {
    emit(ProductLoading());
    try {
      List<Product> products = await productsRepository.initialProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(msg: e.toString()));
    }
  }

  _addProduct(event, emit) async {
    emit(ProductLoading());
    try {
      if (event is AddProduct) {
        await productsRepository.addProduct(event.product);
        emit(ProductAdded());
      }
    } catch (e) {
      emit(ProductError(msg: e.toString()));
    }
  }

  _getProducts(event, emit) async {
    emit(ProductLoading());
    try {
      List<Product> products = await productsRepository.getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(msg: e.toString()));
    }
  }
}
