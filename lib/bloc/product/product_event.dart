
part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProduct extends ProductEvent {}

class AddProduct extends ProductEvent {
  final Product product;
  AddProduct({required this.product});
}
