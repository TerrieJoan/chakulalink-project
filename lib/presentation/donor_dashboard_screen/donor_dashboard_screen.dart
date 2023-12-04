import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user.dart';
import '../../routes/app_routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, // Set primary color to green
        highlightColor: Colors.lightBlue, // Set secondary color to light blue
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DonorDashboardScreen(),
    );
  }
}

class DonorDashboardScreen extends StatelessWidget {
  Future<void> _showWishlistPopup(BuildContext context) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection("Wishlist").get();

      List<Widget> wishlistItems = [];

      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()!;
        String itemName = data['itemName'] ?? '';
        String itemDescription = data['itemDescription'] ?? '';

        wishlistItems.add(
          ListTile(
            title: Text(itemName),
            subtitle: Text(itemDescription),
          ),
        );
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('NGO Wishlist'),
            content: SingleChildScrollView(
              child: Column(
                children: wishlistItems,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error fetching wishlist: $e');
    }
  }

  Widget _buildDashboardCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      void Function()? onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.black45,
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = ModalRoute.of(context)!.settings.arguments as UserModel?;

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
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.health_and_safety),
                      title: Text('Welcome !'),
                      subtitle: Text('Get back to Donating'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  children: [
                    _buildDashboardCard(
                      context,
                      'View NGO Wishlist',
                      Icons.list,
                      Colors.lightBlue.shade100!,
                          () {
                        _showWishlistPopup(context);
                      },
                    ),
                    _buildDashboardCard(
                      context,
                      'Orders Sent from NGO',
                      Icons.send,
                      Colors.lightGreen[100]!,
                          () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.ordersToDonorScreen,
                          arguments: user,
                        );
                      },
                    ),
                    _buildDashboardCard(
                      context,
                      'Post Available Donations',
                      Icons.add_circle,
                      Colors.orange[100]!,
                          () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.donateOrderScreen,
                          arguments: user,
                        );
                      },
                    ),
                    _buildDashboardCard(
                      context,
                      'Report of Items Donated',
                      Icons.bar_chart,
                      Colors.red[100]!,
                          () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.donationReports,
                          arguments: user,
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
