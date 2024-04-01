import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final Function()? onBack;

  const CustomAppBar({
    Key? key,
    required this.pageTitle,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(pageTitle,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
          SizedBox(width: 8), // Espacement entre le logo et le titre
          Image.asset(
            'images/Logo-DocDash.png', // Chemin de l'image locale
            height: 80, // Ajustez la taille selon vos besoins
            // width: 40,
          ),

        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
