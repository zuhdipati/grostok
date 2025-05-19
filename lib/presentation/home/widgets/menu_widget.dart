import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeMenuWidget extends StatelessWidget {
  final String assetName;
  final String title;

  const HomeMenuWidget({
    super.key, required this.assetName, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      child: Column(
        children: [
          Container(
            height: 45, 
            width: 45,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 0.5,
                      color: Colors.black.withValues(alpha: 0.5))
                ]),
            child: SvgPicture.asset(assetName),
          ),
          SizedBox(height: 5),
          Text(title)
        ],
      ),
    );
  }
}