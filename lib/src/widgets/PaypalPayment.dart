import 'dart:core';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:login_app/src/providers/PaypalServices.dart';
import 'package:login_app/Api/Api.dart';
import 'dart:convert';
import 'package:login_app/src/extras/variables.dart' as globals;

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  

  PaypalPayment({this.onFinish, });

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic,dynamic> defaultCurrency = {"symbol": "MXN ", "decimalDigits": 2, "symbolBeforeTheNumber": true, "currency": "MXN"};

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';

  String cancelURL= 'cancel.example.com';


  @override
  void initState() {
    super.initState();
         List dataTempProducts = new List();
        List dataTempAddress = new List();
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();
            await Api.get_ShoppingCar().then((sucess) {
      dataTempProducts = jsonDecode(sucess);
    });
    
      await Api.direccion_get().then((sucess) {
      dataTempAddress = jsonDecode(sucess);
    });
        final transactions = getOrderParams(dataTempProducts,dataTempAddress);
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: '+e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  // item name, price and quantity

  Map<String, dynamic> getOrderParams(List data,List dataAddress) {

    print(data);
       print("ooooooooooooooooooooooo");
    print(dataAddress);
        String totalAmount = '0';
    String subTotalAmount = '0';
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = globals.name;
    String userLastName = globals.lastName;
    String addressCity = dataAddress[0]['city'];
    String addressStreet = dataAddress[0]['street'];
    String addressZipCode = dataAddress[0]['zip_code'];
    String addressCountry = dataAddress[0]['country'];
    String addressState = dataAddress[0]['state'];
    String addressPhoneNumber = '+52' + dataAddress[0]['phone_number'];

    List items = new List();
    int totalTemp = 0;
    data.forEach((element) {
      print(element['product']);
      items.add({
        "name": element['product']['name'],
        "quantity": element['quantity'],
        "price": element['product']['price'].toString(),
        "currency": defaultCurrency["currency"]
      });
      totalTemp = element['product']['price'] * element['quantity'] + totalTemp;
    });
    totalAmount = totalTemp.toString();
    subTotalAmount = totalTemp.toString();


    print(items);


    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount":
                  ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping &&
                isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName +
                    " " +
                    userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {
        "return_url": returnURL,
        "cancel_url": cancelURL
      }
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) {
                  widget.onFinish(id);
                  Navigator.of(context).pop();
                });
              } else {
                Navigator.of(context).pop();
              }
              Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}