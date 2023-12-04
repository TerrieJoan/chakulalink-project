import 'package:chakulalink/core/app_export.dart';
import 'package:chakulalink/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class LoginScreen extends StatelessWidget {
  TextEditingController username_field = TextEditingController();

  TextEditingController password_field = TextEditingController();

  bool isCheckbox = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, // Set background color
        resizeToAvoidBottomInset: false,
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.9, // Make the card 60% of the screen's width
            heightFactor: 0.5, // Make the card 60% of the screen's height
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 16), // Adjust padding as needed
                    color: Colors.white, // Set the background color
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 24, // Adjust the font size as needed
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Username",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade200,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomTextFormField(
                    focusNode: FocusNode(),
                    controller: username_field,
                    hintText: "Enter Your username",
                    margin: EdgeInsets.only(top: 8),
                    textInputType: TextInputType.name,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade200,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomTextFormField(
                    focusNode: FocusNode(),
                    controller: password_field,
                    hintText: "Enter Password",
                    margin: EdgeInsets.only(top: 8),
                    padding: TextFormFieldPadding.PaddingT12,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.visiblePassword,
                    suffix: Container(
                      margin: EdgeInsets.all(12),
                      child: CustomImageView(
                        svgPath: ImageConstant.imgEye,
                      ),
                    ),
                    suffixConstraints: BoxConstraints(maxHeight: getVerticalSize(44)),
                    isObscureText: true,
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green, // Set button color
                        padding: EdgeInsets.symmetric(vertical: 16), // Adjust padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Adjust border radius
                        ),
                      ),
                      onPressed: () {
                        loginProcess(context);
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    child: Text(
                        "Sign Up or contact admin at terry@gmail.com",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.green,
                        ),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginProcess(BuildContext context) async {
    String username = username_field.text;
    String password = password_field.text;

    try {
      // Check if the username exists
      QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore.instance
          .collection('Users')
          .where('userName', isEqualTo: username)
          .get();

      if (userQuery.docs.isNotEmpty) {
        // Username exists, now check if password matches
        String uid = userQuery.docs.first.id;
        String storedPassword = userQuery.docs.first.data()['password'];

        if (password == storedPassword) {
          UserModel userFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
            Map<String, dynamic> data = snapshot.data()!;
            return UserModel(
              id: snapshot.id,
              fullName: data['fullName'] ?? '',
              email: data['email'] ?? '',
              phoneNumber: data['phoneNumber'] ?? '',
              location: data['location'] ?? '',
              role: data['role'] ?? '',
              createdBy: data['createdBy'] ?? '',
              createdDate: data['createdDate'] ?? '',
            );
          }
          UserModel user = userFromSnapshot(userQuery.docs.first);
          int roleId = userQuery.docs.first.data()['role'];
          switch (roleId) {
            case 1: // Admin
              Navigator.popAndPushNamed(context, AppRoutes.adminDashboardScreen);
              break;
            case 2: // NGO
              //Navigator.popAndPushNamed(context, AppRoutes.ngoDashboardScreen);
              Navigator.of(context).pushNamed(
                AppRoutes.ngoDashboardScreen,
                arguments: user, // Pass the user object as an argument
              );
              break;
            case 3: // Donor
              //Navigator.popAndPushNamed(context, AppRoutes.donorDashboardScreen);
              Navigator.of(context).pushNamed(
                AppRoutes.donorDashboardScreen,
                arguments: user, // Pass the user object as an argument
              );
              break;
            case 4: // Distributor
              //Navigator.popAndPushNamed(context, AppRoutes.distributorDashboardScreen);
              Navigator.of(context).pushNamed(
                AppRoutes.distributorDashboardScreen,
                arguments: user, // Pass the user object as an argument
              );
              break;
            default:
            // Handle invalid roleId
              break;
          }
        } else {
          // Invalid password
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Invalid Credentials'),
                content: Text('Invalid password. Please try again.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Username does not exist
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Credentials'),
              content: Text('Invalid username. Please try again.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Something went wrong. Please check your connection and try again!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
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
