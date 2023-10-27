// Mocks generated by Mockito 5.4.2 from annotations
// in image_viewer/test/widget_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:image_viewer/repo/app_repository.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [AppPrefsRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppPrefsRepository extends _i1.Mock
    implements _i2.AppPrefsRepository {
  MockAppPrefsRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get picsum_key => (super.noSuchMethod(
        Invocation.getter(#picsum_key),
        returnValue: '',
      ) as String);

  @override
  bool get isLoggedIn => (super.noSuchMethod(
        Invocation.getter(#isLoggedIn),
        returnValue: false,
      ) as bool);

  @override
  dynamic getFromDisk(String? key) => super.noSuchMethod(Invocation.method(
        #getFromDisk,
        [key],
      ));

  @override
  void savePicsumPayload(String? content) => super.noSuchMethod(
        Invocation.method(
          #savePicsumPayload,
          [content],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setLogin() => super.noSuchMethod(
        Invocation.method(
          #setLogin,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void clearCredentials() => super.noSuchMethod(
        Invocation.method(
          #clearCredentials,
          [],
        ),
        returnValueForMissingStub: null,
      );
}