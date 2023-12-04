import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user.dart';

class DeliveredOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserModel? user = ModalRoute.of(context)!.settings.arguments as UserModel?;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivered Orders Reports',
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
                        (index) => DonationReportCard(data: donationReports[index]),
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
          .where('ngoId', isEqualTo: userId)
          .where("orderStatus", isEqualTo: 4)
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

  DonationReportCard({required this.data});

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
        subtitle: Text('Number of items: ${data['amount'].toStringAsFixed(0)} \nNgo: ${data['detailsMap']['ngo']},\nDonor: ${data['detailsMap']['donor']},\nDistributor: ${data['detailsMap']['distributor']}'),
      ),
    );
  }
}
