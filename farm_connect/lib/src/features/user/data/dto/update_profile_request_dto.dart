class UpdateProfileRequestDto {
  final String fullName;
  final String? phone;
  final String? location;
  final String? address;
  final String? bio;
  final String? language;

  const UpdateProfileRequestDto({
    required this.fullName,
    this.phone,
    this.location,
    this.address,
    this.bio,
    this.language,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fullName': fullName,
      if (_hasValue(phone)) 'phone': phone,
      if (_hasValue(location)) 'location': location,
      if (_hasValue(address)) 'address': address,
      if (_hasValue(bio)) 'bio': bio,
      if (_hasValue(language)) 'language': language,
    };
  }
}

bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;
