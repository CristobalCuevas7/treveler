
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:treveler/style/colors.dart';

Reference get firebaseStorage => FirebaseStorage.instance.ref();

class NetworkImages extends StatelessWidget {
  final double? width;
  final double? height;
  final String image;
  final BoxFit? fit;
  final bool isLoading;
  final String? placeHolderPath;

  const NetworkImages({super.key, this.width, this.height, required this.image, this.fit, this.isLoading = false, this.placeHolderPath});

  Future<String> getImageUrl() async {
    if (image.startsWith('http')) {
      return image;
    } else {
      try {
        String url = await firebaseStorage.child(image).getDownloadURL() ?? "";
        return url;
      } catch (error) {
        return "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getImageUrl(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || isLoading) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _buildHoldImage(),
              const CircularProgressIndicator(),
            ],
          );
        } else if (snapshot.hasError) {
          return _buildHoldImage();
        } else {
          return FadeInImage.memoryNetwork(
            width: width,
            height: height,
            placeholder: kTransparentImage,
            imageErrorBuilder: (context, error, stackTrace) {
              return _buildHoldImage();
            },
            image: snapshot.data!,
            fit: fit ?? BoxFit.cover,
          );
        }
      },
    );
  }

  Widget _buildHoldImage() {
    return Container(
      width: width,
      height: height,
      color: AppColors.lightGrey,
    );
  }
}
