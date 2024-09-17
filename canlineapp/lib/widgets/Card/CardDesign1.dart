import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Carddesign1 extends StatelessWidget {
  final double width;
  const Carddesign1({super.key, this.width = 160});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          splashColor: Colors.blue,
          onTap: () {
            context.go('/Health-Insititution/More-Info');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  // color: Colors.red
                ),
                clipBehavior: Clip.antiAlias,
                width: width,
                child: Image.asset('lib/assets/images/jpeg/spmc.jpg',
                    fit: BoxFit.fitHeight),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'SPMC Cancer Institutes',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Government Hospital',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
