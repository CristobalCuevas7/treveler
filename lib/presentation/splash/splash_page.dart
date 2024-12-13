import 'package:flutter/material.dart';
import 'package:treveler/config/navigation.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/usecases/check_session_usecase.dart';
import 'package:treveler/domain/usecases/fetch_premium_usecase.dart';

class SplashPage extends StatelessWidget {
  final CheckSessionUseCase _checkSessionUseCase;
  final FetchPremiumUseCase _fetchPremiumUseCase;

  const SplashPage(this._checkSessionUseCase, this._fetchPremiumUseCase, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<bool>(
          future: _checkIfUserIsLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.navigateToMainPage();
              });
            }
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SizedBox(height: 32), CircularProgressIndicator()],
            );
          },
        ),
      ),
    );
  }

  Future<bool> _checkIfUserIsLoggedIn() async {
    Result<bool> result = await _checkSessionUseCase.execute();
    return result.fold(
      onSuccess: (isValid) async {
        await _fetchPremiumUseCase.execute();
        return isValid;
      },
      onFailure: (message, errorType) {
        return false;
      },
    );
  }
}
