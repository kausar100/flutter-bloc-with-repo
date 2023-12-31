import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/bloc/product/product_bloc.dart';
import 'package:hello_flutter/data/model/product.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ProductBloc>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductAdded) {
              const snackBar =
                  SnackBar(content: Text("Product is added Successfully!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              bloc.add(GetProduct());
            }
          },
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductLoaded) {
                return ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products.elementAt(index);
                    return ListTile(
                        title: Text(product.name),
                        trailing: Text(product.price.toString()));
                  },
                );
              }
              return Container();
            },
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _showModalBottomSheet, child: const Icon(Icons.add)),
    );
  }

  _showModalBottomSheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0.0;
        final keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;

        return Container(
          padding: const EdgeInsets.only(
              top: 32.0, bottom: 8.0, left: 16.0, right: 16.0),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          height: isKeyboardVisible
              ? MediaQuery.of(context).size.height * 0.36 + keyBoardHeight
              : MediaQuery.of(context).size.height * 0.36,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Product Name',
                    ),
                    textInputAction: TextInputAction.next,
                    controller: _productNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                    ),
                    controller: _productPriceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            final newProduct = Product(
                                name: _productNameController.text,
                                price: int.parse(_productPriceController.text));

                            context
                                .read<ProductBloc>()
                                .add(AddProduct(product: newProduct));

                            _productNameController.text = "";
                            _productPriceController.text = "";

                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Submit'),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
