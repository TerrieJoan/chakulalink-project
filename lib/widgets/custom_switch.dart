import 'package:chakulalink/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CustomSwitch extends StatelessWidget {
  CustomSwitch({this.alignment, this.margin, this.value, this.onChanged});

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  bool? value;

  Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildSwitchWidget(),
          )
        : _buildSwitchWidget();
  }

  _buildSwitchWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: FlutterSwitch(
        value: value ?? false,
        height: getHorizontalSize(25),
        width: getHorizontalSize(45),
        toggleSize: 25,
        borderRadius: getHorizontalSize(
          12.00,
        ),
        activeColor: appTheme.blueA700,
        activeToggleColor: appTheme.gray50,
        inactiveColor: appTheme.blueA700,
        inactiveToggleColor: appTheme.gray50,
        onToggle: (value) {
          onChanged!(value);
        },
      ),
    );
  }
}
