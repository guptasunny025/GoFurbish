import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olx_app/screens/product_edit_screen.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';
import 'product_view_screen.dart';

class MyProductScreen extends StatefulWidget {
  const MyProductScreen({super.key});

  @override
  State<MyProductScreen> createState() => _MyProductScreenState();
}

class _MyProductScreenState extends State<MyProductScreen> {
  Future<void> deleteProduct(String id) async {
    await FirebaseFirestore.instance.collection("products").doc(id).delete();
  }

  _showAlertDialog(id) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          final deviceSize = MediaQuery.of(context).size;
          return AlertDialog(
              backgroundColor: Colors.white,
              iconPadding: EdgeInsets.only(
                  top: 0, bottom: deviceSize.height / 4 / 4 / 4),
              content: Container(
                margin: EdgeInsets.only(
                    left: deviceSize.width / 4 / 4 / 3,
                    right: deviceSize.width / 4 / 4 / 3),
                child: Text('Are you sure you want to delete product ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: deviceSize.height / 4 / 4 / 3,
                        fontWeight: FontWeight.w500)),
              ),
              icon: Column(children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.trashCan,
                  color: Colors.red,
                  size: deviceSize.height / 4 / 4,
                ),
              ]),
              actions: [
                Column(children: [
                  Container(
                    width: double.infinity,
                    height: deviceSize.height / 4 / 3 * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff900D3E),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff900D3E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: deviceSize.height / 4 / 3 * .8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFE9E9E9),
                        border:
                            Border.all(color: Color(0xff900D3E), width: .6)),
                    margin: EdgeInsets.only(
                      top: deviceSize.height / 4 / 4 / 3,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE9E9E9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () async {
                        await deleteProduct(id);
                        Navigator.pop(context);
                      },
                      child: const Text('Yes',
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ),
                  )
                ])
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(children: [
      Expanded(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text(''),
              );
            }

            return snapshot.data!.docs
                    .where((element) =>
                        element['sellerid'] ==
                        Provider.of<Auth>(context, listen: false).userId)
                    .toList()
                    .isEmpty
                ? Center(
                    child: Text(
                      'No Product added yet add some',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: deviceSize.height / 4 / 4 / 3),
                    ),
                  )
                : ListView(
                    children: snapshot.data!.docs
                        .where((element) =>
                            element['sellerid'] ==
                            Provider.of<Auth>(context, listen: false).userId)
                        .toList()
                        .map((document) {
                      final dynamic data = document.data();
                      return GestureDetector(
                        child: Card(
                          color: Colors.white,
                          margin: EdgeInsets.only(
                              top: deviceSize.height / 4 / 4 / 2,
                              left: deviceSize.width / 4 / 4 / 2,
                              right: deviceSize.width / 4 / 4 / 2),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: deviceSize.width / 4 / 4 / 4,
                                right: 1,
                                top: deviceSize.height / 4 / 4 / 4 / 2,
                                bottom: deviceSize.height / 4 / 4 / 4 / 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      data['productimage'].toString(),
                                      width: deviceSize.width / 3 * .8,
                                      height: deviceSize.height / 4 * .7,
                                      fit: BoxFit.fill,
                                    )),
                                SizedBox(
                                  width: deviceSize.width / 4 / 4 / 2,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: deviceSize.height /
                                                    4 /
                                                    4 /
                                                    3),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${data['productname'][0].toUpperCase()}${data['productname'].substring(1).toLowerCase()}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: deviceSize.height /
                                                      4 /
                                                      4 /
                                                      3),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            deviceSize.height / 4 / 4 / 4 / 2,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Price: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: deviceSize.height /
                                                    4 /
                                                    4 /
                                                    3),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '₹ ' + data['productprice'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: deviceSize.height /
                                                      4 /
                                                      4 /
                                                      3),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            deviceSize.height / 4 / 4 / 4 / 2,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Desc: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: deviceSize.height /
                                                    4 /
                                                    4 /
                                                    3),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${data['productdesc'][0].toUpperCase()}${data['productdesc'].substring(1).toLowerCase()}',
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: deviceSize.height /
                                                      4 /
                                                      4 /
                                                      3),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            deviceSize.height / 4 / 4 / 4 / 2,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Sellername: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: deviceSize.height /
                                                    4 /
                                                    4 /
                                                    3),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${data['sellername'][0].toUpperCase()}${data['sellername'].substring(1).toLowerCase()}',
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: deviceSize.height /
                                                      4 /
                                                      4 /
                                                      3),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: deviceSize.height / 4 * .7,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            ProductEditScreen(
                                                              docid:
                                                                  document.id,
                                                              prodcat: data[
                                                                  'category'],
                                                              proddesc: data[
                                                                  'productdesc'],
                                                              prodid: data[
                                                                  'productid'],
                                                              prodimg: data[
                                                                  'productimage'],
                                                              prodname: data[
                                                                  'productname'],
                                                              prodprice: data[
                                                                  'productprice'],
                                                              prodquantity: data[
                                                                  'productquantity'],
                                                              selleremail: data[
                                                                  'selleremail'],
                                                              sellername: data[
                                                                  'sellername'],
                                                              sellernumber: data[
                                                                  'sellernumber'],
                                                            )));
                                              },
                                              icon: FaIcon(
                                                FontAwesomeIcons.penToSquare,
                                              )),
                                          IconButton(
                                              onPressed: () async {
                                                _showAlertDialog(document.id);
                                              },
                                              icon: FaIcon(
                                                FontAwesomeIcons.trashCan,
                                                color: Colors.red,
                                              ))
                                        ])),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProductViewScreen(
                                        prodcat: data['category'],
                                        prodid: data['productid'],
                                        proddesc: data['productdesc'],
                                        prodimg: data['productimage'],
                                        prodname: data['productname'],
                                        prodprice: data['productprice'],
                                        prodquantity: data['productquantity'],
                                        selleremail: data['selleremail'],
                                        sellernumber: data['sellernumber'],
                                        sellername: data['sellername'],
                                        sellerid: data['sellerid'],
                                        docid: document.id,
                                      )));
                        },
                      );
                    }).toList(),
                  );
          },
        ),
      )
    ]);
  }
}
