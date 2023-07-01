class Offer {
  final int id;
  final String title;
  final String description;

  const Offer(
      {required this.id, required this.title, required this.description});

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
        id: json['id'], title: json['otitle'], description: json['odesc']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'otitle': title,
        'odesc': description,
      };
}
