import 'dart:math';
import 'package:chakulalink/presentation/admin_dashboard_screen/admin_dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/admin.dart';
import '../../models/user.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  late Admin admin;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        highlightColor: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserManagement(admin),
    );
  }
}

class UserManagement extends StatelessWidget {
  final Admin admin;
  UserManagement(this.admin);

  Future<void> _openEditUserModal(BuildContext context, UserModel user) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _buildEditForm(user, context),
          ),
        );
      },
    );
  }

  void _openCreateUserModal(BuildContext context) {
    UserModel user = UserModel(
        id: '',
        fullName: '',
        email: '',
        phoneNumber: '',
        location: '',
        role: 0,
        createdBy: '',
        createdDate: DateTime.now().toString()
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _buildUserForm(user, context), // Pass the user model
          ),
        );
      },
    );
  }

  Widget _buildUserForm(UserModel user, BuildContext context) {
    int userid = admin.id;
    int sectionId = admin.sectionId;

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: user.fullName,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.person_2_rounded),
              labelText: 'Full Name',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              user.fullName = value;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: user.userName,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.abc_outlined),
              labelText: 'User Name',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              user.userName = value;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: user.password,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.password),
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              user.password = value;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: user.email,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.email_outlined),
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              user.email = value;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: user.phoneNumber,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.phone),
              labelText: 'Phone Number',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              user.phoneNumber = value;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: user.location,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.location_on),
              labelText: 'Location',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              user.location = value;
            },
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust this as needed
            children: [
              ElevatedButton(
                onPressed: () {
                  // Close the modal
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        Admin admin = Admin(
                            id: userid,
                            sectionId: sectionId
                        );
                        return UserManagement(admin);
                      },
                    ),
                  );
                },
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Handle form submission here
                  await saveUserData(context, user); // Assuming you have a function to save user data
                },
                child: Text('Submit'),
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(UserModel user, BuildContext context) {
    int userid = admin.id;
    int sectionId = admin.sectionId;
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: user.fullName,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.person_2_rounded),
              labelText: 'Full Name',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              user.fullName = value;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: user.userName,
            maxLength: 20,
            decoration: InputDecoration(
                icon: Icon(Icons.abc_outlined),
              labelText: 'User Name',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              user.userName = value;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: user.password,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.password),
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              user.password = value;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: user.email,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.email_outlined),
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              user.email = value;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: user.phoneNumber,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.phone),
              labelText: 'Phone Number',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              user.phoneNumber = value;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: user.location,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.location_on),
              labelText: 'Location',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              user.location = value;
            },
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust this as needed
            children: [
              ElevatedButton(
                onPressed: () {
                  // Close the modal
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        Admin admin = Admin(
                            id: userid,
                            sectionId: sectionId
                        );
                        return UserManagement(admin);
                      },
                    ),
                  );
                },
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Handle form submission here
                  await editUserData(context, user); // Assuming you have a function to save user data
                },
                child: Text('Submit'),
              ),

            ],
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle(int sectionId) {
    switch (sectionId) {
      case 1:
        return 'NGOs';
      case 2:
        return 'Distributors';
      case 3:
        return 'Donors';
      default:
        return 'Users';
    }
  }

  Future<void> saveUserData(BuildContext context, UserModel user) async {
    try {
      String formattedDate = DateTime.now().toString().replaceAll(" ","_").replaceAll(":","_").replaceAll(".","_").replaceAll("-","_").toString();
      String generatedID = user.fullName.split(" ")[0] + "-" + formattedDate;
      user.id = generatedID;
      user.role = admin.sectionId;
      //user.password = '1234';
      user.createdBy = admin.id.toString();

      await FirebaseFirestore.instance.collection('Users').doc(user.id).set({
        'fullName': user.fullName,
        'userName': user.userName,
        'password': user.password,
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'location': user.location,
        'role': user.role,
        'createdBy': user.createdBy,
        'createdDate': user.createdDate,
      });

      // If save is successful, show a confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('User Created'),
            content: Text('User has been created successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );

    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Could not create the user.'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> editUserData(BuildContext context, UserModel user) async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(user.id);
      await userDocRef.update({
        'fullName': user.fullName,
        'userName': user.userName,
        'email': user.email,
        'password': user.password,
        'phoneNumber': user.phoneNumber,
        'location': user.location,
        'role': user.role,
        'updatedBy': admin.id,
        'updatedDate': DateTime.now(),
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('User Updated'),
            content: Text('User has been updated successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Could not update the user.'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<UserModel>> getUsers() async {
    List<UserModel> users = [];
    int roleId = admin.sectionId;
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('Users')
          .where('role', isEqualTo: roleId)
          .get();

      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()!;
        UserModel user = UserModel(
          id: doc.id,
          fullName: data['fullName'] ?? '',
          email: data['email'] ?? '',
          password: data['password'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          location: data['location'] ?? '',
          role: data['role'] ?? '',
          createdBy: data['createdBy'] ?? '',
          createdDate: data['createdDate'] ?? '',
          userName: data['userName'] ?? '',
        );

        users.add(user);
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(admin.sectionId),
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade100,
      ),
      body: FutureBuilder<List<UserModel>>(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<UserModel> users = snapshot.data ?? [];
          List<DataRow> dataRows = users.map((user) {
            return DataRow(
              cells: [
                DataCell(Text(user.fullName)),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _openEditUserModal(context, user);
                      },
                    ),
                  ],
                )),
              ],
            );
          }).toList();
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 9,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: dataRows,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          // Navigate back to the dashboard
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminDashboardScreen(), // Replace with your dashboard widget
                            ),
                          );
                        },
                        label: Text('Back'),
                      ),
                      FloatingActionButton.extended(
                        onPressed: () {
                          _openCreateUserModal(context);
                        },
                        label: Text('+ Add a user'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}


