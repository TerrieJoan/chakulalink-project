import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user.dart';
import '../../routes/app_routes.dart';

class OrdersToDonorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        final UserModel? user = ModalRoute.of(context)!.settings.arguments as UserModel?;
        if (user == null) {
          return Center(child: Text('User data not available.'));
        }
        return _buildOrdersList(user, context);
      },
    );
  }

  Widget _buildOrdersList(UserModel user, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Requested orders',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black45,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade200,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('donorId', isEqualTo: user.id)
            .where('orderStatus', isEqualTo: 1) // Add this condition
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No orders found for this donor.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              String orderId = document.id;

              return Card(
                color: Colors.grey[200],
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(data['orderName']),
                  subtitle: Text('Amount: ${data['amount']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          await updateOrderStatus(context, orderId, 2); // Accept
                          _reloadPage(context, user);
                        },
                        style: OutlinedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        child: Text('Accept'),
                      ),
                      SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () async {
                          await updateOrderStatus(context, orderId, 3); // Reject
                          _reloadPage(context, user);
                        },
                        style: OutlinedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        child: Text('Reject'),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> updateOrderStatus(BuildContext context, String orderId, int newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(orderId)
          .update({'orderStatus': newStatus});

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Order Updated'),
            content: Text('Order status updated successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  void _reloadPage(BuildContext context, UserModel user) {
    Navigator.of(context).popAndPushNamed(
      AppRoutes.ordersToDonorScreen,
      arguments: user,
    );
  }
}
