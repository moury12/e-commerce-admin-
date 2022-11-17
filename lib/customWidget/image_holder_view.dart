import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class ImageHolderView extends StatelessWidget {
  final Widget child;
  final String url;
  final VoidCallback onImagePressed;

  const ImageHolderView({Key? key,required this.child, this.url='',required this.onImagePressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
    width: 80,
    height: 80,
    alignment: Alignment.center,
    decoration: BoxDecoration(
    border: Border.all(color: Colors.grey, width: 1.5)),
        child: url.isEmpty ? child :
      InkWell(onTap: onImagePressed,
        child: CachedNetworkImage(imageUrl: url,fit: BoxFit.cover,
          placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),),
      ),
    );  }
}
