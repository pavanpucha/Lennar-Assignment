import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mockito/annotations.dart';

import '../models/picsum_model.dart';
import '../services/picsum_api_service.dart';

enum PageState { ERROR, LOADING, DONE }

enum ChildLoaded { Loaded, None }

@GenerateNiceMocks([MockSpec<PicsumImageProvider>()])
//import 'picsum_image_provider.mocks.dart';

class PicsumImageProvider extends ChangeNotifier {
  PicsumPayload? originalPicsumPayload = PicsumPayload([]);
  PageState? pageState;

  late PagingState pagingState;
  final PagingController<int, PicsumImage> pagingController =
  PagingController(firstPageKey: 1);

  int currentPage = 0;
  bool isPaginationEnd = false;

  ChildLoaded childLoaded = ChildLoaded.None;
  PicsumImage? selectedImage;

  PicsumImageProvider() {
    this.pageState = PageState.LOADING;
    this.childLoaded = ChildLoaded.None;
    fetchInitialData();
    initPagination();
  }

  initPagination() {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await PicsumApiService().getImagesByPage(pageKey);
      originalPicsumPayload?.picsumImages
          .addAll(newItems.picsumImages);
      final isLastPage = newItems.picsumImages.isEmpty ? true : false;
      if (isLastPage) {
        pagingController.appendLastPage(newItems.picsumImages);
      } else {
        pagingController.appendPage(newItems.picsumImages, pageKey + 1);
      }
    } catch (error) {
      pagingController.error = error;
    }
    notifyListeners();
  }

  fetchInitialData() async {
    pageState = PageState.LOADING;
    notifyListeners();
    try {
      await _fetchPage(0);
      pageState = PageState.DONE;
    } catch (e) {
      pageState = PageState.ERROR;
      notifyListeners();
      throw Exception();
    }
    notifyListeners();
  }

  searchQuery(String searchQuery) {
    notifyListeners();
  }

  onExitDetailPage() {
    if(childLoaded == ChildLoaded.Loaded) {
      selectedImage = null;
      childLoaded = ChildLoaded.None;
      notifyListeners();
    }
    else {
      throw Exception();
    }
  }

  onTapImage(int idx) {
    selectedImage = originalPicsumPayload?.picsumImages[idx];
    childLoaded = ChildLoaded.Loaded;
    notifyListeners();
  }
}
