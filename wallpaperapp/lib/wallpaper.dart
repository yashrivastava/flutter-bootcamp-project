import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/fullscreen.dart';

class wallpaper extends StatefulWidget {
  @override
  _wallpaperState createState() => _wallpaperState();
}

class _wallpaperState extends State<wallpaper> {
  List images = [];
  int page = 1;
  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              '563492ad6f91700001000001178d5e0eb58c4ed0abb90c1ef733bf7a'
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      print(images[0]);
    });
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '563492ad6f91700001000001178d5e0eb58c4ed0abb90c1ef733bf7a'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'W  A  L  L  P  A  P  E  R  S',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                  child: GridView.builder(
                      itemCount: images.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 2,
                          crossAxisCount: 3,
                          childAspectRatio: 2 / 3,
                          mainAxisSpacing: 2),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FullScreen(
                                          imageurl: images[index]['src']
                                              ['large2x'],
                                        )));
                          },
                          child: Container(
                            color: Colors.teal[50],
                            child: Image.network(
                              images[index]['src']['tiny'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      })),
            ),
            InkWell(
              onTap: () {
                loadmore();
              },
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.teal,
                child: Center(
                  child: Text(
                    'M  O  R  E',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
