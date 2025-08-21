class Labour {
  final String id;
  final String name;
  final int age;
  final String expertise;

  Labour({
    required this.id,
    required this.name,
    required this.age,
    required this.expertise,
  });

  factory Labour.fromJson(Map<String, dynamic> json) {
    return Labour(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      expertise: json['expertise'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'expertise': expertise,
    };
  }
}


