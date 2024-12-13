import 'package:flutter/material.dart';
import 'package:treveler/presentation/carousel/city_carousel.dart';
import 'package:treveler/models/city_model.dart';

class ExperiencesPage extends StatelessWidget {
  final List<City> cities = [
    City(name: "Málaga", imageUrl: "assets/images/malaga.webp"),
    City(name: "Cádiz", imageUrl: "assets/images/cadiz.webp"),
    City(name: "Tenerife", imageUrl: "assets/images/tenerife.webp"),
    City(name: "Gran Canaria", imageUrl: "assets/images/gran_canaria.webp"),
    City(name: "Cartagena", imageUrl: "assets/images/cartagena.webp"),
    City(name: "Alicante", imageUrl: "assets/images/alicante.webp"),
    City(name: "Valencia", imageUrl: "assets/images/valencia.webp"),
    City(name: "Ibiza", imageUrl: "assets/images/ibiza.webp"),
    City(name: "Palma de Mallorca", imageUrl: "assets/images/mallorca.webp"),
    City(name: "Barcelona", imageUrl: "assets/images/barcelona.webp"),
    City(name: "Bilbao", imageUrl: "assets/images/bilbao.webp"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/welcome.png', // Ruta de tu logo
          height: 40, // Ajusta el tamaño según sea necesario
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Elige tu experiencia",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(221, 0, 21, 91),
                    ),
              ),
            ),
            _buildExperienceOptions(context),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "¡Muy pronto en...",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(221, 0, 21, 91),
                    ),
              ),
            ),
            CityCarousel(cities: cities),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceOptions(BuildContext context) {
    return Column(
      children: [
        _experienceCard(
          context,
          title: "Viajeros con Poco Tiempo",
          description:
              "Disfruta tu visita con poco tiempo para explorar la ciudad. Recomendada para cruceristas.",
          imageUrl: "assets/images/crucero.jpg",
          onPressed: () {
            Navigator.pushNamed(context, '/cruise_experience');
          },
        ),
        const SizedBox(height: 10),
        _experienceCard(
          context,
          title: "Viajeros en General",
          description:
              "Explora los destinos de tu preferencia de manera flexible.",
          imageUrl: "assets/images/viajero.jpg",
          onPressed: () {
            Navigator.pushNamed(context, '/general_experience');
          },
        ),
        const SizedBox(height: 10),
        _experienceCard(
          context,
          title: "Viajeros en Autocaravana",
          description: "Disfruta tu viaje con nuestra playlist para tu ruta.",
          imageUrl: "assets/images/caravana.jpg",
          onPressed: () {
            Navigator.pushNamed(context, '/rv_experience');
          },
        ),
      ],
    );
  }

  Widget _experienceCard(
    BuildContext context, {
    required String title,
    required String description,
    required String imageUrl,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen en la parte superior
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(221, 0, 21, 91),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
