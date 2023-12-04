import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/user.dart';
import '../../routes/app_routes.dart';

class DistributorDashboardScreen extends StatelessWidget {
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
    final UserModel? user =
    ModalRoute.of(context)!.settings.arguments as UserModel?;

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
                      title: Text('Welcome!'),
                      subtitle: Text('Explore available options'),
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
                      'Available Orders',
                      Icons.shopping_cart,
                      Colors.lightBlue.shade100!,
                          () {
                        // Navigate to available orders screen
                            Navigator.of(context).pushNamed(
                              AppRoutes.availableOrdersScreen,
                              arguments: user, // Pass the user object as an argument
                            );
                      },
                    ),
                    _buildDashboardCard(
                      context,
                      'Orders in Transit',
                      Icons.directions_bus,
                      Colors.lightGreen[100]!,
                          () {
                        // Navigate to orders in transit screen
                            Navigator.of(context).pushNamed(
                              AppRoutes.ordersInTransitScreen,
                              arguments: user, // Pass the user object as an argument
                            );
                      },
                    ),
                    _buildDashboardCard(
                      context,
                      'Orders Reports',
                      Icons.bar_chart,
                      Colors.orange[100]!,
                          () {
                        // Navigate to orders reports screen
                            Navigator.of(context).pushNamed(
                              AppRoutes.orderReportsScreen,
                              arguments: user, // Pass the user object as an argument
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
