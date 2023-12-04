import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/user.dart';

class AvailableOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserModel? user = ModalRoute.of(context)!.settings.arguments as UserModel?;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Available Orders',
          style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),
      backgroundColor: Colors.green.shade400,
    ),
    body: FutureBuilder(
    future: fetchDonationReports(user!.id),
    builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(
    child: CircularProgressIndicator(),
    );
    } else if (snapshot.hasError) {
    return Center(
    child: Text('Error: ${snapshot.error}'),
    );
    } else {
    List<Map<String, dynamic>> donationReports = snapshot.data ?? [];

    return SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: List.generate(
    donationReports.length,
    (index) => DonationReportCard(data: donationReports[index], user: user!)
    ),
    ),
    ),
    );
    }
    },
    ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchDonationReports(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where('orderStatus', isEqualTo: 2)
          .get();


      List<Map<String, dynamic>> donationReports = await Future.wait(snapshot.docs.map((doc) async {
        Map<String, dynamic> data = doc.data()!;
        Map<String, String> detailsMap = {};

        detailsMap['ngo'] = await getFullNameById(data['ngoId'] ?? '');
        detailsMap['donor'] = await getFullNameById(data['donorId'] ?? '');
        detailsMap['distributor'] = await getFullNameById(data['distributorId'] ?? '');

        return {
          'id': data['id'] ?? '',
          'orderName': data['orderName'] ?? '',
          'donorId': data['donorId'] ?? '',
          'distributorId': data['distributorId'] ?? '',
          'ngoId': data['ngoId'] ?? '',
          'detailsMap': detailsMap,
          'amount': int.tryParse(data['amount'].toString()) ?? 0,
          'orderStatus': int.tryParse(data['orderStatus'].toString()) ?? 0,
          'orderCategoryId': int.tryParse(data['orderCategoryId'].toString()) ?? 0,
          'orderCategoryId': int.tryParse(data['orderCategoryId'].toString()) ?? 0,
          'pickUpLocation': int.tryParse(data['pickUpLocation'].toString()) ?? 0,
          'dropOffLocation': int.tryParse(data['dropOffLocation'].toString()) ?? 0,
          'createdBy': data['createdBy'] ?? '',
          'createdDate': data['createdDate'] ?? '',
          'updatedBy': data['updatedBy'] ?? '',
          'updatedDate': data['updatedDate'] ?? '',
          'password': data['password'] ?? '',
        };
      }));


      return donationReports;
    } catch (error) {
      throw error;
    }
  }

  Future<String> getFullNameById(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot.data()!['fullName'];
      } else {
        return 'User not found';
      }
    } catch (error) {
      print('Error fetching user full name: $error');
      return 'Error fetching user full name';
    }
  }
}
class DonationReportCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final UserModel user;

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  DonationReportCard({required this.data, UserModel? user})
      : user = user ?? UserModel(id: '', fullName: '', email: '', phoneNumber: '', location: '', role: 0, createdBy: '', createdDate: '');

  void _showRouteOnMap(String pickUpLocation, String dropOffLocation) {
    List<LatLng> routeCoordinates = [
      LatLng(double.parse(pickUpLocation.split(', ')[0]), double.parse(pickUpLocation.split(', ')[1])),
      LatLng(double.parse(dropOffLocation.split(', ')[0]), double.parse(dropOffLocation.split(', ')[1])),
    ];

    // Add markers for pick-up and drop-off locations
    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId('pickUp'),
      position: routeCoordinates[0],
      infoWindow: InfoWindow(title: 'Pick-Up Location'),
    ));
    _markers.add(Marker(
      markerId: MarkerId('dropOff'),
      position: routeCoordinates[1],
      infoWindow: InfoWindow(title: 'Drop-Off Location'),
    ));

    // Add a Polyline to show the route on the map
    // _mapController?.addPolyline(Polyline(
    //   polylineId: PolylineId('route'),
    //   points: routeCoordinates,
    //   color: Colors.blue,
    //   width: 3,
    // ));

    // Optionally, zoom and move the camera to show the entire route
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(southwest: routeCoordinates[0], northeast: routeCoordinates[1]),
      50, // Padding value
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        leading: Icon(
          Icons.check_circle,
          color: Colors.lightGreenAccent.shade700,
        ),
        title: Text(data['orderName']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Number of items: ${data['amount'].toStringAsFixed(0)} \nNgo: ${data['detailsMap']['ngo']},\nDonor: ${data['detailsMap']['donor']}'),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () => _showConfirmationDialog(context, data['orderName'], user.id),
              child: Text('Accept Order'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () => _showRouteOnMap(data['pickUpLocation'], data['dropOffLocation']),
              child: Text('Show Route'),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 200,
              child: GoogleMap(
                onMapCreated: (controller) => _mapController = controller,
                markers: _markers,
                initialCameraPosition: CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String orderId, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Acceptance'),
          content: Text('Are you sure you want to complete this order?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update orderStatus and close the dialog
                _updateOrderStatus(context, orderId, userId);
              },
              child: Text('Complete'),
            ),
          ],
        );
      },
    );
  }

  void _updateOrderStatus(BuildContext context, String orderId, String userId) async {
    try {
      // Update order status and distributorId in Firestore
      await FirebaseFirestore.instance.collection('Orders').doc(orderId).update({
        'orderStatus': 3,
        'distributorId': userId,
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Order accepted successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the success dialog
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error updating order status: $error');
      // Handle the error and show an error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to accept order. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the error dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
