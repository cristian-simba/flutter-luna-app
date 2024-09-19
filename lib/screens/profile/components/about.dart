import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.brightness == Brightness.dark ? CardColors.darkCard : CardColors.lightCard;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 225,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/about_img.jpeg'), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              color: backgroundColor,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola y bienvenido!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Mi nombre es David Simba y soy el desarrollador detrás de esta aplicación. Mi misión es ofrecerte una herramienta que te ayude a organizar tus pensamientos de manera sencilla y efectiva.',
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Sobre Luna',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Luna ha sido creada con el propósito de ofrecerte gestionar tus diarios y estados de ánimo de una manera intuitiva y útil. He trabajado para asegurarme de que la app sea confiable y sencilla.',
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Contacto',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Si tienes preguntas, sugerencias, o simplemente quieres ponerte en contacto, no dudes en enviar un correo en la parte de comentarios que se encuentra en el apartado de perfil. Estoy siempre abierto a escuchar tus comentarios y mejorar la app en base a tus necesidades.',
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Agradecimientos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Un agradecimiento especial a todos los usuarios que empiecen a usar la app. ¡Gracias por usar Luna! ',
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}