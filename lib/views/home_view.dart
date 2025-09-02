import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongodb_app/controllers/user_controller.dart';
import 'package:mongodb_app/models/user.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    UserController controller = Get.put(UserController());
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];

            return ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: SizedBox(
                width: 96,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // edit
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        print(user.id);
                        // current identity
                        controller.updateUser(
                          'id',
                          User(id: user.id, name: user.name, email: user.email),
                        );
                      },
                    ),

                    // delete
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        controller.deleteUser(user.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // create
          controller.addUser(
            User(id: '', name: 'David Kim', email: 'david.k@example.com'),
          );
        },
      ),
    );
  }
}
