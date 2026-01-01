import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedImage extends StatefulWidget {
  const CachedImage({
    super.key,
    this.url,
    // this.size = 100,
    this.cacheManager,
    this.useCache = true,
    this.showLoading = true,
  });

  /// 画像のURL
  final String? url;

  // /// サイズ
  // final double size;

  /// CacheManager
  final CacheManager? cacheManager;

  /// キャッシュを使うかどうか
  final bool useCache;

  /// ローディング表示するかどうか
  final bool showLoading;

  @override
  CachedImageState createState() => CachedImageState();
}

@visibleForTesting
class CachedImageState extends State<CachedImage> {
  final imageKey = GlobalKey(debugLabel: 'CachedImage');

  ImageProvider<Object>? get imageProvider => _imageProvider;
  ImageProvider<Object>? _imageProvider;

  dynamic get error => _error;
  dynamic _error;

  /// CacheManager
  CacheManager get _defaultCacheManager => CacheManager(
    Config('CachedImageKey', stalePeriod: const Duration(days: 1), maxNrOfCacheObjects: 20),
  );

  @override
  Widget build(BuildContext context) {
    if (widget.url == null || widget.url!.isEmpty) {
      _error = 'url is null';
      return const Icon(Icons.error);
    }

    if (!widget.useCache) {
      return Stack(
        children: [
          Image(
            key: imageKey,
            image: NetworkImage(widget.url!),
            loadingBuilder: widget.showLoading
                ? (context, child, progress) {
                    if (progress == null) {
                      return child;
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
                : null,
          ),
        ],
      );
    }

    return CachedNetworkImage(
      cacheManager: widget.cacheManager ?? _defaultCacheManager,
      imageUrl: widget.url!,
      imageBuilder: (context, imageProvider) {
        _imageProvider = imageProvider;
        return Align(
          alignment: Alignment.topCenter,
          child: Image(image: imageProvider),
        );
      },
      placeholder: widget.showLoading
          ? (context, url) => const Center(child: CircularProgressIndicator())
          : null,
      errorWidget: (context, url, dynamic error) {
        _error = error;
        return const Icon(Icons.error);
      },
    );
  }
}
