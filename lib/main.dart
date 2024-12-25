import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _razorpay = Razorpay();

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, hendlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, hendlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, hendleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  var options = {
    'key': 'rzp_test_sg_8hneSyY2GZlvKw',
    'amount': 1, // Amount in smallest currency unit, e.g., paise for INR
    'currency': 'INR', // Specify the currency you want to use
    'name': 'Acme Corp.',
    'description': 'Fine T-Shirt',
    'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button for payment',
            ),
            ElevatedButton(
                onPressed: () {
                  try {
                    _razorpay.open(options);
                  } catch (e) {
                    log("Error is : ${e.toString()}");
                    Get.snackbar('success', e.toString(),
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green[300]);
                  }
                },
                child: const Text('Pay with  razorpay'))
          ],
        ),
      ),
    );
  }

  hendlePaymentSuccess(PaymentSuccessResponse response) {
    log('Success: $response');
    Get.snackbar('success', 'Payment Success',
        snackPosition: SnackPosition.TOP, backgroundColor: Colors.green[300]);
  }

  hendlePaymentError(PaymentFailureResponse response) {
    log('Failed: $response');
    Get.snackbar('error', response.message ?? 'Payment Failed',
        snackPosition: SnackPosition.TOP, backgroundColor: Colors.red[300]);
  }

  hendleExternalWallet() {}
}
