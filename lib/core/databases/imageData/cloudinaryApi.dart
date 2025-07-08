import 'package:chatapp/core/databases/imageData/cloudinaryKeys.dart';
import 'package:cloudinary/cloudinary.dart';

class CloudinaryApi {
  static final cloudinary = Cloudinary.signedConfig(
    apiKey: Cloudinarykeys.apiKey,
    apiSecret: Cloudinarykeys.apiSecret,
    cloudName: Cloudinarykeys.cloudName,
  );
}
