part of 'product_bloc.dart';

abstract class ProductState extends Equatable {}

class ProductInitial extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductLoading extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductLoaded extends ProductState {
  final List<Product> products;

  ProductLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class ProductAdded extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductError extends ProductState {
  final String msg;

  ProductError({required this.msg});

  @override
  List<Object?> get props => [msg];
}
