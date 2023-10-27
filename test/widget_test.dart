// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:image_viewer/main.dart';
import 'package:image_viewer/provider/LoginProvider.dart';
import 'package:image_viewer/provider/authentication_provider.dart';
import 'package:image_viewer/provider/picsum_image_provider.dart';
import 'package:image_viewer/repo/app_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([AppPrefsRepository])
void main() {
  late MockAppPrefsRepository mockAppPrefsRepository;

  setUp(() => mockAppPrefsRepository = MockAppPrefsRepository());


  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: "Picsum Image Viewer",
      home: MultiProvider(providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider<PicsumImageProvider>(
            create: (_) => PicsumImageProvider())
      ], child: PicsumImageViewerApp()),
    );
  }

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify that our counter starts at 0.
    expect(find.text('Login Page'), findsOneWidget);

    expect(find.text('username'), findsOneWidget);
    //
    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();
    //
    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
