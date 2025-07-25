import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  static location(int i, String location) {}
}

class Ad {
  final String title;
  final String description;
  final double price;
  final String location;
  final int userId;
  final int categoryId;
  final int subcategoryId;

  Ad({
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.userId,
    required this.categoryId,
    required this.subcategoryId,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      location: json['location'] ?? '',
      userId: json['userId'] ?? 0,
      categoryId: json['categoryId'] ?? 0,
      subcategoryId: json['subcategoryId'] ?? 0,
    );
  }
}

class ApiService {
  static const String baseUrl = 'https://offertree-backend.vercel.app';
  static String? _authToken;
  static int? _id;

  static Future<Map<String, dynamic>> get authToken async {
    if (_authToken == null) {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString('authToken');
    }
    return {
      'authToken': _authToken,
    };
  }

  static Future<int?> get userId async {
    if (_id == null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        _id = prefs.getInt('id');
      } catch (e) {
        return null;
      }
    }
    return _id;
  }

  static Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('authToken', token);
  }

  static Future<void> setuserId(int id) async {
    _id = id;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id);
  }

  //Login Api
  Future<ApiResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await setAuthToken(responseData['token']);
        await setuserId(responseData['id']);
        return ApiResponse(
          success: true,
          message: responseData['message'] ?? 'Login successful',
          data: responseData,
        );
      } else {
        return ApiResponse(
          success: false,
          message: responseData['message'] ??
              responseData['error'] ??
              'Login failed',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  //Location Api
  Future<ApiResponse> location(int id, String location) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/location'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': id,
          'location': location,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseData['token'] != null) {
          await setAuthToken(responseData['token']);
          await setuserId(responseData['id']);
        }
        return ApiResponse(
          success: true,
          message: responseData['message'] ?? 'Login successful',
          data: responseData,
        );
      } else {
        return ApiResponse(
          success: false,
          message: responseData['message'] ??
              responseData['error'] ??
              'Login failed',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  //Category Api
  Future<ApiResponse> category(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/category'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          message: responseData['message'] ?? 'Category fetched',
          data: responseData,
        );
      } else {
        return ApiResponse(
          success: false,
          message: responseData['message'] ??
              responseData['error'] ??
              'Category fetch failed',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  //Ads Api
  Future<ApiResponse> ads() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/ads'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<Ad> ads = (responseData['data'] as List)
            .map((ad) => Ad.fromJson(ad))
            .toList();

        return ApiResponse(
          success: true,
          message: responseData['message'] ?? 'Ads fetched successfully',
          data: {'ads': ads},
        );
      } else {
        return ApiResponse(
          success: false,
          message: responseData['message'] ??
              responseData['error'] ??
              'Ads fetch failed',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }
}
