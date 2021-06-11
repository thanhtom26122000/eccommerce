import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class DrawMap {
  Future<Uint8List> resizeAndCircle(String imageURL, int size) async {
    ByteData bytes =
        (await NetworkAssetBundle(Uri.parse(imageURL)).load(imageURL));
    Codec codec = await instantiateImageCodec(bytes.buffer.asUint8List(),
        targetWidth: size, targetHeight: size);
    FrameInfo fi = await codec.getNextFrame();
    Image image = fi.image;
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint();
    paint.isAntiAlias = true;

    _performCircleCrop(image, Size.zero, canvas);

    final recordedPicture = pictureRecorder.endRecording();
    Image img = await recordedPicture.toImage(image.width, image.height);
    final byteData = await img.toByteData(format: ImageByteFormat.png);
    final buffer = byteData.buffer.asUint8List();
    return buffer;
  }

  Canvas _performCircleCrop(Image image, Size size, Canvas canvas) {
    Paint paint = Paint();
    canvas.drawCircle(Offset(0, 0), 0, paint);

    double drawImageWidth = 0;
    double drawImageHeight = 0;

    Path path = Path()
      ..addOval(Rect.fromLTWH(drawImageWidth, drawImageHeight,
          image.width.toDouble(), image.height.toDouble()));

    canvas.clipPath(path);
    canvas.drawImage(image, Offset(drawImageWidth, drawImageHeight), Paint());
    return canvas;
  }

  Future<Uint8List> getBytesFromAsset(
      String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
