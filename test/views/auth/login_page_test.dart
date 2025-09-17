import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../test_helpers/load_test_env_variables.dart';

void main() {

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    loadTestEnvVariables();
    SharedPreferences.setMockInitialValues(<String, Object>{});

    // final DioAdapter dioAdapter = DioAdapter(dio: ApiRepository.apiClient);
    // LoginMockApi.initializeMockServer(dioAdapter: dioAdapter);
  });

  group('LoginPage:- Widgets presence test group', () {
  //   testWidgets('AppBar presence test', (WidgetTester tester) async {
  //     await WidgetTestHelper.widgetPresenceTestByText(
  //       tester: tester,
  //       testWidget: const LoginPage(),
  //       parentOfText: AppBar,
  //       text: 'Flutter BLoC Boiler Plate',
  //     );
  //   });

  //   testWidgets('Username TextField presence', (WidgetTester tester) async {
  //     await WidgetTestHelper.widgetPresenceTestByKey(
  //       tester: tester,
  //       testWidget: const LoginPage(),
  //       widgetKey: userNameFieldKey,
  //     );
  //   });

  //   testWidgets('Password TextField presence', (WidgetTester tester) async {
  //     await WidgetTestHelper.widgetPresenceTestByKey(
  //       tester: tester,
  //       testWidget: const LoginPage(),
  //       widgetKey: passwordFieldKey,
  //     );
  //   });

  //   testWidgets('Login Button Presence', (WidgetTester tester) async {
  //     await WidgetTestHelper.widgetPresenceTestByKey(
  //       tester: tester,
  //       testWidget: const LoginPage(),
  //       widgetKey: loginButtonKey,
  //     );
  //   });
  // });

  // group('LoginPage:- Tap and add text interaction', () {
  //   testWidgets('Username TextField', (WidgetTester tester) async {
  //     await WidgetTestHelper.enterTextTestByKey(
  //       tester: tester,
  //       testWidget: const LoginPage(),
  //       widgetKey: userNameFieldKey,
  //       text: 'TCRO1',
  //     );
  //   });

  //   testWidgets('Password TextField', (WidgetTester tester) async {
  //     await WidgetTestHelper.enterTextTestByKey(
  //       tester: tester,
  //       testWidget: const LoginPage(),
  //       widgetKey: passwordFieldKey,
  //       text: 'Password@123',
  //     );
  //   });

  //   group('LoginPage:- Login Form validation', () {
  //     testWidgets('Leaving username empty', (WidgetTester tester) async {
  //       await WidgetTestHelper.validationTextPresenceTestByKey(
  //         tester: tester,
  //         testWidget: const LoginPage(),
  //         widgetKey: userNameFieldKey,
  //         validationText: 'User Name should be filled.',
  //       );
  //     });

  //     testWidgets('Leaving password empty', (WidgetTester tester) async {
  //       await WidgetTestHelper.validationTextPresenceTestByKey(
  //         tester: tester,
  //         testWidget: const LoginPage(),
  //         widgetKey: passwordFieldKey,
  //         validationText: 'Enter a valid Password.',
  //       );
  //     });

  //     testWidgets('Filling invalid password format', (WidgetTester tester) async {
  //       await WidgetTestHelper.validationTextPresenceTestByKey(
  //         tester: tester,
  //         testWidget: const LoginPage(),
  //         widgetKey: passwordFieldKey,
  //         enteredText: 'password',
  //         validationText: 'Enter a valid Password.',
  //       );
  //     });

  //     testWidgets('Successful validation', (WidgetTester tester) async {
  //       await tester.pumpWidget(
  //         const TestApp(
  //           testWidget: LoginPage(),
  //         ),
  //       );
  //       await tester.pump();

  //       final Finder usernameFieldFinder = find.byKey(userNameFieldKey);
  //       final Finder passwordFieldFinder = find.byKey(passwordFieldKey);
  //       await tester.enterText(usernameFieldFinder, 'TCRO1');
  //       await tester.enterText(passwordFieldFinder, 'Password@123');
  //       await tester.pump(const Duration(milliseconds: 2000));
  //       expect(
  //         find.text('User Name should be filled.'),
  //         findsNothing,
  //       );
  //       expect(
  //         find.text('Enter a valid Password.'),
  //         findsNothing,
  //       );
  //     });
  //   });

  //   group('LoginPage:- Login button tap', () {
  //     testWidgets('Check for loading text', (WidgetTester tester) async {
  //       await tester.pumpWidget(
  //         const TestApp(
  //           testWidget: LoginPage(),
  //         ),
  //       );
  //       await tester.pump();

  //       final Finder usernameFieldFinder = find.byKey(userNameFieldKey);
  //       final Finder passwordFieldFinder = find.byKey(passwordFieldKey);
  //       final Finder loginButtonFinder = find.byKey(loginButtonKey);

  //       await tester.enterText(usernameFieldFinder, 'TCRO1');
  //       await tester.enterText(passwordFieldFinder, 'Password@123');
  //       await tester.pump();

  //       await tester.tap(loginButtonFinder);
  //       await tester.pump();
  //       expect(find.text('Logging in...'), findsOneWidget);
  //       await tester.pump(const Duration(milliseconds: 1000));
  //     });

  //     testWidgets('Successful Login', (WidgetTester tester) async {
  //       await tester.pumpWidget(
  //         const TestApp(
  //           testWidget: LoginPage(),
  //         ),
  //       );
  //       await tester.pump();

  //       final Finder usernameFieldFinder = find.byKey(userNameFieldKey);
  //       final Finder passwordFieldFinder = find.byKey(passwordFieldKey);
  //       final Finder loginButtonFinder = find.byKey(loginButtonKey);

  //       await tester.enterText(usernameFieldFinder, 'TCRO1');
  //       await tester.enterText(passwordFieldFinder, 'Password@123');
  //       await tester.pump();

  //       await tester.tap(loginButtonFinder);
  //       await tester.pumpAndSettle(const Duration(milliseconds: 2000));
  //       expect(find.byType(HomePage), findsOneWidget);
  //     });

  //     testWidgets('Unauthorized Login', (WidgetTester tester) async {
  //       await tester.pumpWidget(
  //         const TestApp(
  //           testWidget: LoginPage(),
  //         ),
  //       );
  //       await tester.pump();

  //       final Finder usernameFieldFinder = find.byKey(userNameFieldKey);
  //       final Finder passwordFieldFinder = find.byKey(passwordFieldKey);
  //       final Finder loginButtonFinder = find.byKey(loginButtonKey);

  //       await tester.enterText(usernameFieldFinder, 'TCR');
  //       await tester.enterText(passwordFieldFinder, 'Password@456');
  //       await tester.pump();

  //       await tester.tap(loginButtonFinder);
  //       await tester.pump(const Duration(milliseconds: 2000));
  //       expect(find.byType(SnackBar), findsOneWidget);
  //     });
  //   });
  });
}
