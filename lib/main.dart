import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> fetchPost(http.Client client) async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/1/comments');

return compute(parsePosts, response.body);
}
List<Post> parsePosts(String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Post>((json) =>Post.fromJson(json)).toList();
}
class Post {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Post({this.postId, this.id, this.name, this.email, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['postId'],
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'serialization';
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
        );
  }
}
class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchPost(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PostList(post: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PostList extends StatelessWidget {
  final List<Post> post;
final _biggerFont = const TextStyle(fontSize: 18.0);
  PostList({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: 2,
      // ),
      itemCount: post.length,
      itemBuilder: (context, index) {
        return  Text(post[index].email,
        style: _biggerFont
        );
      },
    );
  }
}