import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170),
        child: Builder(
          builder: (context) {
            return Container(
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onErrorContainer,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 30,
                          color: Colors.white,
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                        IconButton(
                          iconSize: 30,
                          color: Colors.white,
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Find your favorite items",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: const TextField(
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                cardCategory(title: 'Trajes', img: 'assets/images/traje.png'),
                cardCategory(title: 'Camisas', img: 'assets/images/camisa.png'),
                cardCategory(
                    title: 'Pantalones', img: 'assets/images/pantalon.png'),
                cardCategory(title: 'Sacos', img: 'assets/images/saco.png')
              ],
            ),
          ),
          const Text(
            "Popular",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                crossAxisCount:
                    (MediaQuery.of(context).size.width ~/ 170).toInt(),
                childAspectRatio: (110 / 200),
              ),
              itemBuilder: (context, index) {
                return Container(
                  //color: Colors.green,
                  padding: EdgeInsets.all(5),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/producto_1.jpg"),
                                fit: BoxFit.fill),
                          ),
                        ),
                        const Text(
                          "saco separate bamboo fiber slim fit lmental",
                          style: TextStyle(fontSize: 12),
                          softWrap: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "\$2,199.00",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ]),
                );
              },
              itemCount: 9,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
        ],
      ),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menú Lateral',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Opción 1'),
            onTap: () {
              // Acción cuando se selecciona la opción 1
              Navigator.pop(context); // Cierra el Drawer
            },
          ),
          ListTile(
            title: const Text('Opción 2'),
            onTap: () {
              // Acción cuando se selecciona la opción 2
              Navigator.pop(context); // Cierra el Drawer
            },
          ),
        ],
      )),
    );
  }

  Widget cardCategory({String? title, String? img}) {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 120,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(img!), fit: BoxFit.fill),
                ),
                margin: const EdgeInsets.all(10)),
            Text(
              title!,
              style: const TextStyle(color: Colors.black),
            )
          ]),
    );
  }
}
