// import 'package:android_intent_plus/android_intent.dart';
// import 'package:android_intent/android_intent.dart';
// import 'package:android_intent/flag.dart';
// import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wordpress_api/wordpress_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const Test(),
    );
  }
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  List<Post> lst = [];
  @override
  void initState() {
    getIgPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.grey,
            height: 300,
            margin: const EdgeInsets.only(top: 25, left: 0, right: 0),
            child: lst.isEmpty
                ? const Center(
                    child: Text('Loading'),
                  )
                : CarouselSlider(
                    options: CarouselOptions(
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        autoPlay: false,
                        viewportFraction: 0.85),
                    items: lst
                        .map(
                          (e) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    e.content.toString()),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  void getIgPost() async {
    final api = WordPressAPI('https://www.wavahusada.com');
    final WPResponse res = await api.posts
        .fetch(args: {"categories": 822, "per_page": 5, "page": 1});
    print(res.data);
    for (final post in res.data) {
      final WPResponse pict = await api.media.fetch(id: post.featuredMedia);
      lst.add(Post(
          title: post.title,
          guid: post.guid,
          content: pict.data.mediaDetails['sizes']['medium']['source_url']
              .toString()));
      print(pict.data.mediaDetails.toString());
    }
    setState(() {});
  }
}


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Aplikasi Client'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () => _openGdcPay('asia.cyberlabs.gdc'),
//               child: const Text('Bayar'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   _openGdcPay(data) async {
//     String dt = data as String;
//     bool isInstalled = await DeviceApps.isAppInstalled('asia.cyberlabs.gdc');
//     if (isInstalled != false) {
//       AndroidIntent intent = const AndroidIntent(
//         action: 'android.intent.action.VIEW',
//         flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
//         package: 'asia.cyberlabs.gdc',
//         arguments: {'another': 'pembayaran pulsa Rp. 30.000'},
//       );

//       await intent.launch();
//     } else {
//       String url = dt;
//       print('aplikasi tidak terinstall');
//     }
//   }
// }
