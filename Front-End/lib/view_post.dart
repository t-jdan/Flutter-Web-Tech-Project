import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;
  int _currentPage = 1;
  String _lastItem = "";

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreItems();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    String url =
        'https://us-central1-rest-api-lab-5942e.cloudfunctions.net/post?timestamp=$_lastItem';

    final response = await http.get(Uri.parse(url));
    List<Map<String, dynamic>> nextPage = List<Map<String, dynamic>>.from(
        json.decode(response.body).map((x) => Map<String, dynamic>.from(x)));

    setState(() {
      _isLoading = false;
      _items.addAll(nextPage);
      _lastItem = _items.last['timestamp'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ashesi Posts'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _items.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListTile(
              title: Text(_items[index]['email'].toString()),
              subtitle: Text(_items[index]['post'].toString()),
            );
          }
        },
      ),
    );
  }
}
