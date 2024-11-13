import 'package:dio/dio.dart';

class Blog {
  final int id;
  final String title;
  final String description;
  final String date;
  final String category;
  final String? image;
  final String createdAt;
  final String updatedAt;

  Blog({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      category: json['category'] ?? '',
      image: json['image'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://backend.abyssiniasoftware.com/api';

  Future<Map<String, dynamic>> createBlog({
    required String title,
    required String description,
    required String category,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/blogs',
        data: {
          'title': title,
          'description': description,
          'date': DateTime.now().toIso8601String(),
          'category': category,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("response.data: ${response.data}");
        return {
          'success': true,
          'data': response.data,
          'message': 'Blog posted successfully'
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to post blog. Status code: ${response.statusCode}'
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['message'] ?? 'Something went wrong'
      };
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  Future<Map<String, dynamic>> getAllBlogs() async {
    try {
      final response = await _dio.get('$_baseUrl/blogs');

      if (response.statusCode == 200) {
        final List<dynamic> blogList = response.data;
        final List<Blog> blogs =
            blogList.map((json) => Blog.fromJson(json)).toList();

        return {
          'success': true,
          'data': blogs,
          'message': 'Blogs fetched successfully'
        };
      } else {
        return {
          'success': false,
          'message':
              'Failed to fetch blogs. Status code: ${response.statusCode}'
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['message'] ?? 'Failed to fetch blogs'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred while fetching blogs'
      };
    }
  }
}
