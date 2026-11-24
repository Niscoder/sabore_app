import 'package:flutter/material.dart';

/// Imagem de receita com indicador de carregamento e fallback visual (RF02).
class RecipeImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const RecipeImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: url.isEmpty
            ? const _ImageFallback()
            : Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.deepOrange.shade50,
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    const _ImageFallback(),
              ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(
        Icons.restaurant,
        color: Colors.grey.shade500,
        semanticLabel: 'Imagem indisponível',
      ),
    );
  }
}