import 'package:app/models/DonationMod.dart';
import 'package:app/models/UserMod.dart';
import 'package:app/payment/paypal_payment.dart';
import 'package:app/screen/donation/transactionbranch.dart';
import 'package:app/services/DonationService.dart';
import 'package:app/services/transactionserrvice.dart';
import 'package:app/services/userdb.dart';
import 'package:app/template/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VDonation extends StatefulWidget {
  final String donationid;

  VDonation({Key key, @required this.donationid}) : super(key: key);

  @override
  _VDonationState createState() => _VDonationState();
}

class _VDonationState extends State<VDonation> {
  InAppWebViewController webView;

  void showNonce(BraintreePaymentMethodNonce nonce) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }

  CollectionReference donation =
      FirebaseFirestore.instance.collection('donations');

  // String get donationid => widget.donationid;

  final donationController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    donationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> success() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Succesfully Donated '),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Thank You For Your Contribution'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    final user = Provider.of<UserM>(context);

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Paypal ID was found'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Please look at project description on how to donate'),
                  Text('Thank you for your cooperation'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Donation'),
          backgroundColor: Colors.pinkAccent,
          elevation: 0.0,
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: donation.doc(widget.donationid).snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              Widget mediaGetter() {
                if (snapshot.data['img'] != null) {
                  return Image.network(snapshot.data['img']);
                } else if (snapshot.data['uyoutube'] != null) {
                  String vid;

                  // Convert Video to ID
                  vid = YoutubePlayer.convertUrlToId(snapshot.data['uyoutube']);

                  var _controller = YoutubePlayerController(
                    initialVideoId: vid,
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  );

                  return YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                  );
                } else if (snapshot.data['ufacebook'] != null) {
                  var url = snapshot.data['ufacebook'];

                  return Container(
                    height: 290,
                    child: InAppWebView(
                      initialUrl: url,
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                            debuggingEnabled: true,
                            preferredContentMode:
                                UserPreferredContentMode.MOBILE),
                      ),
                      onWebViewCreated: (InAppWebViewController controller) {
                        webView = controller;
                      },
                      onLoadStart:
                          (InAppWebViewController controller, String url) {},
                      onLoadStop: (InAppWebViewController controller,
                          String url) async {},
                    ),
                  );
                } else {
                  return Icon(Icons.person);
                }
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              }
              return ListView(
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        mediaGetter(),

                        ListTile(
                          title: Text(snapshot.data['title']),
                          subtitle: Text(
                            snapshot.data['descri'],
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),

                        ListTile(
                          title: Text('Current Funds :' +
                              snapshot.data['curfund'].toString()),
                          subtitle: Text(
                            'Needed Funds : ' +
                                snapshot.data['fundneed'].toString(),
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            snapshot.data['name'],
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),

                        // TextField(
                        //  controller:  ,
                        //  ),

                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: donationController,
                                ),
                              ),
                            ),

                            //  Paypal Payment with Static ID

                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: StreamBuilder(
                            //       stream:
                            //           DatabaseService(uid: user.uid).userData,
                            //       builder: (context, snapshot) {
                            //         UserData meep = snapshot.data;

                            //         return StreamBuilder(
                            //             stream: DonationService(
                            //                     did: widget.donationid)
                            //                 .donationData,
                            //             builder: (context, snapshot) {
                            //               DonationData mep = snapshot.data;
                            //               return RaisedButton.icon(
                            //                 onPressed: () async {
                            //                   DocumentReference docRef =
                            //                       FirebaseFirestore.instance
                            //                           .collection('donations')
                            //                           .doc(widget.donationid);
                            //                   DocumentSnapshot doc =
                            //                       await docRef.get();

                            //                   if (doc.data()['paypalid'] ==
                            //                       null) {
                            //                     _showMyDialog();
                            //                   } else {
                            //

                            //                     await Navigator.of(context)
                            //                         .push(MaterialPageRoute(
                            //                             builder: (context) =>
                            //                                 PaypalPayment(
                            //                                     donation:
                            //                                         donationController
                            //                                             .text,
                            //                                     onFinish:
                            //                                         (number) async {
                            //                                       var amount =
                            //                                           int.parse(
                            //                                               donationController
                            //                                                   .text);
                            //                                       int currentf =
                            //                                           mep.curfund;

                            //                                       var famount =
                            //                                           amount +
                            //                                               currentf;

                            //                                       //payment

                            //                                       print('orderid :' +
                            //                                           number);

                            //                                       await TransactionService(tid: number.toString()).updateTrans(
                            //                                           user.uid,
                            //                                           meep.name,
                            //                                           'PayPal',
                            //                                           widget
                            //                                               .donationid,
                            //                                           mep.title,
                            //                                           mep
                            //                                               .userid,
                            //                                           'success',
                            //                                           DateGetter(),
                            //                                           amount,
                            //                                           number
                            //                                               .toString());

                            //                                       print(number);

                            //                                       await DonationService(
                            //                                               did: widget
                            //                                                   .donationid)
                            //                                           .updateFund(
                            //                                               famount);

                            //                                       success();
                            //                                     })));
                            //                   }
                            //                 },
                            //                 icon: Icon(
                            //                   Icons.add,
                            //                   color: Colors.white,
                            //                 ),
                            //                 label: Text('Donate'),
                            //                 color: Colors.green,
                            //               );
                            //             });
                            //       }),
                            // ),

                            // Braintree payment with dynamic token

                            RaisedButton(
                              onPressed: () async {
                                var request = BraintreeDropInRequest(
                                  tokenizationKey: snapshot.data['token'],
                                  collectDeviceData: true,
                                  googlePaymentRequest:
                                      BraintreeGooglePaymentRequest(
                                    totalPrice: donationController.text,
                                    currencyCode: 'USD',
                                    billingAddressRequired: false,
                                  ),
                                  paypalRequest: BraintreePayPalRequest(
                                    amount: donationController.text,
                                    displayName: 'Example company',
                                  ),
                                  cardEnabled: true,
                                );
                                BraintreeDropInResult result =
                                    await BraintreeDropIn.start(request);
                                if (result != null) {
                                  var hurm = result.paymentMethodNonce;

                                  var amount =
                                      int.parse(donationController.text);

                                  StreamBuilder(
                                    // ignore: missing_return
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      UserData _data = snapshot.data;

                                      TransactionService(tid: hurm.nonce)
                                          .updateTrans(
                                              user.uid,
                                              _data.name,
                                              hurm.typeLabel,
                                              widget.donationid,
                                              snapshot.data['title'],
                                              snapshot.data['userid'],
                                              'Success',
                                              DateGetter(),
                                              amount,
                                              hurm.nonce);
                                    },
                                  );

                                  int currentf = snapshot.data['curfund'];
                                  var famount = amount + currentf;
                                  DonationService(did: widget.donationid)
                                      .updateFund(famount);

                                  showNonce(result.paymentMethodNonce);
                                }
                              },
                              child: Text('Donate'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  DateGetter() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd ').format(now);
    return formattedDate;
  }
}
