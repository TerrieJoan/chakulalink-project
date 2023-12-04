import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/user.dart';

class DonateOrder extends StatefulWidget {
  @override
  _DonateOrderState createState() => _DonateOrderState();
}

class _DonateOrderState extends State<DonateOrder> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _pickUpController = TextEditingController();
  final _dropOffController = TextEditingController();
  final Set<Marker> _markers = {};

  String? _selectedDonorId;
  String? _selectedOrderCategoryId;

  List<Map<String, dynamic>> ngoList = [];
  List<Map<String, dynamic>> orderCategories = [];

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    getDonorList();
    getOrderCategories();
  }

  Future<void> getDonorList() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection("Users").where('role', isEqualTo: 2).get();

      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()!;
        String ngoName = data['fullName'] ?? '';
        String ngoId = doc.id; // Get the unique ID of the document
        setState(() {
          ngoList.add({'name': ngoName, 'id': ngoId});
        });
      });
    } catch (e) {
      print('Error fetching ngos: $e');
    }
  }

  Future<void> getOrderCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection("OrderCategory").get();

      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()!;
        String categoryName = data['categoryName'] ?? '';
        String categoryId = doc.id; // Get the unique ID of the document
        setState(() {
          orderCategories.add({'name': categoryName, 'id': categoryId});
        });
      });
    } catch (e) {
      print('Error fetching order categories: $e');
    }
  }

  Future<void> saveOrderData(BuildContext context, String userId) async {
    try {
      String formattedDate = DateTime.now().toString().replaceAll(" ","_").replaceAll(":","_").replaceAll(".","_").replaceAll("-","_").toString();
      String generatedID = "Order" + "-" + formattedDate;

      List<double> pickUpCoordinates = _pickUpController.text
          .split(', ')
          .map((coordinate) => double.parse(coordinate))
          .toList();

      await FirebaseFirestore.instance.collection('Orders').doc(generatedID).set({
        'orderName': generatedID,
        'donorId': userId,
        'distributorId': null,
        'ngoId': _selectedDonorId,
        'amount': _amountController.text,
        'pickUpLocation': _pickUpController.text,
        'dropOffLocation': _dropOffController.text,
        'orderStatus': 1,
        'orderCategoryId': _selectedOrderCategoryId,
        'createdBy': userId,
        'createdDate': DateTime.now().toString(),
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Order Posted'),
            content: Text('Order has been posted successfully.'),
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Could not create the order.'),
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
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _mapController = controller;
    });
  }

  void _onMapTap(LatLng position, String markerId) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(markerId),
        position: position,
        infoWindow: InfoWindow(title: markerId == 'pickup' ? 'Pickup Location' : 'Drop-off Location'),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(position));

    // Update the corresponding controller based on the markerId
    if (markerId == 'pickup') {
      _pickUpController.text = "${position.latitude}, ${position.longitude}";
    } else if (markerId == 'dropoff') {
      _dropOffController.text = "${position.latitude}, ${position.longitude}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = ModalRoute.of(context)!.settings.arguments as UserModel?;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donate order',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.green.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField(
                  value: _selectedDonorId,
                  items: ngoList.map((Map<String, dynamic> ngo) {
                    return DropdownMenuItem(
                      value: ngo['id'],
                      child: Text(ngo['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDonorId = value as String?;
                    });
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.control_point),
                    labelText: 'Ngo',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey.shade600,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  value: _selectedOrderCategoryId,
                  items: orderCategories.map((Map<String, dynamic> category) {
                    return DropdownMenuItem(
                      value: category['id'],
                      child: Text(category['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedOrderCategoryId = value as String?;
                    });
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.control_point),
                    labelText: 'Order Category',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey.shade600,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  cursorColor: Colors.blueGrey.shade100,
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(Icons.abc_outlined),
                    labelText: 'Amount',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey.shade600,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  cursorColor: Colors.blueGrey.shade100,
                  controller: _pickUpController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Icon(Icons.abc_outlined),
                    labelText: 'Pick Up Location',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey.shade600,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Container(
                  height: 300, // Adjust height as needed
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    onTap: (position) => _onMapTap(position, 'pickup'),
                    markers: _markers,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(1.2921, 36.8219),
                      zoom: 5,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  cursorColor: Colors.blueGrey.shade100,
                  controller: _dropOffController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Icon(Icons.abc_outlined),
                    labelText: 'Drop Off Location',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey.shade600,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Container(
                  height: 300, // Adjust height as needed
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    onTap: (position) => _onMapTap(position, 'dropoff'),
                    markers: _markers,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(1.2921, 36.8219),
                      zoom: 5,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => saveOrderData(context, user!.id), // Replace with actual ngoId
                  child: Text('Donate Order'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
