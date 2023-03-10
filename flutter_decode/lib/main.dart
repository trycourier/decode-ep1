import 'package:courier_flutter/courier_flutter.dart';
import 'package:courier_flutter/courier_provider.dart';
import 'package:courier_flutter/ios_foreground_notification_presentation_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_decode/firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> _onButtonClick() async {

    const accessToken = 'pk_prod_4XPS5PVFEBM48RQCXTK4P0BH1CXJ';
    const userId = 'decode_user';

    await Courier.shared.signIn(
      accessToken: accessToken,
      userId: userId,
    );

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await Courier.shared.setFcmToken(token: fcmToken);
    }

    final requestedNotificationPermission = await Courier.shared.requestNotificationPermission();
    print(requestedNotificationPermission);

    Courier.shared.iOSForegroundNotificationPresentationOptions = [
      iOSNotificationPresentationOption.banner,
      iOSNotificationPresentationOption.sound,
      iOSNotificationPresentationOption.list,
      iOSNotificationPresentationOption.badge,
    ];

    final messageId = await Courier.shared.sendPush(
      authKey: accessToken,
      userId: userId,
      title: 'Chirp Chrip!',
      body: 'Hello from Courier ????',
      providers: [CourierProvider.fcm],
    );

    print(messageId);

  }

  @override
  void initState() {
    super.initState();

    Courier.shared.signOut();

    // Will be called if the app is in the foreground and a push notification arrives
    Courier.shared.onPushNotificationDelivered = (push) {
      print(push);
    };

    // Will be called when a user clicks a push notification
    Courier.shared.onPushNotificationClicked = (push) {
      print(push);
    };

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hello!',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onButtonClick,
        tooltip: 'Increment',
        child: const Icon(Icons.mail),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
