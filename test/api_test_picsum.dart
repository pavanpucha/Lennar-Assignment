import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:image_viewer/models/picsum_model.dart';
import 'package:image_viewer/services/picsum_api_service.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_test_picsum.mocks.dart';
import 'test_payload.dart';

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Map<String, String> q_param(int pageNum) {
    return {"page": pageNum.toString()};
  };

  final _client = MockClient();

  group('fetchImages', () {
    test('successful return of picsum', () async {
      when(_client.get(Uri.https("picsum.photos", "v2/list")))
          .thenAnswer((_) async => http.Response(TestPayload().dummyPayload, 200));
      expect(await PicsumApiService(httpClient: _client).getNetworkImages(),
          isA<PicsumPayload>());
    });

    test('successful return of paginated request', () async {
      when(_client.get(Uri.https("picsum.photos", "v2/list", q_param(1))))
          .thenAnswer((_) async => http.Response(TestPayload().dummyPayload, 200));
      expect(await PicsumApiService(httpClient: _client).getImagesByPage(1),
          isA<PicsumPayload>());
    });

    test('Throws exception', () async {
      when(_client.get(Uri.https("picsum.photos", "v2/list")))
          .thenAnswer((_) async => http.Response('', 403));
      // throwsA(Exception());
      expect(
          PicsumApiService(httpClient: _client).getNetworkImages(),
          // throwsA(isA<SomeException>())
          throwsException);
    });
  });
}
