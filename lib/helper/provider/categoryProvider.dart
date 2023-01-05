import 'package:egrocer/helper/repositories/categoryApi.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/homeScreenData.dart';
import 'package:flutter/material.dart';

enum CategoryState {
  initial,
  loading,
  loaded,
  error,
}

class CategoryListProvider extends ChangeNotifier {
  CategoryState categoryState = CategoryState.initial;
  String message = '';
  List<Category> categories = [];
  Map<String, List<Category>> subCategoriesList = {};
  List<String> selectedCategoryIdsList = ["0"];
  List<String> selectedCategoryNamesList = [StringsRes.lblAll];
  String currentSelectedCategoryId = "0";

  getCategoryApiProvider({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    categoryState = CategoryState.loading;
    notifyListeners();
    try {
      categories = (await getCategoryList(context: context, params: params))
          .cast<Category>();

      categoryState = CategoryState.loaded;

      notifyListeners();
    } catch (e) {
      message = e.toString();
      categoryState = CategoryState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }

  setCategoryList(List<Category> categoriesList) {
    categories = categoriesList;
    notifyListeners();
  }

  setCategoryData(int index) {
    currentSelectedCategoryId = selectedCategoryIdsList[index];
    setCategoryList(subCategoriesList["$index"] as List<Category>);

    if (index == 0) {
      selectedCategoryIdsList.clear();
      selectedCategoryNamesList.clear();
      selectedCategoryIdsList = ["0"];
      selectedCategoryNamesList = [StringsRes.lblAll];
      currentSelectedCategoryId = "0";
    } else {
      selectedCategoryIdsList.removeRange(
          index, selectedCategoryIdsList.length - 1);
      selectedCategoryNamesList.removeRange(
          index, selectedCategoryNamesList.length - 1);
    }

    notifyListeners();
  }
}
