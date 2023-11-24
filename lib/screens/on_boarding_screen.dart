import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: dataOnBoarding(false));
  }

  Widget dataOnBoarding(bool isTablet) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            Expanded(
              child: PageView.builder(
                  itemCount: demoData.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnboardContent(
                      title: demoData[index].title,
                      descripcion: demoData[index].description,
                      image: demoData[index].image,
                      isTablet: isTablet)),
            ),
          ],
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/logo_head.png"), //fixe resolutions
                        fit: BoxFit.fill),
                  ),
                  margin: const EdgeInsets.only(top: 30, bottom: 10)),
              Stack(
                children: [
                  const Text(
                    "King's style",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Color del fondo
                    ),
                  ),
                  // Texto sin contorno (texto principal)
                  Text(
                    "King's style",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2.0
                        ..color = Colors.black, // Color del contorno
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.only(right: 30, left: 30),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).colorScheme.onPrimary)),
                        onPressed: () {
                          _pageController.nextPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.decelerate);
                          if (_pageIndex == 2) {
                            Navigator.pushNamed(context, '/login');
                          }
                        },
                        child: const Text(
                          'Siguiente',
                          style: TextStyle(color: Colors.white),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                            demoData.length,
                            ((index) => Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: DotIndicator(
                                    isActivate: index == _pageIndex)))),
                      ],
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class OnboardContent extends StatelessWidget {
  const OnboardContent(
      {Key? key,
      required this.title,
      required this.descripcion,
      required this.image,
      required this.isTablet})
      : super(key: key);
  final String title, descripcion, image;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(image), //fixe resolutions
              fit: BoxFit.fill)),
      //padding: const EdgeInsets.all(20),
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Color.fromARGB(212, 93, 93, 93),
            Color.fromARGB(255, 72, 72, 72),
            Color.fromARGB(255, 12, 12, 12)
          ],
          begin: Alignment(0.0, 0.30),
          end: Alignment.bottomCenter,
        )),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 120, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FadeInDown(
                delay: const Duration(microseconds: 700),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 38 : 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FadeInLeftBig(
                delay: const Duration(microseconds: 700),
                child: Text(
                  descripcion,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isTablet ? 24 : 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({Key? key, this.isActivate = false}) : super(key: key);
  final bool isActivate;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      height: isActivate ? 30 : 15,
      width: 15,
      decoration: BoxDecoration(
          color: isActivate
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
          shape: BoxShape.circle),
    );
  }
}

class Onboard {
  final String image, title, description;
  Onboard(
      {required this.image, required this.title, required this.description});
}

final List<Onboard> demoData = [
  Onboard(
      image: "assets/images/on_boarding_1.png",
      title: "Welcome to King's Style",
      description:
          "We're thrilled to have you on board! At King's Style, we've crafted a shopping experience that blends the latest in men's fashion with cutting-edge technology."),
  Onboard(
      image: "assets/images/on_boarding_2.png",
      title: "Explore Our Catalog",
      description:
          "Discover the latest in men's fashion. Navigate through our extensive catalog, intuitively organized to make your search a breeze."),
  Onboard(
      image: "assets/images/on_boarding_3.png",
      title: "Smart Shopping Cart",
      description:
          "Easily add your favorite items to the cart. Our intuitive shopping cart allows you to review and adjust your selection before making a purchase.")
];
