import 'dart:math';

import 'package:chakulalink/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      home: NGODashboardScreen(),
    );
  }
}

class NGODashboardScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final UserModel? user = ModalRoute.of(context)!.settings.arguments as UserModel?;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NGO Dashboard',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade400,
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 5.0, // Spacing between columns
          mainAxisSpacing: 5.0, // Spacing between rows
          children: [
            CardMenu(
              icon: Icons.category,
              label: 'Create Donation Categories',
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.donationCategories,
                  arguments: user, // Pass the user object as an argument
                );
              },
            ),
            CardMenu(
              icon: Icons.add_circle,
              label: 'Add Categories to Wishlist',
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.wishListScreen,
                  arguments: user,
                );
              },
            ),
            CardMenu(
              icon: Icons.arrow_circle_right_outlined,
              label: 'Request an Order to Donor',
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.requestOrderScreen,
                  arguments: user,
                );
              },
            ),
            CardMenu(
              icon: Icons.view_list,
              label: 'View Donated Items',
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.ngoReportsScreen,
                  arguments: user,
                );
              },
            ),
            CardMenu(
              icon: Icons.departure_board,
              label: 'View Items in Transit',
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.ngoOrdersInTransitScreen,
                  arguments: user,
                );
              },
            ),
            CardMenu(
              icon: Icons.check_circle_outline,
              label: 'View Delivered Items',
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.deliveredOrdersScreen,
                  arguments: user,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(String status) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Donation ${index + 1} - $status'),
          subtitle: Text('${index + 1 * 1} bags of maize '),
        );
      },
    );
  }
}

class CardMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  CardMenu({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.lightBlueAccent.shade700,
              ),
              SizedBox(height: 10),
              Center( // Ensure text is centered
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


