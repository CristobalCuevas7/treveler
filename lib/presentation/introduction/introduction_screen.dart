import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    const Center(child: Text('Bienvenido a Treveler')),
    const Center(child: Text('Funciones de la app')),
    const Center(child: Text('Cómo funciona la app')),
  ];

  // Actualiza el índice de la página actual
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  // Completa la introducción y navega al menú principal
  Future<void> _completeIntroduction() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);

    if (context.mounted) context.go('/main');
  }

  // Navega al siguiente paso
  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeIntroduction(); // Última página, finalizar introducción
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                _buildWelcomePage(),
                _buildFeaturesPage(),
                _buildHowItWorksPage(),
              ],
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  // Página 1: Bienvenida
  Widget _buildWelcomePage() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¡Bienvenido a Treveler!',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(221, 0, 21, 91)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Descubre el mundo a través de nuestras audioguías interactivas y disfruta de una experiencia de viaje única.',
            style:
                TextStyle(fontSize: 18, color: Color.fromARGB(221, 0, 21, 91)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ClipRRect(
              borderRadius:
                  BorderRadius.circular(36), // Aquí defines el radio del borde
              child: Image.asset(
                'assets/images/welcome.webp',
                height: 250,
                fit: BoxFit.cover,
              )),
        ],
      ),
    );
  }

  // Página 2: Funciones
  Widget _buildFeaturesPage() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¿Qué vas a encontrar en Treveler?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(221, 0, 21, 91),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            '• Rutas culturales diseñadas por expertos locales.\n'
            '• Información detallada en seis idiomas.\n'
            '• Una experiencia 100% adaptable a tu ritmo.',
            style:
                TextStyle(fontSize: 18, color: Color.fromARGB(221, 0, 21, 91)),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/features.png',
            height: 300,
            width: MediaQuery.of(context).size.width,
          ), // Imagen de funciones
        ],
      ),
    );
  }

  // Página 3: Cómo funciona
  Widget _buildHowItWorksPage() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¿Cómo funciona?',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(221, 0, 21, 91)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            '1. Elige la opción que más te convenga (Crucerista, Viajeros en General, Autocaravana)\n'
            '2. Explora los puntos destacados mientras escuchas la audioguía.\n'
            '3. Disfruta a tu propio ritmo y consulta recomendaciones cercanas.',
            style:
                TextStyle(fontSize: 18, color: Color.fromARGB(221, 0, 21, 91)),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          Image.asset('assets/images/usos.png',
              height: 300), // Imagen de "Cómo funciona"
        ],
      ),
    );
  }

  // Barra de navegación inferior
  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _completeIntroduction, // Completa la introducción
            child: const Text('Saltar', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: _goToNextPage,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor:
                  const Color.fromARGB(221, 240, 120, 96), // Color del texto
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40), // Borde redondeado
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12), // Espaciado interno
            ),
            child: Text(_currentPage == _pages.length - 1
                ? 'Empezar'
                : 'Continuar'), // Cambia el texto dinámicamente
          ),
        ],
      ),
    );
  }
}
