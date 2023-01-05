import 'dart:io';

import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/screens/productDetailScreen/widget/otherImagesBoxDecoration.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductFullScreenImagesScreen extends StatefulWidget {
  final List<String> images;
  final int initialPage;

  ProductFullScreenImagesScreen(
      {Key? key, required this.images, required this.initialPage})
      : super(key: key);

  @override
  State<ProductFullScreenImagesScreen> createState() =>
      _ProductFullScreenImagesScreenState();
}

class _ProductFullScreenImagesScreenState
    extends State<ProductFullScreenImagesScreen> {
  int? currentImage;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    currentImage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoViewGallery.builder(
          scrollPhysics: BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.images[index]),
              initialScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered,
            );
          },
          pageController: _pageController,
          onPageChanged: (index) {
            currentImage = index;
            setState(() {});
          },
          itemCount: widget.images.length,
        ),
        if (Platform.isIOS)
          PositionedDirectional(
              start: 15,
              top: 45,
              child: Container(
                width: 40,
                height: 40,
                decoration: DesignConfig.boxGradient(10),
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.paddingOrMargin7,
                    vertical: Constant.paddingOrMargin7),
                child: Widgets.defaultImg(
                    image: "back_icon", iconColor: Colors.white),
              )),
        PositionedDirectional(
          start: 10,
          end: 10,
          bottom: 30,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  widget.images.length > 1 ? widget.images.length : 0, (index) {
                return GestureDetector(
                  onTap: () {
                    currentImage = index;
                    _pageController.animateToPage(currentImage!,
                        curve: Curves.easeOut,
                        duration: Duration(milliseconds: 300));
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Constant.paddingOrMargin5),
                    decoration: getOtherImagesBoxDecoration(
                        isActive: (currentImage == index)),
                    child: ClipRRect(
                        borderRadius: Constant.borderRadius10,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Widgets.setNetworkImg(
                            height: 60,
                            width: 60,
                            image: widget.images[index],
                            boxFit: BoxFit.fill)),
                  ),
                );
              }),
            ),
          ),
        )
      ],
    );
  }
}
