import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:order_wizard/utils/routes.dart';
import 'package:order_wizard/utils/service_locator.dart';

Future<void> initService() async {
  setupServiceLocator();
}

// Configure the router
final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  routes: $appRoutes,
);

void main() {
  initService();
  runApp(const MyApp());
}

// final GoRouter router = GoRouter(
//   initialLocation: '/',
//   navigatorKey: ,
//   routes: 
// );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      routerConfig: router,
      title: 'Order Wizard',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
        brightness: Brightness.light,
        barBackgroundColor: CupertinoColors.systemBackground,
        scaffoldBackgroundColor: CupertinoColors.systemBackground,
      ),
    );
  }
}