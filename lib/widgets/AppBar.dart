import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {
  String name;
  bool leadingIcon = true;

  CustomAppBar({super.key, required this.name, bool leadingIcon = true}){
    this.leadingIcon = leadingIcon;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: leadingIcon? Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQ3uAe8n5Mt7jYqElv9UDzixcAj9SsOYDgO2dK5JfG&s"):IconButton(onPressed: (){
          Navigator.pop(context, 'Submit');

        }, icon: Icon(Icons.arrow_back, color: Colors.black,)),
        backgroundColor: Colors.white,
        title: Text(name, style: GoogleFonts.oswald(color: Colors.black, fontSize: 28),));
  }
}
