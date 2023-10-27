import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_viewer/models/picsum_model.dart';
import 'package:image_viewer/provider/picsum_image_provider.dart';
import 'package:mockito/annotations.dart';
@GenerateNiceMocks([MockSpec<PicsumImageProvider>()])
import 'picsum_provider_test.mocks.dart';
import 'test_payload.dart';

void main() {
  late PicsumImageProvider mockPicsumProvider;
  setUp(() {
    mockPicsumProvider = PicsumImageProvider();
  });

  group("Picsum Provider Tests", () {
    test("Initial values", () {
      expect(mockPicsumProvider.pageState, PageState.LOADING);
      expect(mockPicsumProvider.childLoaded, ChildLoaded.None);
      expect(mockPicsumProvider.pagingController.firstPageKey, 1);
      expect(mockPicsumProvider.selectedImage, null);
      expect(mockPicsumProvider.currentPage, 0);
      expect(
          mockPicsumProvider.originalPicsumPayload!.picsumImages.isEmpty, true);
    });

    test("Page state changes after fetching data", () async {
      final fetchData = await mockPicsumProvider.fetchInitialData();
      expect(mockPicsumProvider.pageState, PageState.DONE);
    });

    test("Image list is empty at init", () {
      final imageListCount =
          mockPicsumProvider.originalPicsumPayload?.picsumImages.length;
      expect(imageListCount, 0);
    });

    group("provider with data", () {
      final testData =
          PicsumPayload(picsumImageFromJson(TestPayload().dummyPayload));
      test(
          "Loads Data, and taps child Image and checks if the child is loaded, then exit detail page"
          "and checks if child is not loaded", () {
        mockPicsumProvider.originalPicsumPayload = testData;
        mockPicsumProvider.onTapImage(0);
        expect(mockPicsumProvider.childLoaded, ChildLoaded.Loaded);
        mockPicsumProvider.onExitDetailPage();
        expect(mockPicsumProvider.childLoaded, ChildLoaded.None);
      });

      test("Range exception when onTapImage method is called on empty list",
          () {
        expect(() => throw mockPicsumProvider.onTapImage(0),
            throwsA(isA<RangeError>()));
      });

      test(
          "exception when onExitDetailPage method is called when there is no child selected",
          () {
        expect(() => throw mockPicsumProvider.onExitDetailPage(),
            throwsA(isA<Exception>()));
      });
    });
  });
}
