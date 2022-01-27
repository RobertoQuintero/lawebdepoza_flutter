import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/helpers/show_dialog.dart';
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
          body: UsersScrollList(),
        ),
        if (usersService.isLoading) LoadingScreen()
      ],
    );
  }
}

class UsersScrollList extends StatefulWidget {
  @override
  _UsersScrollListState createState() => _UsersScrollListState();
}

class _UsersScrollListState extends State<UsersScrollList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent) {
        Provider.of<UsersService>(context, listen: false).getUsersByScrolling();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersService = Provider.of<UsersService>(context);
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          ListView.builder(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              itemCount: usersService.users.length,
              itemBuilder: (BuildContext context, int index) => Container(
                    child: _UserItem(usersService.users[index]),
                  )),
          if (usersService.isLoadingScroll)
            Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  color: Colors.white70,
                  height: 80,
                  width: size.width,
                  child: Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).primaryColor)),
                ))
        ],
      ),
    );
  }
}

class _UserItem extends StatelessWidget {
  final User user;
  const _UserItem(this.user);

  @override
  Widget build(BuildContext context) {
    final usersService = Provider.of<UsersService>(context);
    final bool isAdmin = usersService.isAdmin(user.role);
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (value) async {
        usersService.selectedUser = user;
        await showModal(
            context: context,
            widget: Text('¿Desea eliminar este usuario?'),
            callback: () async {
              Navigator.pop(context);
              final resp = await usersService.deleteUser();
              if (resp != null) {
                NotificationsService.showSnackbar(resp);
              }
            },
            title: 'Eliminar usuario');
        usersService.isLoading = false;
      },
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
        height: 150,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                    value: isAdmin,
                    onChanged: (value) async {
                      usersService.selectedUser = user;
                      final resp = await usersService.updateUser();
                      if (resp != null) {
                        NotificationsService.showSnackbar(resp);
                      }
                    }),
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
