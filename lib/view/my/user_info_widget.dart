import 'package:flutter/material.dart';
import 'package:shuichan_app/api/api.dart';

///  头像Icon
class UserIconWidget extends StatelessWidget {
  final bool isNetwork;
  final String image;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final String defaultImg = 'assets/images/default_nor_avatar.png';

  UserIconWidget(
      {this.isNetwork,
      this.image,
      this.onPressed,
      this.width = 30.0,
      this.height = 30.0,
      this.padding});

  @override
  Widget build(BuildContext context) {
    var assetImage;
    if (this.isNetwork && this.image != null) {
      assetImage = new FadeInImage.assetNetwork(
        placeholder: this.defaultImg,
        //预览图
        fit: BoxFit.fitWidth,
        image: '${Api.BASE_URL}$image',
        width: width,
        height: height,
      );
    } else {
      assetImage = new Image.asset(
        this.image != null ? image : this.defaultImg,
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
    }

    return new RawMaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding:
            padding ?? const EdgeInsets.only(top: 4.0, right: 5.0, left: 5.0),
        constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        child: new ClipRRect(
          borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          child: assetImage,
        ),
        onPressed: onPressed);
  }
}
