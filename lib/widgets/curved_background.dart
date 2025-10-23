import 'package:flutter/material.dart';

class CurvedBackground extends StatelessWidget {
  final double height;
  final Color topColor;
  final Color bottomColor;

  const CurvedBackground({
    super.key,
    this.height = 260,
    this.topColor = const Color(0xFF1F1D47),
    this.bottomColor = const Color(0xFFF8F9FB),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          Container(color: bottomColor),

          ClipPath(
            clipper: CurvedClipper(),
            child: Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [topColor, topColor.withOpacity(0.9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height - 120,
      size.width * 0.5,
      size.height - 80,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 40,
      size.width,
      size.height - 100,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
