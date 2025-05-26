import 'package:dio/dio.dart';

const String apiKey =
    'IhXSnJVpjbvcKeCUc4opPfK0jsXYwxed25LZfYjh10alwoMOen3Zg4FA';

class PexelsPhotoService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.pexels.com/v1/',
      headers: {
        'Authorization': apiKey,
      },
    ),
  );

  Future<List<String>> getLoactionPhotos(String query,
      {int perPage = 10}) async {
    try {
      final response = await dio.get(
        'search',
        queryParameters: {
          'query': query,
          'per_page': perPage,
        },
      );

      final List photos = response.data['photos'];
      List<String> photoUrls =
          photos.map((photo) => photo['src']['large2x'] as String).toList();

      return photoUrls;
    } catch (e) {
      print('Pexels API 錯誤: $e');
      return [];
    }
  }
}
