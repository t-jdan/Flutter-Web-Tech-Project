import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ashesi_social_network/create_profile.dart';
import 'package:ashesi_social_network/edit_profile.dart';
import 'package:ashesi_social_network/view_profile.dart';
import 'package:ashesi_social_network/post.dart';
import 'package:ashesi_social_network/view_post.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: MaterialApp(
        title: 'Ashesi Social Network',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = RegisterPage();
        break;
      case 1:
        page = EditPage();
        break;
      case 2:
        page = ViewProfile();
        break;
      case 3:
        page = CreatePost();
        break;
      case 4:
        page = FeedPage();
        break;

      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: true,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text('Create Profile'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.edit),
                  label: Text('Edit Profile'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.remove_red_eye_rounded),
                  label: Text('View Profile'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.post_add),
                  label: Text('Make a post'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.find_in_page_outlined),
                  label: Text('View Posts'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
                ;
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}
