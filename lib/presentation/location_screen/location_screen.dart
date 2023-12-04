import 'package:chakulalink/core/app_export.dart';
import 'package:chakulalink/widgets/app_bar/appbar_image.dart';
import 'package:chakulalink/widgets/app_bar/appbar_title.dart';
import 'package:chakulalink/widgets/app_bar/custom_app_bar.dart';
import 'package:chakulalink/widgets/custom_button.dart';
import 'package:chakulalink/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class LocationScreen extends StatelessWidget {
  TextEditingController inputFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: appTheme.gray50,
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
                height: getVerticalSize(49),
                leadingWidth: 40,
                leading: AppbarImage(
                    height: getSize(24),
                    width: getSize(24),
                    svgPath: ImageConstant.imgArrowleft,
                    margin: getMargin(left: 16, top: 12, bottom: 13),
                    onTap: () {
                      onTapArrowleft2(context);
                    }),
                centerTitle: true,
                title: AppbarTitle(text: "Location")),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 16, top: 24, right: 16, bottom: 24),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: getVerticalSize(643),
                          width: getHorizontalSize(396),
                          child:
                              Stack(alignment: Alignment.topCenter, children: [
                            CustomImageView(
                                imagePath: ImageConstant.imgRectangle458706x396,
                                height: getVerticalSize(643),
                                width: getHorizontalSize(396),
                                radius: BorderRadius.circular(
                                    getHorizontalSize(10)),
                                alignment: Alignment.center),
                            CustomTextFormField(
                                width: getHorizontalSize(364),
                                focusNode: FocusNode(),
                                controller: inputFieldController,
                                hintText:
                                    "2992 Terry Lane, Titusville, Florida",
                                margin: getMargin(top: 25),
                                textInputAction: TextInputAction.done,
                                alignment: Alignment.topCenter)
                          ])),
                      CustomButton(
                          height: getVerticalSize(50),
                          text: "Reset map",
                          margin: getMargin(top: 35, bottom: 5))
                    ]))));
  }

  onTapArrowleft2(BuildContext context) {
    Navigator.pop(context);
  }
}
