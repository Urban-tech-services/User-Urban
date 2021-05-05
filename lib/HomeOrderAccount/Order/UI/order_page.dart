import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/HomeOrderAccount/Home/UI/order_placed_map.dart';
import 'package:user/HomeOrderAccount/home_order_account.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurl/baseurl.dart';
import 'package:user/bean/orderbean.dart';
import 'package:user/bean/resturantbean/orderhistorybean.dart';
import 'package:user/parcel/ordermappageparcel.dart';
import 'package:user/parcel/pharmacybean/parcelorderhistorybean.dart';
import 'package:user/pharmacy/order_map_pharma.dart';
import 'package:user/restaturantui/pages/ordermaprestaurant.dart';

class OrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OrderPageState();
  }
}

class OrderPageState extends State<OrderPage> {
  List<OngoingOrders> onGoingOrders = [];
  List<OrderHistoryRestaurant> onRestGoingOrders = [];
  List<OrderHistoryRestaurant> onPharmaGoingOrders = [];
  List<TodayOrderParcel> onParcelGoingOrders = [];

  String elseText = 'No ongoing order ...';
  dynamic currency = '';

  var khit = 0;
  bool isFetch = false;
  int countFetch = 0;

  @override
  void initState() {
    super.initState();
    getAllThreeData();
  }

  getOnGointOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currency = preferences.getString('curency');
      List<OngoingOrders> onGoingOrderss = [];
      elseText = 'No ongoing order today...';
      onGoingOrders.clear();
      onGoingOrders = onGoingOrderss;
    });
    var userId = preferences.getInt('user_id');
    var url = onGoingOrdersUrl;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") || value.body.contains("{\"data\":[]}") || value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
          setState(() {
            onParcelGoingOrders.clear();
          });
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OngoingOrders> tagObjs = tagObjsJson
              .map((tagJson) => OngoingOrders.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onGoingOrders.clear();
              onGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getCanceledOreders() async {
    setState(() {
      List<OngoingOrders> onGoingOrderss = [];
      elseText = 'No canceled order till date...';
      onGoingOrders.clear();
      onGoingOrders = onGoingOrderss;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = cancelOrders;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") || value.body.contains("{\"data\":[]}") || value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
          setState(() {
            onParcelGoingOrders.clear();
          });
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OngoingOrders> tagObjs = tagObjsJson
              .map((tagJson) => OngoingOrders.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onGoingOrders.clear();
              onGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getCompletedOrders() async {
    setState(() {
      elseText = 'No completed order till date...';
      List<OngoingOrders> onGoingOrderss = [];
      onGoingOrders.clear();
      onGoingOrders = onGoingOrderss;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = completeOrders;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      if (value.statusCode == 200 && value.body != null) {
        print('${value.body}');
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") || value.body.contains("{\"data\":[]}") || value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
          setState(() {
            onParcelGoingOrders.clear();
          });
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OngoingOrders> tagObjs = tagObjsJson
              .map((tagJson) => OngoingOrders.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onGoingOrders.clear();
              onGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getOnRestGointOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currency = preferences.getString('curency');
      List<OrderHistoryRestaurant> onGoingOrderss = [];
      elseText = 'No ongoing order today...';
      onRestGoingOrders.clear();
      // onRestGoingOrders = onGoingOrderss;
    });
    var userId = preferences.getInt('user_id');
    var url = user_ongoing_order;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") || value.body.contains("{\"data\":[]}") || value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
          setState(() {
            onParcelGoingOrders.clear();
          });
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OrderHistoryRestaurant> tagObjs = tagObjsJson
              .map((tagJson) => OrderHistoryRestaurant.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onRestGoingOrders.clear();
              onRestGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getRestCanceledOreders() async {
    setState(() {
      List<OrderHistoryRestaurant> onGoingOrderss = [];
      elseText = 'No canceled order till date...';
      onRestGoingOrders.clear();
      onRestGoingOrders = onGoingOrderss;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = user_cancel_order_history;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") || value.body.contains("{\"data\":[]}") || value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
          setState(() {
            onParcelGoingOrders.clear();
          });
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OrderHistoryRestaurant> tagObjs = tagObjsJson
              .map((tagJson) => OrderHistoryRestaurant.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onRestGoingOrders.clear();
              onRestGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getRestCompletedOrders() async {
    setState(() {
      elseText = 'No completed order till date...';
      List<OrderHistoryRestaurant> onGoingOrderss = [];
      onRestGoingOrders.clear();
      onRestGoingOrders = onGoingOrderss;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = user_completed_orders;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      if (value.statusCode == 200 && value.body != null) {
        print('${value.body}');
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") || value.body.contains("{\"data\":[]}") || value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
          setState(() {
            onParcelGoingOrders.clear();
          });
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OrderHistoryRestaurant> tagObjs = tagObjsJson
              .map((tagJson) => OrderHistoryRestaurant.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onRestGoingOrders.clear();
              onRestGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getOnPharmaGointOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currency = preferences.getString('curency');
      List<OrderHistoryRestaurant> onGoingOrderss = [];
      elseText = 'No ongoing order today...';
      onPharmaGoingOrders.clear();
      // onPharmaGoingOrders = onGoingOrderss;
    });
    var userId = preferences.getInt('user_id');
    var url = pharmacy_user_ongoing_order;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") || value.body.contains("{\"data\":[]}") || value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
          setState(() {
            onParcelGoingOrders.clear();
          });
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OrderHistoryRestaurant> tagObjs = tagObjsJson
              .map((tagJson) => OrderHistoryRestaurant.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onPharmaGoingOrders.clear();
              onPharmaGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getPharmaCanceledOreders() async {
    setState(() {
      List<OrderHistoryRestaurant> onGoingOrderss = [];
      elseText = 'No canceled order till date...';
      onPharmaGoingOrders.clear();
      onPharmaGoingOrders = onGoingOrderss;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = pharmacy_user_cancel_order_history;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") || value.body.contains("{\"data\":[]}") || value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
          setState(() {
            onParcelGoingOrders.clear();
          });
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OrderHistoryRestaurant> tagObjs = tagObjsJson
              .map((tagJson) => OrderHistoryRestaurant.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onPharmaGoingOrders.clear();
              onPharmaGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getPharmaCompletedOrders() async {
    setState(() {
      elseText = 'No completed order till date...';
      List<OrderHistoryRestaurant> onGoingOrderss = [];
      onPharmaGoingOrders.clear();
      onPharmaGoingOrders = onGoingOrderss;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = pharmacy_user_completed_orders;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      if (value.statusCode == 200 && value.body != null) {
        print('${value.body}');
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") || value.body.contains("{\"data\":[]}") || value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
          setState(() {
            onParcelGoingOrders.clear();
          });
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OrderHistoryRestaurant> tagObjs = tagObjsJson
              .map((tagJson) => OrderHistoryRestaurant.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onPharmaGoingOrders.clear();
              onPharmaGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getOnParcelGointOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currency = preferences.getString('curency');
      List<TodayOrderParcel> onGoingOrderss = [];
      elseText = 'No ongoing order today...';
      onParcelGoingOrders.clear();
      // onParcelGoingOrders = onGoingOrderss;
    });
    var userId = preferences.getInt('user_id');
    var url = parcel_user_ongoing_order;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") || value.body.contains("{\"data\":[]}") || value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
          setState(() {
            onParcelGoingOrders.clear();
          });
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<TodayOrderParcel> tagObjs = tagObjsJson
              .map((tagJson) => TodayOrderParcel.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onParcelGoingOrders.clear();
              onParcelGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getParcelCanceledOreders() async {
    setState(() {
      List<TodayOrderParcel> onGoingOrderss = [];
      elseText = 'No canceled order till date...';
      onParcelGoingOrders.clear();
      // onParcelGoingOrders = onGoingOrderss;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = parcel_user_cancel_order;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") || value.body.contains("{\"data\":[]}") || value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
          setState(() {
            onParcelGoingOrders.clear();
          });
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<TodayOrderParcel> tagObjs = tagObjsJson
              .map((tagJson) => TodayOrderParcel.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onParcelGoingOrders.clear();
              onParcelGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getParcelCompletedOrders() async {
    setState(() {
      elseText = 'No completed order till date...';
      List<TodayOrderParcel> onGoingOrderss = [];
      onParcelGoingOrders.clear();
      // onParcelGoingOrders = onGoingOrderss;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = parcel_user_completed_order;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      if (value.statusCode == 200 && value.body != null) {
        print('${value.body}');
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") || value.body.contains("{\"data\":[]}") || value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
          setState(() {
            onParcelGoingOrders.clear();
          });
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<TodayOrderParcel> tagObjs = tagObjsJson
              .map((tagJson) => TodayOrderParcel.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onParcelGoingOrders.clear();
              onParcelGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  void getAllThreeData() {
    setState(() {
      isFetch = true;
      countFetch = 0;
    });
    getOnGointOrders();
    getOnRestGointOrders();
    getOnPharmaGointOrders();
    getOnParcelGointOrders();
  }

  void getCancelledHistory() async {
    setState(() {
      isFetch = true;
      countFetch = 0;
    });
    getCanceledOreders();
    getRestCanceledOreders();
    getPharmaCanceledOreders();
    getParcelCanceledOreders();
  }

  void getCompletedHistory() async {
    setState(() {
      isFetch = true;
      countFetch = 0;
    });
    getCompletedOrders();
    getParcelCompletedOrders();
    getPharmaCompletedOrders();
    getRestCompletedOrders();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      body: Container(
        color: kWhiteColor,
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Container(
              color: kWhiteColor,
              width: MediaQuery.of(context).size.width,
              height: 52,
              alignment: Alignment.center,
              child: Text('My Orders'),
            ),
            Container(
              color: kWhiteColor,
              width: MediaQuery.of(context).size.width,
              height: 40,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        khit = 0;
                      });
                      getAllThreeData();
                    },
                    child: Container(
                      width: width - 10,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: kMainColor),
                        color: (khit == 0) ? kMainColor : kWhiteColor,
                      ),
                      child: Text(
                        'OnGoing',
                        style: TextStyle(
                          color: (khit == 0) ? kWhiteColor : kMainTextColor,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        khit = 1;
                      });
                      getCancelledHistory();
                    },
                    child: Container(
                      width: width - 10,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: kMainColor),
                        color: (khit == 1) ? kMainColor : kWhiteColor,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: (khit == 1) ? kWhiteColor : kMainTextColor,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        khit = 2;
                      });
                      getCompletedHistory();
                    },
                    child: Container(
                      width: width - 10,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: kMainColor),
                        color: (khit == 2) ? kMainColor : kWhiteColor,
                      ),
                      child: Text(
                        'Completed',
                        style: TextStyle(
                          color: (khit == 2) ? kWhiteColor : kMainTextColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 200,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                primary: true,
                child: Column(
                  children: [
                    Visibility(
                        visible: ((onParcelGoingOrders != null &&
                                    onParcelGoingOrders.length > 0) ||
                                (onRestGoingOrders != null &&
                                    onRestGoingOrders.length > 0) ||
                                (onGoingOrders != null &&
                                    onGoingOrders.length > 0) ||
                                (onPharmaGoingOrders != null &&
                                    onPharmaGoingOrders.length > 0))
                            ? true
                            : false,
                        child: Column(
                          children: [
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   color: kCardBackgroundColor,
                            //   padding: EdgeInsets.only(
                            //       left: 15.0, bottom: 10.0, top: 10),
                            //   child: Text(
                            //     ' Orders',
                            //     style: TextStyle(
                            //         color: kMainTextColor, fontSize: 15.0),
                            //   ),
                            // ),
                            ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, t) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (onGoingOrders[t].order_status ==
                                          'Cancelled') {
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrderMapPage(
                                              pageTitle:
                                                  '${onGoingOrders[t].vendor_name}',
                                              ongoingOrders: onGoingOrders[t],
                                              currency: currency,
                                            ),
                                          ),
                                        ).then((value) {
                                          if (khit == 0) {
                                            getAllThreeData();
                                          } else if (khit == 1) {
                                            getCancelledHistory();
                                          } else if (khit == 2) {
                                            getCompletedHistory();
                                          }
                                        });
                                      }
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.3),
                                                child: Image.asset(
                                                  'images/maincategory/vegetables_fruitsact.png',
                                                  height: 42.3,
                                                  width: 33.7,
                                                ),
                                              ),
                                              Expanded(
                                                child: ListTile(
                                                  title: Text(
                                                    'Order Id - #${onGoingOrders[t].cart_id}',
                                                    style:
                                                        orderMapAppBarTextStyle
                                                            .copyWith(
                                                                letterSpacing:
                                                                    0.07),
                                                  ),
                                                  subtitle: Text(
                                                    (onGoingOrders[t]
                                                                    .delivery_date !=
                                                                null &&
                                                            onGoingOrders[t]
                                                                    .time_slot !=
                                                                null)
                                                        ? '${onGoingOrders[t].delivery_date} | ${onGoingOrders[t].time_slot}'
                                                        : '',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        .copyWith(
                                                            fontSize: 11.7,
                                                            letterSpacing: 0.06,
                                                            color: Color(
                                                                0xffc1c1c1)),
                                                  ),
                                                  trailing: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        '${onGoingOrders[t].order_status}',
                                                        style: orderMapAppBarTextStyle
                                                            .copyWith(
                                                                color:
                                                                    kMainColor),
                                                      ),
                                                      SizedBox(height: 7.0),
                                                      Text(
                                                        '${onGoingOrders[t].data.length} items | $currency ${onGoingOrders[t].price}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            .copyWith(
                                                                fontSize: 11.7,
                                                                letterSpacing:
                                                                    0.06,
                                                                color: Color(
                                                                    0xffc1c1c1)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(
                                            color: kCardBackgroundColor,
                                            thickness: 1.0,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 36.0,
                                                    bottom: 6.0,
                                                    top: 12.0,
                                                    right: 12.0),
                                                child: ImageIcon(
                                                  AssetImage(
                                                      'images/custom/ic_pickup_pointact.png'),
                                                  size: 13.3,
                                                  color: kMainColor,
                                                ),
                                              ),
//                              Text(
//                                'Grocery\t',
//                                style: orderMapAppBarTextStyle.copyWith(
//                                    fontSize: 10.0, letterSpacing: 0.05),
//                              ),
                                              Text(
                                                '${onGoingOrders[t].vendor_name}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                        fontSize: 10.0,
                                                        letterSpacing: 0.05),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 36.0,
                                                    bottom: 12.0,
                                                    top: 12.0,
                                                    right: 12.0),
                                                child: ImageIcon(
                                                  AssetImage(
                                                      'images/custom/ic_droppointact.png'),
                                                  size: 13.3,
                                                  color: kMainColor,
                                                ),
                                              ),
//                              Text(
//                                'Home\t',
//                                style: orderMapAppBarTextStyle.copyWith(
//                                    fontSize: 10.0, letterSpacing: 0.05),
//                              ),
                                              Expanded(
                                                child: Text(
                                                  '${onGoingOrders[t].address}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .copyWith(
                                                          fontSize: 10.0,
                                                          letterSpacing: 0.05),
                                                ),
                                              ),
                                            ],
                                          ),
                                          (onGoingOrders.length - 1 == t)
                                              ? Divider(
                                                  color: kCardBackgroundColor,
                                                  thickness: 0,
                                                )
                                              : Divider(
                                                  color: kCardBackgroundColor,
                                                  thickness: 13.3,
                                                ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                // separatorBuilder: (context, t2) {
                                //   return t2 == (onGoingOrders.length - 1) ? Container(
                                //     height: 20,
                                //     color: kWhiteColor,
                                //   ) : Container(
                                //     height: 10,
                                //     color: kWhiteColor,
                                //   );
                                // },
                                itemCount: onGoingOrders.length),
                            Visibility(
                              visible: (onRestGoingOrders != null &&
                                      onRestGoingOrders.length > 0)
                                  ? true
                                  : false,
                              child: Column(
                                children: [
                                  Divider(
                                    color: kCardBackgroundColor,
                                    thickness: 13.3,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder: (context, t) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (onRestGoingOrders[t]
                                                    .order_status ==
                                                'Cancelled') {
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderMapRestPage(
                                                    pageTitle:
                                                        '${onRestGoingOrders[t].vendor_name}',
                                                    ongoingOrders:
                                                        onRestGoingOrders[t],
                                                    currency: currency,
                                                  ),
                                                ),
                                              ).then((value) {
                                                if (khit == 0) {
                                                  getAllThreeData();
                                                } else if (khit == 1) {
                                                  getCancelledHistory();
                                                } else if (khit == 2) {
                                                  getCompletedHistory();
                                                }
                                              });
                                            }
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.3),
                                                      child: Image.asset(
                                                        'images/maincategory/vegetables_fruitsact.png',
                                                        height: 42.3,
                                                        width: 33.7,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ListTile(
                                                        title: Text(
                                                          'Order Id - #${onRestGoingOrders[t].cart_id}',
                                                          style: orderMapAppBarTextStyle
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      0.07),
                                                        ),
                                                        subtitle: Text(
                                                          // '${onCancelOrders[t]
                                                          //     .delivery_date} | ${onCancelOrders[t]
                                                          //     .time_slot}',
                                                          (onRestGoingOrders[t]
                                                                          .delivery_date !=
                                                                      null &&
                                                                  onRestGoingOrders[
                                                                              t]
                                                                          .time_slot !=
                                                                      null)
                                                              ? '${onRestGoingOrders[t].delivery_date} | ${onRestGoingOrders[t].time_slot}'
                                                              : '',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline6
                                                              .copyWith(
                                                                  fontSize:
                                                                      11.7,
                                                                  letterSpacing:
                                                                      0.06,
                                                                  color: Color(
                                                                      0xffc1c1c1)),
                                                        ),
                                                        trailing: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              '${onRestGoingOrders[t].order_status}',
                                                              style: orderMapAppBarTextStyle
                                                                  .copyWith(
                                                                      color:
                                                                          kMainColor),
                                                            ),
                                                            SizedBox(
                                                                height: 7.0),
                                                            Text(
                                                              '${onRestGoingOrders[t].data.length} items | $currency ${onRestGoingOrders[t].remaining_amount}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11.7,
                                                                      letterSpacing:
                                                                          0.06,
                                                                      color: Color(
                                                                          0xffc1c1c1)),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Divider(
                                                  color: kCardBackgroundColor,
                                                  thickness: 1.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 36.0,
                                                          bottom: 6.0,
                                                          top: 12.0,
                                                          right: 12.0),
                                                      child: ImageIcon(
                                                        AssetImage(
                                                            'images/custom/ic_pickup_pointact.png'),
                                                        size: 13.3,
                                                        color: kMainColor,
                                                      ),
                                                    ),
//                              Text(
//                                'Grocery\t',
//                                style: orderMapAppBarTextStyle.copyWith(
//                                    fontSize: 10.0, letterSpacing: 0.05),
//                              ),
                                                    Text(
                                                      '${onRestGoingOrders[t].vendor_name}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                                  0.05),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 36.0,
                                                          bottom: 12.0,
                                                          top: 12.0,
                                                          right: 12.0),
                                                      child: ImageIcon(
                                                        AssetImage(
                                                            'images/custom/ic_droppointact.png'),
                                                        size: 13.3,
                                                        color: kMainColor,
                                                      ),
                                                    ),
//                              Text(
//                                'Home\t',
//                                style: orderMapAppBarTextStyle.copyWith(
//                                    fontSize: 10.0, letterSpacing: 0.05),
//                              ),
                                                    Expanded(
                                                      child: Text(
                                                        '${onRestGoingOrders[t].address}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                                fontSize: 10.0,
                                                                letterSpacing:
                                                                    0.05),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                (onRestGoingOrders.length - 1 ==
                                                        t)
                                                    ? Divider(
                                                        color:
                                                            kCardBackgroundColor,
                                                        thickness: 0.0,
                                                      )
                                                    : Divider(
                                                        color:
                                                            kCardBackgroundColor,
                                                        thickness: 13.3,
                                                      ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      // separatorBuilder: (context, t2) {
                                      //   return t2 == (onCancelOrders.length) ? Container(
                                      //     height: 20,
                                      //     color: kWhiteColor,
                                      //   ) : Container(
                                      //     height: 10,
                                      //     color: kWhiteColor,
                                      //   );
                                      // },
                                      itemCount: onRestGoingOrders.length),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: (onPharmaGoingOrders != null &&
                                      onPharmaGoingOrders.length > 0)
                                  ? true
                                  : false,
                              child: Column(
                                children: [
                                  Divider(
                                    color: kCardBackgroundColor,
                                    thickness: 13.3,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder: (context, t) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (onPharmaGoingOrders[t]
                                                    .order_status ==
                                                'Cancelled') {
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderMapPharmaPage(
                                                    pageTitle:
                                                        '${onPharmaGoingOrders[t].vendor_name}',
                                                    ongoingOrders:
                                                        onPharmaGoingOrders[t],
                                                    currency: currency,
                                                  ),
                                                ),
                                              ).then((value) {
                                                if (khit == 0) {
                                                  getAllThreeData();
                                                } else if (khit == 1) {
                                                  getCancelledHistory();
                                                } else if (khit == 2) {
                                                  getCompletedHistory();
                                                }
                                              });
                                            }
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.3),
                                                      child: Image.asset(
                                                        'images/maincategory/vegetables_fruitsact.png',
                                                        height: 42.3,
                                                        width: 33.7,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ListTile(
                                                        title: Text(
                                                          'Order Id - #${onPharmaGoingOrders[t].cart_id}',
                                                          style: orderMapAppBarTextStyle
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      0.07),
                                                        ),
                                                        subtitle: Text(
                                                          // '${onCancelOrders[t]
                                                          //     .delivery_date} | ${onCancelOrders[t]
                                                          //     .time_slot}',
                                                          (onPharmaGoingOrders[
                                                                              t]
                                                                          .delivery_date !=
                                                                      null &&
                                                                  onPharmaGoingOrders[
                                                                              t]
                                                                          .time_slot !=
                                                                      null)
                                                              ? '${onPharmaGoingOrders[t].delivery_date} | ${onPharmaGoingOrders[t].time_slot}'
                                                              : '',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline6
                                                              .copyWith(
                                                                  fontSize:
                                                                      11.7,
                                                                  letterSpacing:
                                                                      0.06,
                                                                  color: Color(
                                                                      0xffc1c1c1)),
                                                        ),
                                                        trailing: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              '${onPharmaGoingOrders[t].order_status}',
                                                              style: orderMapAppBarTextStyle
                                                                  .copyWith(
                                                                      color:
                                                                          kMainColor),
                                                            ),
                                                            SizedBox(
                                                                height: 7.0),
                                                            Text(
                                                              '${onPharmaGoingOrders[t].data.length} items | $currency ${onPharmaGoingOrders[t].remaining_amount}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11.7,
                                                                      letterSpacing:
                                                                          0.06,
                                                                      color: Color(
                                                                          0xffc1c1c1)),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Divider(
                                                  color: kCardBackgroundColor,
                                                  thickness: 1.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 36.0,
                                                          bottom: 6.0,
                                                          top: 12.0,
                                                          right: 12.0),
                                                      child: ImageIcon(
                                                        AssetImage(
                                                            'images/custom/ic_pickup_pointact.png'),
                                                        size: 13.3,
                                                        color: kMainColor,
                                                      ),
                                                    ),
//                              Text(
//                                'Grocery\t',
//                                style: orderMapAppBarTextStyle.copyWith(
//                                    fontSize: 10.0, letterSpacing: 0.05),
//                              ),
                                                    Text(
                                                      '${onPharmaGoingOrders[t].vendor_name}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                                  0.05),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 36.0,
                                                          bottom: 12.0,
                                                          top: 12.0,
                                                          right: 12.0),
                                                      child: ImageIcon(
                                                        AssetImage(
                                                            'images/custom/ic_droppointact.png'),
                                                        size: 13.3,
                                                        color: kMainColor,
                                                      ),
                                                    ),
//                              Text(
//                                'Home\t',
//                                style: orderMapAppBarTextStyle.copyWith(
//                                    fontSize: 10.0, letterSpacing: 0.05),
//                              ),
                                                    Expanded(
                                                      child: Text(
                                                        '${onPharmaGoingOrders[t].address}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                                fontSize: 10.0,
                                                                letterSpacing:
                                                                    0.05),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                (onPharmaGoingOrders.length -
                                                            1 ==
                                                        t)
                                                    ? Divider(
                                                        color:
                                                            kCardBackgroundColor,
                                                        thickness: 0.0,
                                                      )
                                                    : Divider(
                                                        color:
                                                            kCardBackgroundColor,
                                                        thickness: 13.3,
                                                      ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      // separatorBuilder: (context, t2) {
                                      //   return t2 == (onCancelOrders.length) ? Container(
                                      //     height: 20,
                                      //     color: kWhiteColor,
                                      //   ) : Container(
                                      //     height: 10,
                                      //     color: kWhiteColor,
                                      //   );
                                      // },
                                      itemCount: onPharmaGoingOrders.length),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: (onParcelGoingOrders != null &&
                                      onParcelGoingOrders.length > 0)
                                  ? true
                                  : false,
                              child: Column(
                                children: [
                                  Divider(
                                    color: kCardBackgroundColor,
                                    thickness: 13.3,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder: (context, t) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (onParcelGoingOrders[t]
                                                    .order_status ==
                                                'Cancelled') {
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderMapParcelPage(
                                                    pageTitle:
                                                        '${onParcelGoingOrders[t].vendor_name}',
                                                    ongoingOrders:
                                                        onParcelGoingOrders[t],
                                                    currency: currency,
                                                  ),
                                                ),


                                              ).then((value) {
                                                if (khit == 0) {
                                                  getAllThreeData();
                                                } else if (khit == 1) {
                                                  getCancelledHistory();
                                                } else if (khit == 2) {
                                                  getCompletedHistory();
                                                }
                                              });
                                            }
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.3),
                                                      child: Image.asset(
                                                        'images/maincategory/vegetables_fruitsact.png',
                                                        height: 42.3,
                                                        width: 33.7,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ListTile(
                                                        title: Text(
                                                          'Order Id - #${onParcelGoingOrders[t].cart_id}',
                                                          style: orderMapAppBarTextStyle
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      0.07),
                                                        ),
                                                        subtitle: Text(
                                                          // '${onCancelOrders[t]
                                                          //     .delivery_date} | ${onCancelOrders[t]
                                                          //     .time_slot}',
                                                          (onParcelGoingOrders[
                                                                              t]
                                                                          .pickup_date !=
                                                                      null &&
                                                                  onParcelGoingOrders[
                                                                              t]
                                                                          .pickup_time !=
                                                                      null)
                                                              ? '${onParcelGoingOrders[t].pickup_date} | ${onParcelGoingOrders[t].pickup_time}'
                                                              : '',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline6
                                                              .copyWith(
                                                                  fontSize:
                                                                      11.7,
                                                                  letterSpacing:
                                                                      0.06,
                                                                  color: Color(
                                                                      0xffc1c1c1)),
                                                        ),
                                                        trailing: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              '${onParcelGoingOrders[t].order_status}',
                                                              style: orderMapAppBarTextStyle
                                                                  .copyWith(
                                                                      color:
                                                                          kMainColor),
                                                            ),
                                                            SizedBox(
                                                                height: 5.0),
                                                            Text(
                                                              '1 items | ${currency} ${(double.parse('${onParcelGoingOrders[t].distance}') > 1) ? double.parse('${onParcelGoingOrders[t].charges}') * double.parse('${onParcelGoingOrders[t].distance}') : double.parse('${onParcelGoingOrders[t].charges}')}\n\n',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11.7,
                                                                      letterSpacing:
                                                                          0.06,
                                                                      color: Color(
                                                                          0xffc1c1c1)),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Divider(
                                                  color: kCardBackgroundColor,
                                                  thickness: 1.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 36.0,
                                                          bottom: 6.0,
                                                          top: 12.0,
                                                          right: 12.0),
                                                      child: ImageIcon(
                                                        AssetImage(
                                                            'images/custom/ic_pickup_pointact.png'),
                                                        size: 13.3,
                                                        color: kMainColor,
                                                      ),
                                                    ),
//                              Text(
//                                'Grocery\t',
//                                style: orderMapAppBarTextStyle.copyWith(
//                                    fontSize: 10.0, letterSpacing: 0.05),
//                              ),
                                                    Text(
                                                      '${onParcelGoingOrders[t].vendor_name}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                                  0.05),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 36.0,
                                                          bottom: 12.0,
                                                          top: 12.0,
                                                          right: 12.0),
                                                      child: ImageIcon(
                                                        AssetImage(
                                                            'images/custom/ic_droppointact.png'),
                                                        size: 13.3,
                                                        color: kMainColor,
                                                      ),
                                                    ),
//                              Text(
//                                'Home\t',
//                                style: orderMapAppBarTextStyle.copyWith(
//                                    fontSize: 10.0, letterSpacing: 0.05),
//                              ),
                                                    Expanded(
                                                      child: Text(
                                                        '${onParcelGoingOrders[t].vendor_loc}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                                fontSize: 10.0,
                                                                letterSpacing:
                                                                    0.05),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                (onParcelGoingOrders.length -
                                                            1 ==
                                                        t)
                                                    ? Divider(
                                                        color:
                                                            kCardBackgroundColor,
                                                        thickness: 0.0,
                                                      )
                                                    : Divider(
                                                        color:
                                                            kCardBackgroundColor,
                                                        thickness: 13.3,
                                                      ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      // separatorBuilder: (context, t2) {
                                      //   return t2 == (onCancelOrders.length) ? Container(
                                      //     height: 20,
                                      //     color: kWhiteColor,
                                      //   ) : Container(
                                      //     height: 10,
                                      //     color: kWhiteColor,
                                      //   );
                                      // },
                                      itemCount: onParcelGoingOrders.length),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Visibility(
                      visible: ((onRestGoingOrders != null &&
                              onRestGoingOrders.length == 0) &&
                              (onGoingOrders != null &&
                              onGoingOrders.length == 0) &&
                              (onPharmaGoingOrders != null &&
                              onPharmaGoingOrders.length == 0) &&
                              (onParcelGoingOrders != null &&
                              onParcelGoingOrders.length == 0))
                          ? true
                          : false,
                      child: (!isFetch)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'No Order found',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 25,
                                    color: kMainTextColor,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.0,
                                        top: 10.0,
                                        bottom: 50,
                                        right: 20.0),
                                    child: Text(
                                      'Looks like you have not made your order yet.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18,
                                        color: kHintColor,
                                      ),
                                    )),
                                RaisedButton(
                                  onPressed: () {
                                    // clearCart();
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) {
                                      return HomeOrderAccount();
                                    }), (Route<dynamic> route) => false);
                                  },
                                  child: Text(
                                    'Shop Now',
                                    style: TextStyle(
                                        color: kWhiteColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  color: kMainColor,
                                  highlightColor: kMainColor,
                                  focusColor: kMainColor,
                                  splashColor: kMainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                )
                              ],
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  isFetch
                                      ? CircularProgressIndicator()
                                      : Container(
                                          width: 0.5,
                                        ),
                                  isFetch
                                      ? SizedBox(
                                          width: 10,
                                        )
                                      : Container(
                                          width: 0.5,
                                        ),
                                  Text(
                                    (!isFetch)
                                        ? 'No Store Found at your location'
                                        : 'Fetching orders',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: kMainTextColor),
                                  )
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
