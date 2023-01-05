import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/checkoutProvider.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/timeSlots.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

getTimeSlots(TimeSlotsData timeSlotsData, BuildContext context) {
  return timeSlotsData.timeSlotsIsEnabled == "true"
      ? Card(
          color: Theme.of(context).cardColor,
          elevation: 0,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
                start: Constant.paddingOrMargin10,
                top: Constant.paddingOrMargin10,
                end: Constant.paddingOrMargin10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringsRes.lblPreferredDeliveryTime,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor)),
                Widgets.getSizedBox(height: 5),
                Divider(color: ColorsRes.grey, height: 1, thickness: 0.1),
                Widgets.getSizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        int.parse(timeSlotsData.timeSlotsAllowedDays), (index) {
                      late DateTime dateTime;
                      if (int.parse(timeSlotsData.timeSlotsDeliveryStartsFrom
                              .toString()) ==
                          1) {
                        dateTime = DateTime.now();
                      } else {
                        dateTime = DateTime.now().add(Duration(
                            days:
                                int.parse(timeSlotsData.timeSlotsAllowedDays)));
                      }
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<CheckoutProvider>()
                              .setSelectedDate(index);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          margin: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
                          decoration: BoxDecoration(
                              color: context
                                          .read<CheckoutProvider>()
                                          .selectedDate ==
                                      index
                                  ? Constant.session.getBoolData(
                                          SessionManager.isDarkTheme)
                                      ? ColorsRes.appColorBlack.withOpacity(0.2)
                                      : ColorsRes.appColorWhite.withOpacity(0.2)
                                  : Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(0.8),
                              borderRadius: Constant.borderRadius7,
                              border: Border.all(
                                width: context
                                            .read<CheckoutProvider>()
                                            .selectedDate ==
                                        index
                                    ? 1
                                    : 0.3,
                                color: context
                                            .read<CheckoutProvider>()
                                            .selectedDate ==
                                        index
                                    ? ColorsRes.appColor
                                    : ColorsRes.grey,
                              )),
                          child: Column(
                            children: [
                              Text(
                                StringsRes.lblWeekDaysNames[dateTime
                                        .add(Duration(days: index))
                                        .weekday -
                                    1],
                                style: TextStyle(
                                    color: context
                                                .read<CheckoutProvider>()
                                                .selectedDate ==
                                            index
                                        ? ColorsRes.mainTextColor
                                        : ColorsRes.grey),
                              ),
                              Text(
                                  dateTime
                                      .add(Duration(days: index))
                                      .day
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: context
                                                  .read<CheckoutProvider>()
                                                  .selectedDate ==
                                              index
                                          ? ColorsRes.mainTextColor
                                          : ColorsRes.grey)),
                              Text(
                                StringsRes.lblMonthsNames[
                                    dateTime.add(Duration(days: index)).month -
                                        1],
                                style: TextStyle(
                                    color: context
                                                .read<CheckoutProvider>()
                                                .selectedDate ==
                                            index
                                        ? ColorsRes.mainTextColor
                                        : ColorsRes.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Widgets.getSizedBox(height: 5),
                Column(
                  children:
                      List.generate(timeSlotsData.timeSlots.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        context.read<CheckoutProvider>().setSelectedTime(index);
                      },
                      child: Container(
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                            color: Constant.session
                                    .getBoolData(SessionManager.isDarkTheme)
                                ? ColorsRes.appColorBlack.withOpacity(0.2)
                                : ColorsRes.appColorWhite.withOpacity(0.2),
                            border: BorderDirectional(
                                bottom: BorderSide(
                              width: 1,
                              color: timeSlotsData.timeSlots.length == index + 1
                                  ? Colors.transparent
                                  : ColorsRes.grey.withOpacity(0.1),
                            ))),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: Constant.paddingOrMargin10),
                              child: Text(timeSlotsData.timeSlots[index].title),
                            ),
                            Spacer(),
                            Radio(
                              value:
                                  context.read<CheckoutProvider>().selectedTime,
                              groupValue: index,
                              onChanged: (value) {
                                context
                                    .read<CheckoutProvider>()
                                    .setSelectedTime(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        )
      : SizedBox.shrink();
}
