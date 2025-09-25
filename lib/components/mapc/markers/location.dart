import 'package:flutter/material.dart';

class LocationPicker extends StatefulWidget {
  final Size pointSize;

  const LocationPicker({Key? key, required this.pointSize}) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> animation;

  final double redBullSize = 50;
  final double whiteBullSize = 15;
  final double rootSize = 3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )
      ..repeat(reverse: true)
      ..addListener(() {
        setState(() {});
      });

    animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    // _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
    //   setState(() {
    //     topPosition = generateTopPosition(30);
    //     leftPosition = generateLeftPosition(30);
    //   });

    //   // my_print("tick ${timer.tick}");
    //   my_print("top ${topPosition}");
    //   my_print("left ${leftPosition}");
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.pointSize.height,
      width: widget.pointSize.width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: ((animation.value * (8 / 100) * redBullSize) + (redBullSize)),
            left: ((widget.pointSize.width / 2) - rootSize / 2),
            child: Container(
              alignment: Alignment.center,
              width: rootSize,
              height: 30,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 160, 54, 54),
                  borderRadius:
                      BorderRadius.all(Radius.circular(whiteBullSize))),
            ),
          ),
          Positioned(
            bottom: -50,
            left: ((widget.pointSize.width / 2) - redBullSize / 2),
            child: Transform(
              transform: Matrix4.rotationX(2.1),
              child: Container(
                alignment: Alignment.center,
                width: redBullSize,
                height: redBullSize,
                decoration: BoxDecoration(
                  color: const Color(0xFF0E3311).withOpacity(0),
                  borderRadius: BorderRadius.all(Radius.circular(redBullSize)),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(1, -1),
                      spreadRadius: -animation.value * 9,
                      blurRadius: 4,
                      color: Color.fromRGBO(0, 0, 0, animation.value * 0.3),
                    )
                  ],
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xFF0E3311).withOpacity(.5),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Text(
                    '.',
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: ((animation.value * (8 / 100) * widget.pointSize.height)),
            left: ((widget.pointSize.width / 2) - redBullSize / 2),
            child: Container(
              alignment: Alignment.center,
              width: redBullSize,
              height: redBullSize,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: SizedBox(
                height: whiteBullSize,
                width: whiteBullSize,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: ((animation.value * (8 / 100) * redBullSize)),
                      child: Container(
                        alignment: Alignment.center,
                        width: whiteBullSize,
                        height: whiteBullSize,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(whiteBullSize))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
