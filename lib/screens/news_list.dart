import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:newswizard/top_headline_response.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:newswizard/screens/about.dart';
import 'package:newswizard/source_data.dart';
import 'package:share/share.dart';
import 'package:newswizard/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:newswizard/screens/news_webview.dart';

class NewsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewsListState();
  }
}

class NewsListState extends State<NewsList> {
  Future<TopHeadlineResponse> futureData;
  TopHeadlineResponse dummyData;
  Future<SourceData> sourceData;

  //Completer<WebViewController> _controller = Completer<WebViewController>();

  String dropdownValue;
  String countryDropdownValue = 'All';

  @override
  void initState() {
    super.initState();
    futureData = callTopHeadlineAPI();
    sourceData = callSourceDataAPI();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  Future<SourceData> callSourceDataAPI() async {
    var queryParameters = {
      'apiKey': '62f4a0d66e1e4665b2b1da403824f090',
    };

    var uri = Uri.https('newsapi.org', '/v2/sources', queryParameters);

    final response = await http.delete(uri);
    //   if (response.statusCode == 200) {
    return SourceData.fromJson(jsonDecode(response.body));
    // } else {
    //   throw Exception('Failed to load Source');
    // }
  }

  Future<TopHeadlineResponse> callTopHeadlineAPI() async {
    var queryParameters = {
      'country': 'us',
      'apiKey': '62f4a0d66e1e4665b2b1da403824f090',
    };

    var uri = Uri.https('newsapi.org', '/v2/top-headlines', queryParameters);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var responseBody = response.body;
      var decodedMap = jsonDecode(responseBody);
      return TopHeadlineResponse.fromJson(decodedMap);
    } else {
      var article = Articles(
          source: null,
          author: "Aman",
          title: "Aman Started Flutter",
          description: "History created",
          url: "www.google.com",
          urlToImage:
              "https://images.pexels.com/photos/4173624/pexels-photo-4173624.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          content: "",
          publishedAt: "",
          isFavourite: "false");
      var a = [article];

      Future<TopHeadlineResponse> dummy;
      setState(() {
        dummyData =
            TopHeadlineResponse(status: "200", totalResults: 1, articles: a);
      });
    }
  }

  Future<TopHeadlineResponse> callSearchAPI(
      {String q = "", String country = "", String source = ""}) async {
    var queryParameters = {
      'q': q,
      'source': source,
      'domains': "techcrunch.com,thenextweb.com",
      'apiKey': '62f4a0d66e1e4665b2b1da403824f090',
    };

    var uri = Uri.https('newsapi.org', '/v2/everything', queryParameters);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return TopHeadlineResponse.fromJson((jsonDecode(response.body)));
    } else {
      throw Exception('Failed to load');
    }
  }

  bool searchPressed = false;
  bool darkModeSwitch = true;
  var likeButton = Icons.favorite_border;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    void comingSoonAlertDialogue() {
      var csDialogue = AlertDialog(
          title: Row(
            children: [
              Icon(Icons.favorite,color: Colors.red,),
              Expanded(
                  child: Column(children: [
                Text(' Favourites '),
                Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 20.0),
                  child: Text(' coming soon'),
                )
              ]))
            ],
          ),
          content: Container(
              width: 10.0,
              child: Row(
                children: [
                  Spacer(),
                  FlatButton(
                    // color: Colors.white12,
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return csDialogue;
          });
    }

    return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
          title: Text('Discover Latest feed'),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.search_rounded),
                tooltip: ' Search ',
                onPressed: () {
                  setState(() {
                    searchPressed = !searchPressed;
                  });
                })
          ],
        ),
        drawer: Drawer(
            child: Column(
          children: <Widget>[
            Container(
              height: 50.0,
            ),
            Center(
              child: Image.asset('images/news_wizard_darkmode.png'),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10.0, top: 20.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Dark Mode'),
                    leading: Icon(Icons.brightness_4,),
                    trailing: Switch(
                        value: themeChange.darkTheme,
                        onChanged: (bool value) {
                          themeChange.darkTheme = value;
                        }),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Favorites'),
                    leading: Icon(Icons.favorite_outline_rounded),
                    onTap: (){
                      comingSoonAlertDialogue();
                    },
                  ),
                  ListTile(
                    title: Text('About'),
                    leading: Icon(Icons.info_outline),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AboutScreen();
                      }));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.power_settings_new_outlined),
                    title: Text('Exit'),
                    onTap: () {
                      exit(0);
                    },
                  )
                ],
              ),
            ),
          ],
        )),
        body: Center(
            child: Column(children: <Widget>[
          Visibility(
            visible: searchPressed,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50.0,
                  margin:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: ' Search ',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    onChanged: (text) {
                      setState(() {
                        if (text == "") {
                          futureData = callTopHeadlineAPI();
                        } else {
                          futureData = callSearchAPI(q: text);
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 1, child: Text(' Source  :')),
                      // Expanded(
                      //     flex: 4,
                      //     child: FutureBuilder<SourceData>(
                      //         future: sourceData,
                      //         builder: (context, snapshot) {
                      //           if (snapshot.hasData) {
                      //             return sourceDropDownList(
                      //                 snapshot.data.sources);
                      //           } else if (snapshot.hasError) {
                      //             return Text("${snapshot.error}");
                      //           }
                      //           return CircularProgressIndicator();
                      //         }))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(' Country  :')),
                      Expanded(child: countryDropDownList())
                    ],
                  ),
                )
              ],
            ),
          ),
          Flexible(
              child: Center(
                  child: //getNewsListView(dummyData.articles)
                      FutureBuilder<TopHeadlineResponse>(
                          future: futureData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              // return getNewsListView(dummyData.articles);
                              return getNewsListView(snapshot.data.articles);
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }

                            return CircularProgressIndicator();
                          }))),
        ])));
  }

  ListView getNewsListView(List<Articles> articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (BuildContext context, int position) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                // color: Colors.white12,
                elevation: 10.0,
                child: Column(
                  children: <Widget>[
                    FadeInImage.assetNetwork(
                        placeholder: 'images/placeholder_image.png',
                        image: articles[position].urlToImage ?? ""),
                    ListTile(
                      contentPadding: EdgeInsets.all(10.0),
                      title: Text(articles[position].title ?? ""),
                      subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(articles[position].description ?? "")),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return NewsWebView(url:articles[position].url ?? "", title: articles[position].title ?? "");
                        }));
                        debugPrint('Tile Tapped');
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                              child: Column(
                            children: <Widget>[
                              Container(
                                width: 200.0,
                                padding: const EdgeInsets.only(
                                    bottom: 3.0, left: 7.0),
                                child: Text(articles[position].author ?? ""),
                              ),
                              Container(
                                  width: 200.0,
                                  padding: const EdgeInsets.only(left: 7.0),
                                  child: Text(dateFormat(
                                      articles[position].publishedAt ?? ""))),
                            ],
                          )),
                          Spacer(),
                          IconButton(
                            tooltip: 'Add to favorites',
                            icon: articles[position].isFavourite
                                ? Icon(
                                    Icons.favorite,
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                  ),
                            onPressed: () {
                              setState(() {
                                articles[position].isFavourite =
                                    !articles[position].isFavourite;
                              });
                            },
                          ),
                          IconButton(
                            tooltip: 'share',
                            icon: Icon(
                              Icons.share,
                            ),
                            onPressed: () {
                              Share.share(articles[position].url ?? "",
                                  subject: articles[position].title ?? "");
                            },
                          ),
                          InkWell(
                            onTap: () {
                              displayBottomSheet(context);
                            },
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset('images/dotted_menu.png',
                                    height: 40.0, width: 40.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )));
      },
    );
  }

  String dateFormat(String date) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('d MMM yyyy');
    final String formatted = formatter.format(now);
    return formatted;
  }

  Widget sourceDropDownList(List<Sources> sources) {
    var sourceNameList = List<String>();

    for (var i = 0; i < sources.length; i++) {
      sourceNameList.add(sources[i].name);
    }
    return DropdownButton<String>(
      value: dropdownValue,
      // onTap: (){debugPrint('$dropdownValue tapped');},
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          debugPrint('$dropdownValue tapped');
          callSearchAPI(source: dropdownValue);
        });
      },
      items: sourceNameList.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget countryDropDownList() {
    return Column(
      children: [
        DropdownButton<String>(
          isExpanded: true,
          value: countryDropdownValue,
          // onTap: (){debugPrint('$dropdownValue tapped');},
          onChanged: (String newValue) {
            setState(() {
              countryDropdownValue = newValue;
              debugPrint('$countryDropdownValue tapped');
            });
          },
          items: <String>['All', 'US', 'India', 'Canada']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx){
          return Container(
            height: 200.0,
            child: Center(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.share_rounded),
                    title: Text('Share'),
                    onTap: (){},
                  ),
                  ListTile(
                    leading: Icon(Icons.link),
                    title: Text('Get Link'),
                    onTap: (){},
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite_outline, color: Colors.red),
                    title: Text('Add to Favorites'),
                    onTap: (){},
                  )
                ],
              )
            ),
          );
        }
    );
  }
}

class PhImageAsset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/placeholder_image.png');
    Image phimg = Image(image: assetImage);
    return Container(
      child: phimg,
    );
  }
}
