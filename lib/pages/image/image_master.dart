import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:image_viewer/provider/authentication_provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../helpers/screen_utils.dart';
import '../../models/picsum_model.dart';
import '../../provider/picsum_image_provider.dart';
import 'image_detail_page.dart';

class ImagesMasterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);

    void onTapImage(int idx) {
      print("ontap");
      Provider.of<PicsumImageProvider>(context, listen: false)
          .onTapImage(idx);
      if (ScreenUtil.screenWidth < ScreenUtil.tabletMinWidth) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ImageDetailPage()));
      }
    }

    CachedNetworkImage cachedImage(String src) {
      return CachedNetworkImage(
        imageUrl: src,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => const AspectRatio(
          aspectRatio: 1.6,
          child: BlurHash(hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }

    ScreenUtil().init(context);


    PagedGridView pagedGridView(PicsumImageProvider picsumImageProvider) {
      return PagedGridView<int, PicsumImage>(
        pagingController: picsumImageProvider.pagingController,
        builderDelegate: PagedChildBuilderDelegate<PicsumImage>(
            itemBuilder: (context, item, index) => GestureDetector(
                onTap: () {
                  onTapImage(index);
                },
                child: cachedImage(item.downloadUrl))),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Picsum Images"),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<AuthenticationProvider>(context, listen: false)
                    .logout();
              },
              icon: Icon(Icons.logout))
        ],
        automaticallyImplyLeading: true,
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(child: SizedBox(child: Consumer<PicsumImageProvider>(
              builder: (context, imageProvider, child) {
            return imageProvider.pageState == PageState.LOADING
                ? const Center(child: CircularProgressIndicator())
                : imageProvider.pageState == PageState.ERROR
                    ? const Text("Error Loading Data")
                    : Container(
                        padding: EdgeInsets.all(8),
                        child: pagedGridView(imageProvider));


          }))),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
                onPressed: () {
                  Provider.of<PicsumImageProvider>(context, listen: false)
                      .fetchInitialData();
                },
                child: const Text(
                  "Refresh Image List",
                  style: TextStyle(color: Colors.black),
                )),
          )
        ],
      )),
    );
  }
}
