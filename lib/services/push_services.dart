import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static StreamController<String> _messagesStreamController =
      new StreamController.broadcast();

  static Stream<String> get messagesStream => _messagesStreamController.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    print('SE RECIBIO EN BACKGROUND ${message.data}');
    _messagesStreamController.add(message.notification?.title ?? 'No title');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('SE RECIBIO ON MESSAGE ${message.data}');
    _messagesStreamController.add(message.data['apellido'] ?? 'No lastname');
  }

  static Future _onMessageOpenAppHandler(RemoteMessage message) async {
    print('SE RECIBIO ON OPENED APP CON DATA ${message.data}');
    _messagesStreamController.add(message.data['nombre'] ?? 'No name');
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print(token);

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenAppHandler);
  }

  static closeStreams() {
    _messagesStreamController.close();
  }
}
