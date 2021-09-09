import 'package:flutter/material.dart';
import 'package:push/screens/home_screen.dart';
import 'package:push/screens/message_screen.dart';

import 'services/push_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PushService.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    PushService.messagesStream.listen((message) {
      print('Mensaje desde mi App: $message');

      final snackBar = SnackBar(content: Text(message));
      messengerKey.currentState?.showSnackBar(snackBar);
      navigatorKey.currentState?.pushNamed('message', arguments: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notificaciones Push',
        initialRoute: 'home',
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: messengerKey,
        routes: {
          'home': (_) => HomeScreen(),
          'message': (_) => MessageScreen()
        });
  }
}
