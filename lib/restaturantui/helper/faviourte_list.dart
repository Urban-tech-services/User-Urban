import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurl/baseurl.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/bean/nearstorebean.dart';
import 'package:user/restaturantui/pages/restaurant.dart';
import 'package:toast/toast.dart';

class FavouriteRestaurantsList extends StatefulWidget {
  dynamic currencySymbol;
  final VoidCallback onVerificationDone;
  List<NearStores> nearStores;
  List<NearStores> nearStoresSearch;
  FavouriteRestaurantsList(this.currencySymbol,this.nearStores,this.nearStoresSearch,this.onVerificationDone);

  @override
  _FavouriteRestaurantsListState createState() =>
      _FavouriteRestaurantsListState();
}

class _FavouriteRestaurantsListState extends State<FavouriteRestaurantsList> {

  bool isFetchStore = false;
  List<NearStores> nearStores = [];
  List<NearStores> nearStoresSearch = [];
  bool isCartCount = false;

  @override
  void initState() {
    nearStores = widget.nearStores;
    nearStoresSearch = widget.nearStoresSearch;
    getCartCount();
    // hitService();
    super.initState();
  }
  void getCartCount() async{
    DatabaseHelper db = DatabaseHelper.instance;
    db.queryRowCountRest().then((value) {
      setState(() {
        if (value != null && value > 0) {
          // cartCount = value;
          isCartCount = true;
        } else {
          // cartCount = 0;
          isCartCount = false;
        }
      });
    });
  }

  void hitService() async {
    setState(() {
      isFetchStore = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('data - ${prefs.getString('lat')} - ${prefs.getString('lng')} - ${prefs.getString('vendor_cat_id')} - ${prefs.getString('ui_type')}');
    var url = nearByStore;
    http.post(url, body: {
      'lat': '${prefs.getString('lat')}',
      'lng': '${prefs.getString('lng')}',
      'vendor_category_id': '${prefs.getString('vendor_cat_id')}',
      'ui_type': '${prefs.getString('ui_type')}'
    }).then((value) {
      print('${value.statusCode} ${value.body}');
      if (value.statusCode == 200) {
        print('Response Body: - ${value.body}');
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(value.body)['data'] as List;
          List<NearStores> tagObjs = tagObjsJson
              .map((tagJson) => NearStores.fromJson(tagJson))
              .toList();
          setState(() {
            isFetchStore = false;
            nearStores.clear();
            nearStoresSearch.clear();
            nearStores = tagObjs;
            nearStoresSearch = List.from(nearStores);
          });
        } else {
          setState(() {
            isFetchStore = false;
          });
        }
      } else {
        setState(() {
          isFetchStore = false;
        });
      }
    }).catchError((e) {
      setState(() {
        isFetchStore = false;
      });
      print(e);
      Timer(Duration(seconds: 5), () {
        hitService();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Visibility(
      visible: (!isFetchStore && nearStores.length == 0) ? false : true,
      child: Container(
        width: width,
        height: 170.0,
        child: (nearStores != null && nearStores.length > 0)
            ? ListView.builder(
                itemCount: nearStores.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = nearStores[index];
                  return InkWell(
                    onTap: () async{

                      if((item.online_status == "on" || item.online_status == "On" || item.online_status == "ON")){
                        hitNavigator(context, item);
                      }else{
                        Toast.show('Restaurant are closed now!', context,
                            duration: Toast.LENGTH_SHORT);
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 130.0,
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          margin: (index != (nearStores.length - 1))
                              ? EdgeInsets.only(left: fixPadding)
                              : EdgeInsets.only(
                              left: fixPadding, right: fixPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  height: 110.0,
                                  width: 130.0,
                                  alignment: Alignment.topRight,
                                  padding: EdgeInsets.all(fixPadding),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(5.0)),
                                  ),
                                  child: Image.network(
                                    imageBaseUrl + item.vendor_logo,
                                    fit: BoxFit.fill,
                                  )
                              ),
                              Container(
                                width: 130.0,
                                height: 50.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        '${item.vendor_name}',
                                        style: listItemTitleStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsets.only(left: 5.0, right: 5.0),
                                      child: Text(
                                        '${double.parse('${nearStores[index].distance}').toStringAsFixed(2)} km',
                                        style: listItemSubTitleStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 50,
                          height: 40,
                          width: 150,
                          child: Visibility(
                            visible: (nearStores[index].online_status == "off" || nearStores[index].online_status == "Off" || nearStores[index].online_status == "OFF")?true:false,
                            child: Container(
                              alignment: Alignment.center,
                              color: kCardBackgroundColor,
                              child: Text('Store Closed Now',style: TextStyle(
                                  color: red_color,
                                fontSize: 13
                              ),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // final item = productList[index];
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      width: 130.0,
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      margin:
                          EdgeInsets.only(left: fixPadding, right: fixPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 110.0,
                            width: 130.0,
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.all(fixPadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(5.0)),
                              // image: DecorationImage(
                              //   image: AssetImage(item['image']),
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                            child: Shimmer(
                              duration: Duration(seconds: 3),
                              color: Colors.white,
                              enabled: true,
                              direction: ShimmerDirection.fromLTRB(),
                              child: Container(
                                width: 130.0,
                                height: 110.0,
                                color: kTransparentColor,
                              ),
                            ),
                          ),
                          Container(
                            width: 130.0,
                            height: 50.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Shimmer(
                                    duration: Duration(seconds: 3),
                                    color: Colors.white,
                                    enabled: true,
                                    direction: ShimmerDirection.fromLTRB(),
                                    child: Container(
                                      width: 90.0,
                                      height: 10.0,
                                      color: kTransparentColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: Shimmer(
                                    duration: Duration(seconds: 3),
                                    color: Colors.white,
                                    enabled: true,
                                    direction: ShimmerDirection.fromLTRB(),
                                    child: Container(
                                      width: 90.0,
                                      height: 10.0,
                                      color: kTransparentColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  hitNavigator(BuildContext context, NearStores item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('${prefs.getString("res_vendor_id")}');
    print('${item.vendor_id}');
    if (isCartCount && prefs.getString("res_vendor_id") != null &&
        prefs.getString("res_vendor_id") != "" &&
        prefs.getString("res_vendor_id") != '${item.vendor_id}') {
      showAlertDialog(context, item, widget.currencySymbol);
    } else {
      prefs.setString("res_vendor_id", '${item.vendor_id}');
      prefs.setString("store_resturant_name", '${item.vendor_name}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Restaurant_Sub(item, widget.currencySymbol))).then((value){
        widget.onVerificationDone();
      });
    }
  }

  showAlertDialog(BuildContext context, NearStores item, currencySymbol) {
    // set up the buttons
    // Widget no = FlatButton(
    //   padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
    //   child: Text("OK"),
    //   onPressed: () {
    //     Navigator.of(context, rootNavigator: true).pop('dialog');
    //   },
    // );

    Widget clear = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        deleteAllRestProduct(context, item, currencySymbol);
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          padding: EdgeInsets.only(left:20, right:20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: red_color,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text(
            'Clear', style: TextStyle(fontSize: 13, color: kWhiteColor),),
        ),
      ),
    );

    Widget no = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: kGreenColor,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text(
            'No', style: TextStyle(fontSize: 13, color: kWhiteColor),),
        ),
      ),
    );

    // Widget yes = FlatButton(
    //   padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
    //   child: Text("OK"),
    //   onPressed: () {
    //     Navigator.of(context, rootNavigator: true).pop('dialog');
    //   },
    // );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Inconvenience Notice"),
      content: Text(
          "Order from different store in single order is not allowed. Sorry for inconvenience"),
      actions: [
        clear,
        no
      ],
    );


    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void deleteAllRestProduct(BuildContext context, NearStores item,
      currencySymbol) async {
    DatabaseHelper database = DatabaseHelper.instance;
    database.deleteAllRestProdcut();
    database.deleteAllAddOns();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("res_vendor_id", '${item.vendor_id}');
    prefs.setString("store_resturant_name", '${item.vendor_name}');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Restaurant_Sub(item, currencySymbol))).then((value){
      widget.onVerificationDone();
    });
  }

  // hitNavigator(BuildContext context, NearStores item, currencySymbol) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("res_vendor_id", '${item.vendor_id}');
  //   prefs.setString("store_resturant_name", '${item.vendor_name}');
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => Restaurant_Sub(item,currencySymbol))).then((value){
  //     widget.onVerificationDone();
  //   });
  // }
}
