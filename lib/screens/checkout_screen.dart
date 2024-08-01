import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/shared/constants.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';
import 'package:speedy_delivery/widget/address_selection.dart';
import 'package:speedy_delivery/widget/apply_coupon_widget.dart';
import 'package:speedy_delivery/widget/bill_details_widget.dart';
import 'package:speedy_delivery/widget/display_cartItems.dart';
import '../providers/order_provider.dart';
import '../services/push_notification.dart';
import '../widget/network_handler.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:speedy_delivery/screens/order_tracking.dart';
import '../providers/address_provider.dart';
import '../providers/auth_provider.dart';
import 'package:speedy_delivery/shared/show_msg.dart';
import 'dart:convert';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:http/http.dart' as http;
import '../screens/address_input.dart';
import '../screens/order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  IconData _paymentIcon = Icons.account_balance;

  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    customerId = _generateCustomerId();
    cfPaymentGatewayService.setCallback(verifyPayment, (errorResponse, orderId) => onError(errorResponse, orderId, context, orderProvider));
  }

  //Payment Gateway Code
  double totalAmt = 0.0;
  String customerId = '';
  String customerPhone = "";

  var cfPaymentGatewayService = CFPaymentGatewayService();

  String generateOrderId() {
    int randomNumber = Random().nextInt(9000) + 1000;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'ORD_${timestamp}_$randomNumber';
  }

  String _generateCustomerId() {
    int randomNumber = Random().nextInt(9000) + 1000;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'CUST_${timestamp}_$randomNumber';
  }

  Future<Map<String, dynamic>> createSessionID(String myOrderId) async {
    var headers = {
      'Content-Type': 'application/json',
      // 'x-client-id': dotenv.env['TEST_CLIENT_ID']!,
      // 'x-client-secret': dotenv.env['TEST_SECRET']!,

      //Prod
      'x-client-id': dotenv.env['PROD_CLIENT_ID']!,
      'x-client-secret': dotenv.env['PROD_SECRET']!,
      'x-api-version': '2023-08-01',
    };
    // var request = http.Request('POST', Uri.parse('https://sandbox.cashfree.com/pg/orders')); // test
    var request = http.Request('POST', Uri.parse('https://api.cashfree.com/pg/orders')); // prod
    request.body = json.encode({
      "order_amount": totalAmt.toStringAsFixed(2),
      "order_id": myOrderId,
      "order_currency": "INR",
      "customer_details": {
        "customer_id": customerId,
        "customer_name": "",
        "customer_email": "",
        "customer_phone": customerPhone,
      },
      "order_meta": {"notify_url": "https://test.cashfree.com"},
      "order_note": ""
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      debugPrint(await response.stream.bytesToString());
      debugPrint("${response.reasonPhrase}");
      throw Exception("Failed to create session ID");
    }
  }

  Future<Map<String, dynamic>> verifyPaymentStatus(String orderId) async {
    var headers = {
      'Content-Type': 'application/json',
      //Test
      // 'x-client-id': dotenv.env['TEST_CLIENT_ID']!,
      // 'x-client-secret': dotenv.env['TEST_SECRET']!,

      //Prod
      'x-client-id': dotenv.env['PROD_CLIENT_ID']!,
      'x-client-secret': dotenv.env['PROD_SECRET']!,
      'x-api-version': '2023-08-01',
    };

    var request = http.Request('GET', Uri.parse('https://api.cashfree.com/pg/orders/$orderId')); // prod
    // var request = http.Request('GET', Uri.parse('https://sandbox.cashfree.com/pg/orders/$orderId')); // test

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      debugPrint(await response.stream.bytesToString());
      debugPrint("${response.reasonPhrase}");
      throw Exception("Failed to verify payment status");
    }
  }

  void verifyPayment(String oId) async {
    debugPrint("Verify Payment");
    debugPrint("Order ID = $oId");

    try {
      final paymentStatus = await verifyPaymentStatus(oId);
      if (paymentStatus['order_status'] == 'PAID') {
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        await orderProvider.acceptOrder(oId);

        final cartProvider = Provider.of<CartProvider>(context, listen: false);

        cartProvider.clearCart();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrderConfirmationPage()),
        );
        showMessage("Payment Successful");
      } else {
        final orderProvider = Provider.of<OrderProvider>(context);
        showMessage("Payment not successful. Please try again.");
        await orderProvider.cancelOrder(oId);
        return;
      }
    } catch (e) {
      debugPrint("Error verifying payment: $e");
      showMessage("Error verifying payment. Please try again.");
    }
  }

  void onError(CFErrorResponse errorResponse, String orderId, BuildContext context, OrderProvider orderProvider) async {
    debugPrint(errorResponse.getMessage().toString());
    debugPrint("Error while making payment");
    debugPrint("Order ID is $orderId");

    try {
      final paymentStatus = await verifyPaymentStatus(orderId);
      if (paymentStatus['order_status'] == 'PAID') {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        cartProvider.clearCart();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrderConfirmationPage()),
        );
        showMessage("Payment Successful");
      } else {
        await orderProvider.cancelOrder(orderId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderTrackingScreen(orderId: orderId),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error verifying payment: $e");
      await orderProvider.cancelOrder(orderId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderTrackingScreen(orderId: orderId),
        ),
      );
    }
  }

  Future<void> webCheckout(String myOrdId) async {
    try {
      CFSession? session = await createSession(myOrdId);
      var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session!).build();
      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<CFSession?> createSession(String myOrdId) async {
    try {
      final paymentSessionId = await createSessionID(myOrdId);
      var session = CFSessionBuilder().setEnvironment(CFEnvironment.PRODUCTION).setOrderId(myOrdId).setPaymentSessionId(paymentSessionId["payment_session_id"]).build();
      // var session = CFSessionBuilder().setEnvironment(CFEnvironment.SANDBOX).setOrderId(myOrdId).setPaymentSessionId(paymentSessionId["payment_session_id"]).build();

      return session;
    } on CFException catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  Future<void> pay(String myOrdId) async {
    try {
      var session = await createSession(myOrdId);
      if (session == null) {
        debugPrint("Session creation failed");
        return;
      }
      List<CFPaymentModes> components = <CFPaymentModes>[];
      var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();
      var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#000000").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();
      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(session).setPaymentComponent(paymentComponent).setTheme(theme).build();
      cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
    } on CFException catch (e) {
      debugPrint("Payment exception: ${e.message}");
    }
  }

  //Payment Gateway Code End

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    //Payment Gateway Code
    final authProvider = Provider.of<MyAuthProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    setState(() {
      totalAmt = cartProvider.calculateGrandTotal(cartProvider.selectedPaymentMethod);
      customerPhone = authProvider.phone.isEmpty ? "0000000000" : authProvider.phone;
    });

    //Payment Gateway Code End

    return NetworkHandler(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Checkout'),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: cartProvider.cart.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/empty.png"),
              const Text(
                "No item in cart",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        )
            : Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: const Color(0xffeaf1fc),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              const Icon(Icons.timer),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Delivery within $deliveryTime minutes',
                                      style: const TextStyle(fontSize: 18, fontFamily: 'Gilroy-ExtraBold'),
                                    ),
                                    const Text(
                                      'Shipment of 1 item',
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const DisplayCartItems(),
                      const SizedBox(height: 20),
                      const BillDetails(),
                      const SizedBox(height: 20),
                      const ApplyCouponWidget(),
                      const SizedBox(height: 20),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const AddressSelection(),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            _paymentIcon,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 10),
                                          DropdownButton<String>(
                                            value: orderProvider.selectedPaymentMethod,
                                            icon: const Icon(Icons.arrow_drop_down),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: const TextStyle(color: Colors.black),
                                            underline: Container(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                orderProvider.selectedPaymentMethod = newValue!;
                                                double total = cartProvider.calculateGrandTotal(newValue);
                                                if ((total - cartProvider.Discount) < 50) {
                                                  cartProvider.clearCoupon();
                                                }
                                                _paymentIcon = newValue == 'Online' ? Icons.account_balance : Icons.currency_rupee;
                                              });
                                            },
                                            items: <String>['Online', 'Cash on delivery'].map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      HapticFeedback.heavyImpact();

                                      // Generate order id
                                      final myOrderId = generateOrderId();

                                      if (cartProvider.cart.isEmpty) {
                                        showMessage("Cart is empty");
                                        return;
                                      }

                                      if (addressProvider.address.isEmpty && addressProvider.selectedAddress.isEmpty) {
                                        showMessage("Please select an address");
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => const AddressInputForm(),
                                          ),
                                        );
                                        return;
                                      }

                                      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

                                      if (orderProvider.selectedPaymentMethod == 'Cash on delivery') {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: const Color(0xfff7f7f7),
                                              title: const Text(
                                                'Confirmation',
                                                style: TextStyle(color: Color(0xff666666)),
                                              ),
                                              content: const Text('Are you sure you want to make this order as Cash? You can save more if you select payment method type as Online.', style: TextStyle(color: Color(0xff666666))),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Close the popup
                                                  },
                                                  child: const Text('Change Payment Method', style: TextStyle(color: Colors.black)),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    LocalNotificationService.sendOrderNotification(context, myOrderId, authProvider.phone, totalAmt, addressProvider.selectedAddress, orderProvider.selectedPaymentMethod);
                                                    Navigator.of(context).pop(); // Close the popup
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OrderConfirmationPage())).then((value) {
                                                      List<Order> orders = cartProvider.cart.map((item) {
                                                        return Order(
                                                          orderId: myOrderId,
                                                          paymentMode: orderProvider.selectedPaymentMethod,
                                                          productName: item.itemName,//- ${item.itemUnit}
                                                          productImage: item.itemImage,
                                                          quantity: item.qnt,
                                                          unit:  item.itemUnit,
                                                          price: item.itemPrice.toDouble(),
                                                          address: addressProvider.selectedAddress,
                                                          phone: authProvider.phone,
                                                          overallTotal: totalAmt,
                                                          timestamp: DateTime.timestamp(),
                                                          valetName: "",
                                                          valetPhone: "",
                                                        );
                                                      }).toList();

                                                      orderProvider.addOrders(orders, myOrderId, authProvider.phone);
                                                      cartProvider.clearCart();
                                                    });
                                                  },
                                                  child: const Text('Proceed with Cash', style: TextStyle(color: Colors.black)),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else if (orderProvider.selectedPaymentMethod == 'Online') {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: const Color(0xfff7f7f7),
                                              title: const Text(
                                                'Confirmation',
                                                style: TextStyle(color: Color(0xff666666)),
                                              ),
                                              content: const Text(
                                                'Are you sure you want to continue with online payment method?',
                                                style: TextStyle(color: Color(0xff666666)),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Close the popup
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    LocalNotificationService.sendOrderNotification(context, myOrderId, authProvider.phone, totalAmt, addressProvider.selectedAddress, orderProvider.selectedPaymentMethod);
                                                    Navigator.of(context).pop(); // Close the popup
                                                    pay(myOrderId).then((value) {
                                                      List<Order> orders = cartProvider.cart.map((item) {
                                                        return Order(
                                                          orderId: myOrderId,
                                                          paymentMode: orderProvider.selectedPaymentMethod,
                                                          productName: item.itemName,//- ${item.itemUnit}
                                                          productImage: item.itemImage,
                                                          quantity: item.qnt,
                                                          unit : item.itemUnit,
                                                          price: item.itemPrice.toDouble(),
                                                          address: addressProvider.selectedAddress,
                                                          phone: authProvider.phone,
                                                          overallTotal: totalAmt,
                                                          timestamp: DateTime.timestamp(),
                                                          valetName: "",
                                                          valetPhone: "",
                                                        );
                                                      }).toList();
                                                      orderProvider.addOrders(orders, myOrderId, authProvider.phone);
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Yes',
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }

                                    },
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14.0),
                                        ),
                                      ),
                                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                          return Colors.black;
                                        },
                                      ),
                                    ),
                                    child: const SizedBox(
                                      width: 120,
                                      height: 50.0,
                                      child: Center(
                                        child: Text(
                                          "Continue",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}