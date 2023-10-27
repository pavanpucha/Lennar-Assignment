import 'package:flutter/widgets.dart';
import '../../helpers/screen_utils.dart';
import 'image_detail_page.dart';
import 'image_master.dart';

class PicsumHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);

    return LayoutBuilder(builder: (context, constraints) {
      return ScreenUtil.orientation == Orientation.landscape ||
              constraints.maxWidth > ScreenUtil.tabletMinWidth
          ? TabletHomePage()
          : ImagesMasterWidget();
    });
  }
}

class MobileHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImagesMasterWidget();
  }
}

class TabletHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 300,
          color: Color(0xFFEFEFEF),
          child: ImagesMasterWidget(),
        ),
        Expanded(child: ImageDetailPage())
      ],
    );
  }
}
