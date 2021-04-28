import 'package:flutter/material.dart';
import 'package:newswizard/app_theme.dart';
import 'package:provider/provider.dart';
import 'screens/news_list.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
  }


  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
        create: (_) {
          return themeChangeProvider;
        },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: NewsList(),
          );
        },
      ),
    );
  }

}
