// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_app/screens/bottomnavigation_screen.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import 'login_screen.dart';

class ProductUploadScreen extends StatefulWidget {
  const ProductUploadScreen({super.key});

  @override
  State<ProductUploadScreen> createState() => _ProductUploadScreenState();
}

class _ProductUploadScreenState extends State<ProductUploadScreen> {
  var upload = false;
  String category = 'Select Category';
  var firestore = FirebaseFirestore.instance;
  final productname = TextEditingController();
  final productprice = TextEditingController();
  final productdesc = TextEditingController();
  final sellername = TextEditingController();
  final sellernumber = TextEditingController();
  final selleremail = TextEditingController();
  final productquantity = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _imageFile;
  var buttonloading = false;
  String productimageurl = '';
  ImagePicker _picker = ImagePicker();
  _logopicker() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      _imageFile = image;
    });
  }

  _camerapicker() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    setState(() {
      _imageFile = image;
    });
  }

  Future<dynamic> uploadingData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    } else if (_imageFile == null || category == 'Select Category') {
      if (_imageFile == null) {
        toast('Please Uplaod Product Image');
      } else {
        toast('Please Select Category');
      }
    } else {
      setState(() {
        buttonloading = true;
      });
      Reference ref = FirebaseStorage.instance.ref().child(
          "images/${Provider.of<Auth>(context, listen: false).userId + DateTime.now().toString()}.jpg"); //generate a unique name
      UploadTask uploadTask =
          ref.putFile(File(_imageFile.path)); //you need to add path here
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() async {
        productimageurl = await ref.getDownloadURL();
        print(productimageurl);
      });

      await firestore.collection("products").add({
        'productname': productname.text.trim(),
        'productprice': productprice.text.trim(),
        'productimage': productimageurl,
        'productid': DateTime.now().toString(),
        'productdesc': productdesc.text.trim(),
        'productquantity': productquantity.text.trim(),
        'selleremail': selleremail.text.trim(),
        'sellernumber': sellernumber.text.trim(),
        'sellername': sellername.text.trim(),
        'sellerid': Provider.of<Auth>(context, listen: false).userId,
        'isavailable': true,
        'category': category,
      }).then((value) {
       Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const BottomNavigationScreen(index: 0,)));
      });
      setState(() {
        buttonloading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(Provider.of<Auth>(context, listen: false).userId);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: ListView(
        children: [
           Container(
                margin: EdgeInsets.only(top: deviceSize.height/4/4/4,left: deviceSize.width / 4 / 4 / 2,),
                child: Text('Product Name',style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: deviceSize.height / 4 / 4 / 3),),
              ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                top: deviceSize.height / 4 / 4 / 4,
                left: deviceSize.width / 4 / 4 / 2,
                right: deviceSize.width / 4 / 4 / 2),
            height: deviceSize.height / 4 / 3*.8,
           decoration: BoxDecoration(border: Border.all(color: Colors.black,width: .3)),
            child:TextFormField(
             controller: productname,
             validator: (value) =>
            value!.length>30?'name length should be 1 - 30 characters':     value.isEmpty ? 'Pḷease enter product name' : null,
             decoration: InputDecoration(
               hintText: 'product name',
               border: InputBorder.none,
               contentPadding:
                   EdgeInsets.only(left: deviceSize.width / 4 / 4/2),
             ))
          ),
            Container(
                margin: EdgeInsets.only(top: deviceSize.height/4/4/3,left: deviceSize.width / 4 / 4 / 2,),
                child: Text('Product Price',style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: deviceSize.height / 4 / 4 / 3),),
              ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                top: deviceSize.height / 4 / 4 / 4,
                left: deviceSize.width / 4 / 4 / 2,
                right: deviceSize.width / 4 / 4 / 2),
            height: deviceSize.height / 4 / 3*.8,
            decoration: BoxDecoration(border: Border.all(color: Colors.black,width: .3)),
            child: TextFormField(
                keyboardType: TextInputType.number,
                controller: productprice,
                validator: (value) =>
                    value!.isEmpty ? 'Pḷease enter product price' : null,
                decoration: InputDecoration(
                  hintText: 'product price',
                  contentPadding:
                      EdgeInsets.only(left: deviceSize.width / 4 / 4),
                  border: InputBorder.none,
                )),
          ),
           Container(
                margin: EdgeInsets.only(top: deviceSize.height/4/4/3,left: deviceSize.width / 4 / 4 / 2,),
                child: Text('Product Quantity',style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: deviceSize.height / 4 / 4 / 3),),
              ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                top: deviceSize.height / 4 / 4 / 4,
                left: deviceSize.width / 4 / 4 / 2,
                right: deviceSize.width / 4 / 4 / 2),
            height: deviceSize.height / 4 / 3*.8,
            decoration: BoxDecoration(border: Border.all(color: Colors.black,width: .3)),
            child: TextFormField(
                controller: productquantity,
                keyboardType: TextInputType.number,
                validator: (value) => value! == '0'
                        ? 'Please enter valid quantity'
                        :value.isEmpty
                    ? 'Pḷease enter product quantity'
                    :  null,
                decoration: InputDecoration(
                  hintText: 'product quantity',
                  contentPadding:
                      EdgeInsets.only(left: deviceSize.width / 4 / 4),
                  border: InputBorder.none,
                )),
          ),
           Container(
                margin: EdgeInsets.only(top: deviceSize.height/4/4/3,left: deviceSize.width / 4 / 4 / 2,),
                child: Text('Category',style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: deviceSize.height / 4 / 4 / 3),),
              ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                top: deviceSize.height / 4 / 4 / 4,
                left: deviceSize.width / 4 / 4 / 2,
                right: deviceSize.width / 4 / 4 / 2),
            height: deviceSize.height / 4 / 3*.8,
            decoration: BoxDecoration(border: Border.all(color: Colors.black,width: .3)),
            padding: EdgeInsets.only(left: deviceSize.width / 4 / 4),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                hint: FittedBox(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontFamily: 'SourceSerifPro',
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                isExpanded: true,
                iconSize: 25.0,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SourceSerifPro',
                ),
                items: [
                  'Select Category',
                  'Electronics',
                  'Clothing',
                  'Vehicle',
                  'Other'
                ].map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: FittedBox(child: Text(val)),
                    );
                  },
                ).toList(),
                onChanged: (val) async {
                  setState(
                    () {
                      category = val.toString();
                    },
                  );
                },
              ),
            ),
          ),
            Container(
                margin: EdgeInsets.only(top: deviceSize.height/4/4/3,left: deviceSize.width / 4 / 4 / 2,),
                child: Text('Product Description',style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: deviceSize.height / 4 / 4 / 3),),
              ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                top: deviceSize.height / 4 / 4 / 4,
                left: deviceSize.width / 4 / 4 / 2,
                right: deviceSize.width / 4 / 4 / 2),
            height: deviceSize.height / 4 / 3*.8,
            decoration: BoxDecoration(border: Border.all(color: Colors.black,width: .3)),
            child: TextFormField(
                controller: productdesc,
                validator: (value) =>
                    value!.isEmpty ? 'Pḷease enter product description' : null,
                decoration: InputDecoration(
                  hintText: 'product description',
                  contentPadding:
                      EdgeInsets.only(left: deviceSize.width / 4 / 4),
                  border: InputBorder.none,
                )),
          ),
            Container(
                margin: EdgeInsets.only(top: deviceSize.height/4/4/3,left: deviceSize.width / 4 / 4 / 2,),
                child: Text('Contact Name',style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: deviceSize.height / 4 / 4 / 3),),
              ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                top: deviceSize.height / 4 / 4 / 4,
                left: deviceSize.width / 4 / 4 / 2,
                right: deviceSize.width / 4 / 4 / 2),
            height: deviceSize.height / 4 / 3*.8,
            decoration: BoxDecoration(border: Border.all(color: Colors.black,width: .3)),
            child: TextFormField(
                controller: sellername,
                validator: (value) =>
                    value!.isEmpty ? 'Pḷease enter contact name' : null,
                decoration: InputDecoration(
                  hintText: 'contact name',
                  contentPadding:
                      EdgeInsets.only(left: deviceSize.width / 4 / 4),
                  border: InputBorder.none,
                )),
          ),
            Container(
                margin: EdgeInsets.only(top: deviceSize.height/4/4/3,left: deviceSize.width / 4 / 4 / 2,),
                child: Text('Contact Email',style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: deviceSize.height / 4 / 4 / 3),),
              ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                top: deviceSize.height / 4 / 4 / 4,
                left: deviceSize.width / 4 / 4 / 2,
                right: deviceSize.width / 4 / 4 / 2),
            height: deviceSize.height / 4 / 3*.8,
            decoration: BoxDecoration(border: Border.all(color: Colors.black,width: .3)),
            child: TextFormField(
                controller: selleremail,
                validator: (value) =>
                    value!.isEmpty ? 'Pḷease enter contact email' : null,
                decoration: InputDecoration(
                  hintText: 'contact email',
                  contentPadding:
                      EdgeInsets.only(left: deviceSize.width / 4 / 4),
                  border: InputBorder.none,
                )),
          ),
           Container(
                margin: EdgeInsets.only(top: deviceSize.height/4/4/3,left: deviceSize.width / 4 / 4 / 2,),
                child: Text('Contact Number',style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: deviceSize.height / 4 / 4 / 3),),
              ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                top: deviceSize.height / 4 / 4 / 4,
                left: deviceSize.width / 4 / 4 / 2,
                right: deviceSize.width / 4 / 4 / 2),
            height: deviceSize.height / 4 / 3*.8,
            decoration: BoxDecoration(border: Border.all(color: Colors.black,width: .3)),
            child: TextFormField(
                controller: sellernumber,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty
                    ? 'Pḷease enter contact number'
                    : value.length != 10
                        ? 'Please enter valid number'
                        : null,
                decoration: InputDecoration(
                  hintText: 'contact number',
                  contentPadding:
                      EdgeInsets.only(left: deviceSize.width / 4 / 4),
                  border: InputBorder.none,
                )),
          ),
          _imageFile == null
              ? Container()
              : Container(
                  margin: EdgeInsets.only(
                      top: deviceSize.height / 4 / 4 / 2,
                      left: deviceSize.width / 4 / 4 / 2,
                      right: deviceSize.width / 4 / 4 / 2),
                  height: deviceSize.height / 4,
                  width: double.infinity,
                  child: Image.file(
                    File(_imageFile.path),
                    fit: BoxFit.fill,
                  ),
                ),
          Container(
            width: double.infinity,
            height: deviceSize.height / 4 / 3,
            margin: EdgeInsets.only(
                top: deviceSize.height / 4 / 4 / 3,
                left: deviceSize.width / 4 / 3,
                right: deviceSize.width / 4 / 3),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: _imageFile != null
                ? TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _imageFile=null;
                      });
                    },
                    icon: Icon(Icons.close,color: Colors.black,),
                    label: Text('Cancel',style: TextStyle(color: Colors.black),))
                : TextButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: new Icon(Icons.camera),
                                  title: new Text('Camera'),
                                  onTap: () async {
                                    await _camerapicker();
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: new Icon(Icons.photo),
                                  title: new Text('Gallery'),
                                  onTap: () async {
                                    await _logopicker();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    icon: Icon(
                      Icons.upload_file,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Upload Image',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: deviceSize.height / 4 / 4 / 3),
                    ),
                  ),
          ),
          GestureDetector(
            onTap: () async {
              buttonloading == true ? null : await uploadingData();
            },
            child: Container(
              width: double.infinity,
              height: deviceSize.height / 4 / 3,
              margin: EdgeInsets.only(
                  top: deviceSize.height / 4 / 4 / 2,
                  bottom: deviceSize.height / 4 / 4 / 2,
                  left: deviceSize.width / 4 / 4 / 2,
                  right: deviceSize.width / 4 / 4 / 2),
              decoration: BoxDecoration(
                  color: const Color(0xff900D3E),
                  borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: buttonloading == true
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      'Upload Product',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: deviceSize.height / 4 / 4 / 3),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
