import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/pages/product_details_page.dart';
import 'package:ecommerce/providers/productprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ViewProductPage extends StatefulWidget {
  static const String routeName = '/viewproduct';
  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  CategoryModel? categoryModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,toolbarHeight: 40,),
      body:
      Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<CategoryModel>(
                  hint: const Text('Select Category'),
                  value: categoryModel,
                  isExpanded: true,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  items: provider
                      .getAllProductByCategoryAll()
                      .map((catModel) => DropdownMenuItem(
                      value: catModel, child: Text(catModel.categoryName)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      categoryModel = value;
                    });
                    provider.getAllProductsProductByCategory(categoryModel!);
                  },
                ),
              ),
              provider.productlist.isEmpty ?
              const Expanded(child: Center(child: Text('No item found'),)) :
              Expanded(
                child: ListView.builder(
                  itemCount: provider.productlist.length,
                  itemBuilder: (context, index) {
                    final product = provider.productlist[index];
                    return ListTile(
                      onTap: () => Navigator.pushNamed(
                          context,
                          ProductDetailsPage.routeName,
                          arguments: product),
                      leading: CachedNetworkImage(
                        width: 75,
                        imageUrl: product.thumbnailImageUrl,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      title: Text(product.productName),
                      subtitle: Text(product.category.categoryName),
                      trailing: Text('Stock: ${product.stock}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

              );


  }
}
