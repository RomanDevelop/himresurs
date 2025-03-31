import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../configs/app_config.dart';
import 'repaint_boundary_container.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final String fallbackKey;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const NetworkImageWidget({
    Key? key,
    required this.imageUrl,
    this.fallbackKey = 'defaultProductImage',
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundaryWrapper(
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) => Container(
            width: width,
            height: height,
            color: AppConfig.appThemeColor.withOpacity(0.1),
            child: Center(
              child: CircularProgressIndicator(
                color: AppConfig.appThemeColor,
                strokeWidth: 2.0,
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            // Используем резервное изображение из assets при ошибке
            String fallbackAsset;
            switch (fallbackKey) {
              case 'product':
                fallbackAsset = AppConfig.defaultProductImage;
                break;
              case 'logo':
                fallbackAsset = AppConfig.defaultLogoImage;
                break;
              case 'slider':
                fallbackAsset = AppConfig.defaultSliderImage;
                break;
              default:
                fallbackAsset = AppConfig.defaultProductImage;
            }

            return Image.asset(
              fallbackAsset,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: width,
                  height: height,
                  color: AppConfig.appThemeColor.withOpacity(0.1),
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: AppConfig.appThemeColor,
                      size: 32,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
