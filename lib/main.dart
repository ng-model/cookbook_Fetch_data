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

List<Post> parsePosts(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
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
    final appTitle = 'Array of emails';
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
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
// final _biggerFont = const TextStyle(fontSize: 18.0);
  PostList({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: 2,
      // ),
      // https://stackoverflow.com/questions/47233209/flutter-group-listviews-with-separator
      itemCount: post.length,
      itemBuilder: (context, index) {
        // return  Text(post[index].email,
        // style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w100),
        // );
        return ListTile(
          title: Text(post[index].email,
              style: TextStyle(fontFamily: "Century Gothic")
              ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyOtherPage(post: post[index])));
          },
        );
        //     return Card(
        //       new GestureDetector(
        //         onTap: () {
        //           Navigator.pushNamed(context, "MyOtherPage");
        //         },
        //   child: new Column(
        //     children: <Widget>[
        //       new Column (children: <Widget>[
        //         new Container (child: new Text(post[index].email),
        //         // color: Colors.yellow[200],
        //         ),
        //         new Container(height: 29.0,),
        //         // new Text(post[index].email),
        //         //  new Divider(height: 15.0,color: Colors.red,)
        //         ],
        //       )
        //     ],
        //   ),
        //       )
        // );
      },
    );
  }
}

class MyOtherPage extends StatelessWidget {
  final Post post;
  MyOtherPage({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(post.email),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  post.email,
                  // textAlign: TextAlign.start
                ),
                Text(post.name),
                new Divider(height: 29.0),
                Text(
                  post.body,
                  // style:TextStyle(fontWeight:FontWeight.bold),
                )
                // new Divider(height: 29.0)
              ]),
        ));
  }
}
