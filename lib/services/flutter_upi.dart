// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:upi_india/upi_india.dart';
//
// import '../providers/cart_provider.dart';
//
// class UPIPayment extends StatefulWidget {
//   const UPIPayment({super.key});
//
//   @override
//   State<UPIPayment> createState() => _UPIPaymentState();
// }
//
// class _UPIPaymentState extends State<UPIPayment> {
//   double totalAmt = 0;
//
//   Future<UpiResponse>? _transaction;
//   final UpiIndia _upiIndia = UpiIndia();
//   List<UpiApp>? apps;
//
//   TextStyle header = const TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.bold,
//   );
//
//   TextStyle value = const TextStyle(
//     fontWeight: FontWeight.w400,
//     fontSize: 14,
//   );
//
//   @override
//   void initState() {
//     _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
//       setState(() {
//         apps = value;
//       });
//     }).catchError((e) {
//       apps = [];
//     });
//     super.initState();
//   }
//
//   Future<UpiResponse> initiateTransaction(UpiApp app) async {
//     return _upiIndia.startTransaction(
//         app: app,
//         // merchantId: "kaif.shariff1234-1@okhdfcbank",
//         // receiverUpiId: "kaif.shariff1234-1@okhdfcbank",
//         merchantId: "BCR2DN4TWX4MLVTZ",
//         receiverUpiId: "9326500602@okbizaxis",
//         receiverName: 'Kodeinnovate',
//         transactionRefId: 'TestingUpiIndiaPlugin',
//         transactionNote: 'Example Transaction',
//         // amount: totalAmt,
//         amount: 1,
//         // flexibleAmount: true,
//         currency: 'INR');
//   }
//
//   Widget displayUpiApps() {
//     if (apps == null) {
//       return const Center(
//           child: CircularProgressIndicator(
//         color: Colors.black,
//       ));
//     } else if (apps!.isEmpty) {
//       return Center(
//         child: Text(
//           "No apps found to handle transaction.",
//           style: header,
//         ),
//       );
//     } else {
//       return Align(
//         alignment: Alignment.topCenter,
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Wrap(
//             children: apps!.map<Widget>((UpiApp app) {
//               return GestureDetector(
//                 onTap: () {
//                   _transaction = initiateTransaction(app);
//                   setState(() {});
//                 },
//                 child: SizedBox(
//                   height: 100,
//                   width: 100,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Image.memory(
//                         app.icon,
//                         height: 60,
//                         width: 60,
//                       ),
//                       Text(app.name),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       );
//     }
//   }
//
//   String _upiErrorHandler(error) {
//     switch (error) {
//       case UpiIndiaAppNotInstalledException _:
//         return 'Requested app not installed on device';
//       case UpiIndiaUserCancelledException _:
//         return 'You cancelled the transaction';
//       case UpiIndiaNullResponseException _:
//         return 'Requested app didn\'t return any response';
//       case UpiIndiaInvalidParametersException _:
//         return 'Requested app cannot handle the transaction';
//       default:
//         return 'An Unknown error has occurred';
//     }
//   }
//
//   void _checkTxnStatus(String status) {
//     switch (status) {
//       case UpiPaymentStatus.SUCCESS:
//         log('Transaction Successful');
//         break;
//       case UpiPaymentStatus.SUBMITTED:
//         log('Transaction Submitted');
//         break;
//       case UpiPaymentStatus.FAILURE:
//         log('Transaction Failed');
//         break;
//       default:
//         log('Received an Unknown transaction status');
//     }
//   }
//
//   Widget displayTransactionData(title, body) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text("$title: ", style: header),
//           Flexible(
//               child: Text(
//             body,
//             style: value,
//           )),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);
//
//     setState(() {
//       totalAmt = cartProvider.calculateGrandTotal();
//     });
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('UPI'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: displayUpiApps(),
//           ),
//           Expanded(
//             child: FutureBuilder(
//               future: _transaction,
//               builder:
//                   (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text(
//                         _upiErrorHandler(snapshot.error.runtimeType),
//                         style: header,
//                       ), // log's text message on screen
//                     );
//                   }
//
//                   // If we have data then definitely we will have UpiResponse.
//                   // It cannot be null
//                   UpiResponse _upiResponse = snapshot.data!;
//
//                   // Data in UpiResponse can be null. Check before loging
//                   String txnId = _upiResponse.transactionId ?? 'N/A';
//                   String resCode = _upiResponse.responseCode ?? 'N/A';
//                   String txnRef = _upiResponse.transactionRefId ?? 'N/A';
//                   String status = _upiResponse.status ?? 'N/A';
//                   String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
//                   _checkTxnStatus(status);
//
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         displayTransactionData('Transaction Id', txnId),
//                         displayTransactionData('Response Code', resCode),
//                         displayTransactionData('Reference Id', txnRef),
//                         displayTransactionData('Status', status.toUpperCase()),
//                         displayTransactionData('Approval No', approvalRef),
//                       ],
//                     ),
//                   );
//                 } else {
//                   return const Center(
//                     child: Text(''),
//                   );
//                 }
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
