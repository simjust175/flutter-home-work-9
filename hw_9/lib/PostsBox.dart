import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostsBox extends StatefulWidget {
  PostsBox({super.key});

  @override
  State<PostsBox> createState() => _PostsState();
}

class Post {
  int userId;
  String title;
  String body;
  Post({required this.userId, required this.title, required this.body});
}

class _PostsState extends State<PostsBox> {
  List<Post> _posts = [];

  Future<void> fetchPosts() async {
    var url = "https://jsonplaceholder.typicode.com/posts";
    var parseUrl = Uri.parse(url);

    var res = await http.get(parseUrl);
    if (res.statusCode == 200) {
      List<dynamic> fetchedPosts = jsonDecode(res.body);
      //print(fetchedPosts);
      setState(() {
        _posts = fetchedPosts
            .map((postItem) => Post(
                  userId: postItem["userId"],
                  title: postItem["title"],
                  body: postItem["body"],
                ))
            .toList();
        //print(_posts);
      });
    } else {
      throw Exception("Sorry! its going slowllly");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 2,
              crossAxisSpacing: 10,
              children: _posts.map((post) => PostCard(post: post)).toList()),
    );
  }
}

class PostCard extends StatelessWidget {
  dynamic post;
  PostCard({super.key, this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 230, 230, 230),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(post.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                )),
            Text(post.body,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                )),
               
          ],
        ));
  }
}
