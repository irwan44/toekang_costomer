import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:flutter/material.dart';

editBoxWidget(
    BuildContext context,
    TextEditingController edtController,
    Function validationFunction,
    String label,
    String errorLabel,
    TextInputType inputType,
    {Widget? tailIcon,
    bool? isEditable = true}) {
  return Widgets.textFieldWidget(
      edtController, validationFunction, label, inputType, errorLabel, context,
      floatingLbl: false,
      borderRadius: 8,
      iseditable: isEditable ?? true,
      hint: label,
      ticon: tailIcon ?? SizedBox.shrink(),
      bgcolor: Theme.of(context).scaffoldBackgroundColor,
      contentPadding: EdgeInsets.symmetric(
          vertical: Constant.paddingOrMargin18,
          horizontal: Constant.paddingOrMargin8));
}
