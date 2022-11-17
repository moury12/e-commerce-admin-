import 'package:ecommerce/utils/widget_function.dart';
import 'package:ecommerce/providers/productprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName = '/category';
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSingleInputDialogBox(
              context: context,
              title: 'Category',
              positiveButtonText: 'ADD',
              onSubmit: (value) {
                Provider.of<ProductProvider>(context, listen: false)
                    .addNewCategory(value);
              });
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text('Category List'),),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return provider.categorelist.isEmpty? const Center(child: Text('Category list id empty'),):
          ListView.builder(
            itemCount: provider.categorelist.length,
            itemBuilder: (context, index) {
              final catModel =provider.categorelist[index];
              return ListTile(
                title: Text(catModel.categoryName),
                trailing: Text('Total: ${catModel.productCount}'),
              );
            },
          );
        }
      )
    );
  }
}
