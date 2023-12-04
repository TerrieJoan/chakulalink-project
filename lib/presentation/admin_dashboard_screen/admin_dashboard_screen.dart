import 'package:chakulalink/models/admin.dart';
import 'package:chakulalink/presentation/user_management/user_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AdminDashboardScreen(),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  int userId = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Chakula Link',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.green.shade200,
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // Close the app
                SystemNavigator.pop();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Make children take up the whole width
              children: [
                Card(
                  elevation: 5,
                  color: Colors.greenAccent.shade100, // Adjust the color as needed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    height: 200,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite, // Heart icon for goodwill
                              size: 30,
                              color: Colors.redAccent.shade200, // Adjust the color as needed
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Chakula Link',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'We believe in the power of giving back to the community.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    _buildMenuCard(
                      context,
                      'NGOs',
                      Icons.group,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              Admin admin = Admin(
                                  id: userId,
                                  sectionId: 2
                              );
                              return UserManagement(admin);
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    _buildMenuCard(
                      context,
                      'Distributors',
                      Icons.store,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              Admin admin = Admin(
                                  id: userId,
                                  sectionId: 3
                              );
                              return UserManagement(admin);
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    _buildMenuCard(
                      context,
                      'Donors',
                      Icons.favorite,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              Admin admin = Admin(
                                  id: userId,
                                  sectionId: 4
                              );
                              return UserManagement(admin);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }


  Widget _buildMenuCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Occupy full width
        child: Card(
          elevation: 5,
          color: Colors.white, // Very light green background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  size: 60,
                  color: Colors.blueGrey.shade300 // Light green for icon
                ),
                SizedBox(width: 16), // Add margin between icon and text
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black26
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    }
  }

