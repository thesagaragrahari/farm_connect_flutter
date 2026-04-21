import 'package:dio/dio.dart';
import '../dto/login_request_dto.dart';
import '../dto/signup_request_dto.dart';
import '../dto/login_response_dto.dart';
import '../dto/profile_response_dto.dart';

class AuthApiService {
  final Dio dio;
  AuthApiService(this.dio);

  Future<LoginResponseDto> login(LoginRequestDto dto) async {
    final res = await dio.post('api/auth/login', data: dto.toJson());
    return LoginResponseDto.fromJson(res.data);
  }

  Future<LoginResponseDto> signup(SignupRequestDto dto) async {
    final path = dto.role == 'worker' ? '/register/worker' : '/register/farmer';
    final res = await dio.post(path, data: dto.toJson());
    return LoginResponseDto.fromJson(res.data);
  }

  Future<ProfileResponseDto> me() async {
    final res = await dio.get('/get/me');
    return ProfileResponseDto.fromJson(res.data);
  }
}