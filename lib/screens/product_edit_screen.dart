// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import 'login_screen.dart';
import 'splash_screen.dart';

class ProductEditScreen extends StatefulWidget {
  final String prodname,
      prodprice,
      prodcat,
      proddesc,
      prodimg,
      prodquantity,
      prodid,
      selleremail,
      sellername,
      sellernumber,
      docid;
  const ProductEditScreen(
      {super.key,
      required this.prodname,
      required this.prodprice,
      required this.prodcat,
      required this.proddesc,
      required this.prodimg,
      required this.prodid,
      required this.selleremail,
      required this.sellername,
      required this.sellernumber,
      required this.prodquantity,
      required this.docid});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  var upload = false;
  String category = 'Select Category';
  String prodimg = '';
  var firestore = FirebaseFirestore.instance;
  final productname = TextEditingController();
  final productprice = TextEditingController();
  final productdesc = TextEditingController();
  final productquantity = TextEditingController();
  final sellername = TextEditingController();
  final sellernumber = TextEditingController();
  final selleremail = TextEditingController();
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
      prodimg = '';
    });
  }

  _camerapicker() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    setState(() {
      _imageFile = image;
      prodimg = '';
    });
  }

  Future<dynamic> editingData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    } else if (prodimg == ''&&_imageFile==null || category == 'Select Category') {
      if (prodimg == '' && _imageFile == null) {
        toast('Please Uplaod Product Image');
      } else {
        toast('Please Select Category');
      }
    } else {
      setState(() {
        buttonloading = true;
      });
      if (_imageFile != null) {
        Reference ref = FirebaseStorage.instance.ref().child(
            "images/${Provider.of<Auth>(context, listen: false).userId + DateTime.now().toString()}.jpg"); //generate a unique name
        UploadTask uploadTask =
            ref.putFile(File(_imageFile.path)); //you need to add path here
        final TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() async {
          productimageurl = await ref.getDownloadURL();
          print(productimageurl);
        });
      } else {
        productimageurl = widget.prodimg;
      }

      await firestore.collection("products").doc(widget.docid).update({
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
        Navigator.pop(context);
      });
      setState(() {
        buttonloading = false;
      });
    }
  }

  var isloading = true;
  setdetail() {
    productname.text = widget.prodname;
    productdesc.text = widget.proddesc;
    productname.text = widget.prodname;
    productprice.text = widget.prodprice;
    prodimg = widget.prodimg;
    productquantity.text = widget.prodquantity;
    selleremail.text = widget.selleremail;
    sellername.text = widget.sellername;
    sellernumber.text = widget.sellernumber;
    category = widget.prodcat;
    setState(() {
      isloading = false;
    });
  }
 _showAlertDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          final deviceSize = MediaQuery.of(context).size;
          return AlertDialog(
              backgroundColor: Colors.white,
              iconPadding: EdgeInsets.only(
                  top: 0, bottom: deviceSize.height / 4 / 4 / 4),
              title: Text('Log Out',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: deviceSize.height / 4 / 4 / 3,
                      fontWeight: FontWeight.bold)),
              content: Container(
                margin: EdgeInsets.only(
                    left: deviceSize.width / 4 / 4 / 3,
                    right: deviceSize.width / 4 / 4 / 3),
                child: Text('Are you sure you want to Log out?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: deviceSize.height / 4 / 4 / 3 ,fontWeight: FontWeight.w500)),
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
                FaIcon(FontAwesomeIcons.rightFromBracket,size: deviceSize.height/4/4,)
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
                        border: Border.all(color: Color(0xff900D3E), width: .6)),
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
                        await Provider.of<Auth>(context, listen: false)
                            .logout();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SplashScreen()),
                            (Route<dynamic> route) => false);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    setdetail();
    print(Provider.of<Auth>(context, listen: false).userId);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceSize.height / 4 / 3 * .9),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 3,
          backgroundColor: Color(0xff900D3E),
          leadingWidth: 0,
          title: Text(
            'Edit Product',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: deviceSize.height / 4 / 4 / 2 * .8),
          ),
          actions: [
            OutlinedButton(
                onPressed: () async {
                _showAlertDialog();
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
      body: Form(
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
        
            _imageFile == null && widget.prodimg == ''
                ? Container()
                : prodimg != ''
                    ? Container(
                        margin: EdgeInsets.only(
                            top: deviceSize.height / 4 / 4 / 2,
                            left: deviceSize.width / 4 / 4 / 2,
                            right: deviceSize.width / 4 / 4 / 2),
                        height: deviceSize.height / 4,
                        width: double.infinity,
                        child: Image.network(
                          widget.prodimg,
                          fit: BoxFit.fill,
                        ),
                      )
                    :_imageFile!=null? Container(
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
                      ):Container(),
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
                          _imageFile = null;
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      label: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ))
                  : TextButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: new Icon(Icons.photo),
                                    title: new Text('Camera'),
                                    onTap: () async {
                                      await _camerapicker();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.music_note),
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
                buttonloading == true ? null : await editingData();
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
                        'Edit Product',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: deviceSize.height / 4 / 4 / 3),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
