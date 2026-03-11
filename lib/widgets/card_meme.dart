import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardMeme extends StatelessWidget {
  final String imageUrl;
  final String desc;

  const CardMeme({super.key, required this.imageUrl, required this.desc});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: colorScheme.surface,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.network(imageUrl),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                desc,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
