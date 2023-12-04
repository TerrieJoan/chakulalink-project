import 'dart:math';
import 'package:chakulalink/presentation/admin_dashboard_screen/admin_dashboard_screen.dart';
import 'package:chakulalink/presentation/ngo_dashboard_screen/ngo_dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/order_category.dart';
import '../../models/user.dart';
import '../../routes/app_routes.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        highlightColor: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DonationCategory(),
    );
  }
}

class DonationCategory extends StatelessWidget {

  Future<void> _openEditModal(BuildContext context, CategoryModel item, UserModel user) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _buildEditForm(item, context, user),
          ),
        );
      },
    );
  }

  void _openCreateModal(BuildContext context, UserModel user) {
    CategoryModel item = CategoryModel(
        id: '',
        categoryName: '',
        entityId: user.id,
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
            child: _buildCreateForm(item, context, user), // Pass the item model
          ),
        );
      },
    );
  }

  Widget _buildCreateForm(CategoryModel item, BuildContext context, UserModel user ) {

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: item.categoryName,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.control_point),
              labelText: 'Category Name',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              item.categoryName = value;
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
                  Navigator.of(context).pushNamed(
                    AppRoutes.donationCategories,
                    arguments: user, // Pass the user object as an argument
                  );
                },
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Handle form submission here
                  await saveData(context, item); // Assuming you have a function to save item data
                },
                child: Text('Submit'),
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(CategoryModel item, BuildContext context, UserModel user) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: item.categoryName,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.abc_outlined),
              labelText: 'Category Name',
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              item.categoryName = value;
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
                  Navigator.of(context).pushNamed(
                    AppRoutes.donationCategories,
                    arguments: user, // Pass the user object as an argument
                  );
                },
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Handle form submission here
                  await editData(context, item); // Assuming you have a function to save item data
                },
                child: Text('Submit'),
              ),

            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveData(BuildContext context, CategoryModel item) async {
    try {
      String formattedDate = DateTime.now().toString().replaceAll(" ","_").replaceAll(":","_").replaceAll(".","_").replaceAll("-","_").toString();
      String generatedID = item.categoryName.split(" ")[0] + "-" + formattedDate;
      item.id = generatedID;

      await FirebaseFirestore.instance.collection('OrderCategory').doc(item.id).set({
        'categoryName': item.categoryName,
        'entityId': item.entityId
      });

      // If save is successful, show a confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('The item has been created successfully.'),
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
            content: Text('Could not create the item.'),
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

  Future<void> editData(BuildContext context, CategoryModel item) async {
    try {
      DocumentReference itemDocRef = FirebaseFirestore.instance.collection('OrderCategory').doc(item.id);
      await itemDocRef.update({
        'categoryName': item.categoryName,
        'entityId': item.entityId
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('The item has been updated successfully.'),
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
            content: Text('Could not update the item.'),
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

  Future<List<CategoryModel>> getDataList(UserModel user) async {
    List<CategoryModel> items = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection("OrderCategory")
          .where('entityId', isEqualTo: user.id)
          .get();

      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()!;
        CategoryModel item = CategoryModel(
          id: doc.id,
          categoryName: data['categoryName'] ?? '',
          entityId: data['entityId'] ?? '',
        );

        items.add(item);
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = ModalRoute.of(context)!.settings.arguments as UserModel?;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create category',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.green.shade400,
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: getDataList(user!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<CategoryModel> items = snapshot.data ?? [];
          List<DataRow> dataRows = items.map((item) {
            return DataRow(
              cells: [
                DataCell(Text(item.categoryName)),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _openEditModal(context, item, user);
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
                          Navigator.of(context).pushNamed(
                            AppRoutes.ngoDashboardScreen,
                            arguments: user, // Pass the user object as an argument
                          );
                        },
                        label: Text('Back'),
                      ),
                      FloatingActionButton.extended(
                        onPressed: () {
                          _openCreateModal(context, user!);
                        },
                        label: Text('+ Add a item'),
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