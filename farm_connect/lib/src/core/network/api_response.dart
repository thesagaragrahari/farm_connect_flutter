class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? errorCode;
  final DateTime? timestamp;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errorCode,
    this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? raw) parseData,
  ) {
    return ApiResponse<T>(
      success: json['success'] is bool ? json['success'] as bool : true,
      message: (json['message'] ?? json['msg'] ?? '').toString(),
      data: parseData(json['data']),
      errorCode: _stringOrNull(json['errorCode']),
      timestamp: DateTime.tryParse((json['timestamp'] ?? '').toString()),
    );
  }
}

String? _stringOrNull(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}
