import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/models/models.dart';
import 'package:lawebdepoza_mobile/screens/loading_screen.dart';
import 'package:lawebdepoza_mobile/services/services.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usersService = Provider.of<UsersService>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Usuarios'),
          ),
          body: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: usersService.users.length,
              itemBuilder: (BuildContext context, int index) => Container(
                    child: _UserItem(usersService.users[index]),
                  )),
        ),
        if (usersService.isLoading) LoadingScreen()
      ],
    );
  }
}

class _UserItem extends StatelessWidget {
  final User user;
  const _UserItem(this.user);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.only(right: 15),
        color: Theme.of(context).primaryColor,
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
      key: UniqueKey(),
      child: Container(
        height: 100,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 0.5, color: Colors.black26))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: TextStyle(fontSize: 19),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  user.email,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                Switch.adaptive(
                    activeColor: Theme.of(context).primaryColor,
                    value: true,
                    onChanged: (value) {}),
                SizedBox(
                  width: 30,
                ),
                Icon(Icons.arrow_back_ios, color: Colors.black26)
              ],
            )
          ],
        ),
      ),
    );
  }
}
