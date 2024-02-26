import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsersCards extends StatefulWidget {
  UsersCards({super.key});
  @override
  State<UsersCards> createState() => _UsersState();
}

class Users {
  String firstName;
  String lastName;
  String image;
  String email;
  String username;
  String password;
  Map address;
  Users({
      required this.firstName,
      required this.lastName,
      required this.image,
      required this.email,
      required this.address,
      required this.username,
      required this.password
      });
}
// class Users {
//   String firstName;
//   String lastName;
//   String image;
//   String email;
//   String address;
//   String city;
//   String state;
//   Users({
//       required this.firstName,
//       required this.lastName,
//       required this.image,
//       required this.email,
//       required this.address,
//       required this.city,
//       required this.state
//       });
// }

class _UsersState extends State<UsersCards> {
  List<dynamic> _users = [];

  Future<void> fetchUsers() async {
    //var url = 'https://dummyjson.com/users';
    var url = '../lib/UsersApi.json';
    var parseUrl = Uri.parse(url);

    var res = await http.get(parseUrl);
    if (res.statusCode == 200) {
      dynamic fetchedUsers = jsonDecode(res.body);
      //print("👥👤 ${fetchedUsers["users"]}");

      setState(() {
        _users = fetchedUsers["users"]
            .map((user) => Users(
                firstName: user["firstName"],
                lastName: user["lastName"],
                email: user["email"],
                image: user["image"],
                address: user["address"],
                username: user["username"],
                password: user["password"]
                ))
            .toList();
      });
      print("_users");
    } else {
      throw Exception("keep waiting.. it will work out in the end.");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _users.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                children: _users
                    .map((user) => UserStateBox(user: user, infoState: false))
                    .toList(),
              ));
  }
}

Map<String, dynamic> iconMap = {
  "down": Icons.arrow_circle_down_rounded,
  "up": Icons.arrow_circle_up_rounded,
};

class UserStateBox extends StatefulWidget {
  dynamic user;
  bool infoState;
  UserStateBox({super.key, this.user, this.infoState = false});
  @override
  State<UserStateBox> createState() => _UserCard();
}

class _UserCard extends State<UserStateBox> {
  void _changeArrow() {
    setState(() {
      widget.infoState = !widget.infoState;
    });
  }

  @override
  void initState() {
    super.initState();
  }
  // UserCard({super.key, this.user, this.infoState });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(255, 221, 235, 241),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: !widget.infoState
                ? [
                    Text(
                      widget.user.firstName + " " + widget.user.lastName,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Email: ${widget.user.email}",
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontSize: 20,
                      ),
                    ),
                    Image.network(widget.user.image, height: 75),
                    IconButton(
                        onPressed: () => _changeArrow(),
                        icon: Icon(iconMap[widget.infoState ? "up" : "down"]))
                  ]
                : [
                    Text("Username: ${widget.user.username}"),
                    Text("Password: ${widget.user.password}"),
                    IconButton(
                        onPressed: () => _changeArrow(),
                        icon: Icon(iconMap[widget.infoState ? "up" : "down"]))
                  ]));
  }
}
