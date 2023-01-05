import 'package:egrocer/helper/repositories/faqApi.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/models/faq.dart';
import 'package:flutter/material.dart';

enum FaqState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class FaqProvider extends ChangeNotifier {
  FaqState itemsState = FaqState.initial;
  String message = '';
  List<FAQ> faqs = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getFaqProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      itemsState = FaqState.loading;
    } else {
      itemsState = FaqState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getFaqApi(context: context, params: params));

      if (getData[ApiAndParams.status] == 1) {
        totalData = getData[ApiAndParams.total];
        List<FAQ> tempFaqs = (getData['data'] as List)
            .map((e) => FAQ.fromJson(Map.from(e)))
            .toList();

        faqs.addAll(tempFaqs);
      }

      hasMoreData = totalData > faqs.length;
      if (hasMoreData) {
        offset += Constant.defaultDataLoadLimitAtOnce;
      }

      itemsState = FaqState.loaded;
      notifyListeners();
    } catch (e) {
      message = e.toString();
      itemsState = FaqState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }
}
