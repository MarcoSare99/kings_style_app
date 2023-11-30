import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kings_style_app/firebase/product_firebase.dart';
import 'package:kings_style_app/models/product_model.dart';
import 'package:kings_style_app/widgets/dialog_widget.dart';
import 'package:kings_style_app/widgets/text_field_widget.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ProductFireBase productFireBase = ProductFireBase();
  DialogWidget dialogWidget = DialogWidget();
  final List<File> _imageFiles = [];
  late final List<Map<String, dynamic>> sizeQuantity =
      List.empty(growable: true);
  late TextFieldWidget nameProduct;
  late TextFieldWidget modelProduct;
  late TextFieldWidget priceProduct;
  late TextFieldWidget descProduct;

  List<String> list = <String>['Trajes', 'Camisas', 'Pantalones', 'Sacos'];
  late String dropdownValue;
  int quantity = 0;

  void _addImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFiles.add(File(image.path));
      });
    }
  }

  void _deleteImageByIndex(index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  bool validateForm() {
    if ((nameProduct.controlador != null &&
        modelProduct.controlador != null &&
        priceProduct.controlador != null &&
        descProduct.controlador != null)) {
      return (nameProduct.controlador!.isNotEmpty &&
          modelProduct.controlador!.isNotEmpty &&
          priceProduct.controlador!.isNotEmpty &&
          descProduct.controlador!.isNotEmpty);
    } else {
      return false;
    }
  }

  Future<void> createProduct() async {
    String uid = const Uuid().v4();
    if (validateForm()) {
      if (_imageFiles.isEmpty) {
        var snackBar =
            const SnackBar(content: Text("One or more images are required"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        if (sizeQuantity.isEmpty) {
          var snackBar =
              const SnackBar(content: Text("One or more size are required"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          dialogWidget.showProgress();
          List<String> images = await uploadImages();
          ProductModel productModel = ProductModel(
              uid: uid,
              name: nameProduct.controlador,
              model: modelProduct.controlador,
              price: double.parse(priceProduct.controlador!),
              category: dropdownValue,
              description: descProduct.controlador,
              sizes: sizeQuantity,
              images: images);
          productFireBase.create(productModel: productModel).then((value) {
            dialogWidget.closeProgress();
            var snackBar = const SnackBar(content: Text("Product added"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pushNamed(context, '/dash_board');
          }).catchError((error) {
            var snackBar = const SnackBar(content: Text("Error"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
          dialogWidget.closeProgress();
        }
      }
    } else {
      var snackBar =
          const SnackBar(content: Text("Todos los campos son requeridos"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<List<String>> uploadImages() async {
    List<String> urlImages = List.empty(growable: true);
    for (File file in _imageFiles) {
      try {
        File image = file;
        final storage = FirebaseStorage.instance;
        final storageRef = storage.ref();
        final imageRef =
            storageRef.child('images/${DateTime.now().toString()}.jpg');
        final uploadTask = imageRef.putFile(image);
        final snapshot = await uploadTask.whenComplete(() {});
        final imageUrl = await snapshot.ref.getDownloadURL();
        urlImages.add(imageUrl);
      } on Exception catch (e) {
        throw Exception(e);
      }
    }
    return urlImages;
  }

  @override
  void initState() {
    dropdownValue = list.first;
    nameProduct = TextFieldWidget(
      label: 'Product name',
      hint: "Enter Product name",
      msgError: 'This field is required',
      icono: Icons.inventory_2,
      inputType: 1,
    );
    modelProduct = TextFieldWidget(
      label: 'Product model',
      hint: "Enter Product model",
      msgError: 'This field is required',
      icono: Icons.branding_watermark,
      inputType: 1,
    );
    priceProduct = TextFieldWidget(
      label: 'Product price',
      hint: "Enter product price",
      msgError: 'This field is required',
      icono: Icons.attach_money,
      inputType: 0,
    );

    descProduct = TextFieldWidget(
      label: 'Description',
      hint: "Enter Description",
      msgError: 'This field is required',
      icono: Icons.branding_watermark,
      inputType: 1,
      maxLine: 5,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add product",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const Text(
            "Product info.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          nameProduct,
          modelProduct,
          priceProduct,
          Container(
            padding: const EdgeInsets.all(8),
            width: 150,
            child: DropdownButtonFormField<String>(
              value: dropdownValue,
              dropdownColor: Theme.of(context).colorScheme.background,
              icon: const Icon(Icons.expand_more),
              decoration: InputDecoration(
                  prefixIcon: Container(
                    margin: const EdgeInsets.only(left: 14, right: 14),
                    child: const Icon(
                      Icons.straighten,
                    ),
                  ),
                  hintText: "Category",
                  labelText: "Category"),
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                dropdownValue = newValue!;
              },
            ),
          ),
          descProduct,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Size and quantity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _showModal();
                  },
                )
              ],
            ),
          ),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                crossAxisCount:
                    (MediaQuery.of(context).size.width ~/ 125).toInt(),
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) {
                return Container(
                  //color: Colors.green,
                  padding: const EdgeInsets.all(5),
                  child: Stack(children: [
                    DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(20),
                        dashPattern: const [10, 10],
                        color: Colors.grey,
                        strokeWidth: 2,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          height: 60,
                          child: Column(children: [
                            Text("Size: ${sizeQuantity[index]['size']}"),
                            Text(
                                "Quantity: ${sizeQuantity[index]['quantity']}"),
                          ]),
                        )),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          width: 20.0, // Ajusta según tus necesidades
                          height: 20.0, // Ajusta según tus necesidades
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54, // Color de fondo del botón
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
                              size: 14, // Color del icono
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
                );
              },
              itemCount: sizeQuantity.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            );
          }),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Product images",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                crossAxisCount:
                    (MediaQuery.of(context).size.width ~/ 170).toInt(),
                childAspectRatio: (150 / 200),
              ),
              itemBuilder: (context, index) {
                return Container(
                  //color: Colors.green,
                  padding: const EdgeInsets.all(5),
                  child: Stack(children: [
                    DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(20),
                        dashPattern: const [10, 10],
                        color: Colors.grey,
                        strokeWidth: 2,
                        child: SizedBox(
                          height: 200,
                          child: _imageFiles.length > index
                              ? Container(
                                  height: 200,
                                  //margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    image: DecorationImage(
                                        image: FileImage(_imageFiles[index]),
                                        fit: BoxFit.cover),
                                  ),
                                )
                              : Center(
                                  child: IconButton(
                                    iconSize: 50,
                                    color: Colors.white,
                                    icon: const Icon(Icons.add_photo_alternate),
                                    onPressed: _addImage,
                                  ),
                                ),
                        )),
                    _imageFiles.length > index
                        ? Positioned(
                            top: 5,
                            right: 5,
                            child: InkWell(
                              onTap: () {
                                _deleteImageByIndex(index);
                              },
                              child: Container(
                                width: 35.0, // Ajusta según tus necesidades
                                height: 35.0, // Ajusta según tus necesidades
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors
                                      .black54, // Color de fondo del botón
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.white, // Color del icono
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox()
                  ]),
                );
              },
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: createProduct,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showModal() {
    TextFieldWidget sizeProduct = TextFieldWidget(
      label: 'Product size',
      hint: "Enter Product size",
      msgError: 'This field is required',
      icono: Icons.straighten,
      inputType: 1,
    );
    TextFieldWidget quantityProduct = TextFieldWidget(
      label: 'Product quantity',
      hint: "Enter Product quantity",
      msgError: 'This field is required',
      icono: Icons.format_list_numbered,
      inputType: 0,
    );

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Add size and quantity',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    sizeProduct,
                    quantityProduct,
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (sizeProduct.formkey.currentState!.validate() &&
                            quantityProduct.formkey.currentState!.validate()) {
                          setState(() {
                            sizeQuantity.add({
                              'size': sizeProduct.controlador,
                              'quantity':
                                  double.parse(quantityProduct.controlador!)
                            });
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Guardar'),
                    ),
                  ],
                )),
          );
        });
  }
}
