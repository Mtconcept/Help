class Claim {
  final String name;
  final int gender;
  final int age;
  final String claim;
  final String dateTime;
  final String userId;

  Claim({
    this.name,
    this.gender,
    this.age,
    this.claim,
    this.dateTime,
    this.userId,
  });

  Map<String, dynamic> toJson() => {
        "age": age,
        "claim": claim,
        "gender": gender,
        "name": name,
        "datetime": dateTime,
        "userId": userId,
      };
}
