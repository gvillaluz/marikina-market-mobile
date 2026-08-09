enum Role {
  admin('Admin'),
  enforcer('Enforcer'),
  vendor('Vendor');

  final String value;
  const Role(this.value);
  
  static Role fromValue(String value) {
    return Role.values.firstWhere(
      (role) => role.value == value,
      orElse: () => throw ArgumentError('Unknown role: $value'),
    );
  }
}