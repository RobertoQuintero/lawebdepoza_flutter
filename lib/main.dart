import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

import 'package:lawebdepoza_mobile/screens/screens.dart';
import 'package:lawebdepoza_mobile/services/services.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductsService()),
        ChangeNotifierProvider(create: (_) => PlacesService()),
        ChangeNotifierProvider(create: (_) => CategoryService()),
        ChangeNotifierProvider(create: (_) => UsersService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lugares App',
      initialRoute: 'checking',
      routes: {
        'login': (_) => LoginScreen(),
        'register': (_) => RegisterScreen(),
        'home': (_) => HomeScreen(),
        'product': (_) => ProductScreen(),
        'checking': (_) => CheckAuthScreen(),
        'place': (_) => PlaceScreen(),
        'add-category': (_) => AddCategoryScreen(),
        'categories': (_) => CategoriesScreen(),
        'add-place': (_) => AddPlaceScreen(),
        'users': (_) => UsersScreen()
      },
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: ThemeData.light().copyWith(
          primaryColor: Colors.indigo,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
              brightness: Brightness.dark,
              elevation: 0,
              color: Colors.indigo,
              centerTitle: true),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo, elevation: 0)),
    );
  }
}
