import 'package:flexi_image_slider/flexi_image_slider.dart';

import 'package:flutter/material.dart';
import 'package:kings_style_app/models/product_model.dart';

class DetailsProductoScreen extends StatefulWidget {
  ProductModel productModel;
  DetailsProductoScreen({super.key, required this.productModel});

  @override
  State<DetailsProductoScreen> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<DetailsProductoScreen> {
  late ProductModel productModel;
  TextEditingController controller = TextEditingController();
  List<String> arrayImages = [];
  List<String> list = [];
  late String dropdownValue;
  int quantity = 0;
  int talla = 0;

  @override
  void initState() {
    productModel = widget.productModel;
    arrayImages = productModel.images!;
    list = productModel.sizes!.map((item) {
      return item['size'].toString();
    }).toList();
    dropdownValue = list.first;
    controller.text = quantity.toString();
    super.initState();
  }

  //final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                flexi_image_slider(
                  context: context,
                  arrayImages: arrayImages,
                  aspectRatio: 3 / 4,
                  boxFit: BoxFit.cover,
                  autoScroll: false,
                  indicatorPosition: IndicatorPosition
                      .overImage, //IndicatorPosition.afterImage,IndicatorPosition.overImage,IndicatorPosition.none
                  indicatorAlignment: IndicatorAlignment.left,
                  indicatorActiveColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
                  indicatorDeactiveColor: Colors.grey,
                  borderRadius: 15,
                  onTap: (int index) {
                    //print("$index index clicked");
                    //handle your click events
                  },
                ),
                Text(
                  productModel.name!,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Text(
                    productModel.model!,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Text(
                    '${productModel.price!} MXN',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  margin: const EdgeInsets.only(bottom: 10),
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    value: dropdownValue,
                    dropdownColor: Theme.of(context).colorScheme.background,
                    icon: const Icon(Icons.expand_more),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        prefixIcon: Container(
                          margin: const EdgeInsets.only(left: 14, right: 14),
                          child: const Icon(
                            Icons.straighten,
                          ),
                        ),
                        hintText: "Talla",
                        labelText: "Talla"),
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        int newIndex = list.indexOf(newValue!);
                        talla = newIndex;
                        dropdownValue = newValue;
                      });
                      //widget.control = newValue;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Cantidad disponible ${productModel.sizes![talla]['quantity']}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      child: const Text("-"),
                      onPressed: () {
                        if (quantity > 0) {
                          setState(() {
                            quantity--;
                            controller.text = quantity.toString();
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      onChanged: (newText) {
                        if (newText == "") {
                          controller.text = "0";
                        } else {
                          quantity = int.parse(newText);
                          controller.text = int.parse(newText).toString();
                        }
                      },
                      style: const TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      child: const Text("+"),
                      onPressed: () {
                        setState(() {
                          quantity++;
                          controller.text = quantity.toString();
                        });
                      },
                    ),
                  )
                ]),
                Container(
                  margin: const EdgeInsets.all(10),
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text("Agregar a carrito"),
                    onPressed: () async {},
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Text(
                    "Descripción",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 20),
                  child: Text(productModel.description!,
                      style: const TextStyle(fontSize: 12)),
                )
              ]),
        ),
      ),
    );
  }
}
