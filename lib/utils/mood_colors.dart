import 'package:flutter/material.dart';

Color getMoodColor(String mood) {
  switch (mood) {
    case 'Normal':
      return Color(0xFFFFE0B5); // Light Orange
    case 'Feliz':
      return Color(0xFFFFC107); // Amber
    case 'Triste':
      return Color.fromARGB(255, 79, 141, 255); // Golden Yellow
    case 'Enojado':
      return Color.fromARGB(255, 255, 92, 77); // Deep Orange
    case 'Confundido':
      return Color(0xFFFF8A65); // Deep Peach
    case 'Sorprendido':
      return Color(0xFFFFA07A); // Light Salmon
    case 'Cansado':
      return Color(0xFFFFD180); // Light Orange
    case 'x':
      return Color(0xFFFFE0B5); // Light Orange (representa "sin palabras")
    default:
      return Color(0xFFB68989); // Color de reserva
  }
}
