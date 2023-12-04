import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/wishlist_model.dart';
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
      home: WishList(),
    );
  }
}

class WishList extends StatelessWidget {

  List<String> orderCategories = []; // Add this list to store category names
  Future<void> getOrderCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection("OrderCategory").get();

      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()!;
        String categoryName = data['categoryName'] ?? '';
        orderCategories.add(categoryName);
      });
    } catch (e) {
      print('Error fetching order categories: $e');
    }
  }

  Future<void> _openEditModal(BuildContext context, WishListModel item, UserModel user) async {
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
    WishListModel item = WishListModel(
        id: '',
        itemName: '',
        number: '',
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

  Widget _buildCreateForm(WishListModel item, BuildContext context, UserModel user) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.0),
          DropdownButtonFormField(
            value: item.itemName, // Set the initial value if available
            items: orderCategories.map((String category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              item.itemName = value.toString();
            },
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
          ),
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: item.number,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.abc_outlined),
              labelText: 'Category Number', // Update label as needed
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              item.number = value;
            },
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(
                    AppRoutes.wishListScreen,
                    arguments: user, // Pass the user object as an argument
                  );
                },
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await saveData(context, item);
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(WishListModel item, BuildContext context, UserModel user) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.0),
          DropdownButtonFormField(
            value: item.itemName, // Set the initial value if available
            items: orderCategories.map((String category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              item.itemName = value.toString();
            },
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
          ),
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Colors.blueGrey.shade100,
            initialValue: item.number,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.abc_outlined),
              labelText: 'Category Number', // Update label as needed
              labelStyle: TextStyle(
                color: Colors.blueGrey.shade600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
            onChanged: (value) {
              item.number = value;
            },
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(
                    AppRoutes.wishListScreen,
                    arguments: user, // Pass the user object as an argument
                  );
                },
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await editData(context, item);
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveData(BuildContext context, WishListModel item) async {
    try {
      String formattedDate = DateTime.now().toString().replaceAll(" ","_").replaceAll(":","_").replaceAll(".","_").replaceAll("-","_").toString();
      String generatedID = item.itemName.split(" ")[0] + "-" + formattedDate;
      item.id = generatedID;

      await FirebaseFirestore.instance.collection('Wishlist').doc(item.id).set({
        'itemName': item.itemName,
        'number': item.number
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

  Future<void> editData(BuildContext context, WishListModel item) async {
    try {
      DocumentReference itemDocRef = FirebaseFirestore.instance.collection('Wishlist').doc(item.id);
      await itemDocRef.update({
        'itemName': item.itemName,
        'number': item.number
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
                  Navigator.of(context).pop();
                  // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<WishListModel>> getDataList(UserModel user) async {
    List<WishListModel> items = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection("Wishlist")
          .get();

      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()!;
        WishListModel item = WishListModel(
          id: doc.id,
          itemName: data['itemName'] ?? '',
          number: data['number'] ?? '',
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
    getOrderCategories();
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
      body: FutureBuilder<List<WishListModel>>(
        future: getDataList(user!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<WishListModel> items = snapshot.data ?? [];
          List<DataRow> dataRows = items.map((item) {
            return DataRow(
              cells: [
                DataCell(Text(item.itemName)),
                DataCell(Text(item.number)),
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
                        DataColumn(label: Text('Amount')),
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