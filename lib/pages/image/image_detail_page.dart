import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:provider/provider.dart';
import '../../helpers/screen_utils.dart';
import '../../models/picsum_model.dart';
import '../../provider/picsum_image_provider.dart';

class ImageDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);

    final ChildLoaded childLoaded =
        Provider.of<PicsumImageProvider>(context, listen: true).childLoaded;

    IconButton leadingIcon() {
      return ScreenUtil.screenWidth < ScreenUtil.tabletMinWidth
          ? IconButton(
              onPressed: () {
                Provider.of<PicsumImageProvider>(context, listen: false)
                    .childLoaded = ChildLoaded.None;
                Provider.of<PicsumImageProvider>(context, listen: false)
                    .selectedImage = null;
                Navigator.pop(context);
              },
              icon: material.Icon(Icons.arrow_back))
          : IconButton(
              onPressed: () {
                Provider.of<PicsumImageProvider>(context, listen: false)
                    .onExitDetailPage();
              },
              icon: material.Icon(Icons.clear));
    }

    AppBar childAppBar() {
      return AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: leadingIcon(),
        title: Text("Image Detail"),
        centerTitle: true,
      );
    }

    AppBar noDetailAppBar() {
      return AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
      );
    }

    CachedNetworkImage cachedNetworkImage(String src) {
      return CachedNetworkImage(
        imageUrl: src,
        placeholder: (context, url) => const AspectRatio(
          aspectRatio: 1.6,
          child: BlurHash(hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }

    Widget ImageDetail(PicsumImage picsumImage) {
      return Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: cachedNetworkImage(picsumImage!.downloadUrl),
            ),
            Center(
              child: Text(
                "Photo by ${picsumImage.author}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    return Consumer<PicsumImageProvider>(
        builder: (context, picsumImageProvider, child) {
      return Scaffold(
          appBar: childLoaded == ChildLoaded.Loaded
              ? childAppBar()
              : noDetailAppBar(),
          body: picsumImageProvider.childLoaded == ChildLoaded.Loaded
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                      child: ImageDetail(picsumImageProvider.selectedImage!)),
                )
              : Container(
                  child: const Center(
                    child: Text(
                      "Please select an Image to view more information",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ));
    });
  }
}
