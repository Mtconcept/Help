class Claim {
  final String name;
  final int gender;
  final String age;
  final String claim;
  final int dateTime;

  Claim({
    this.name,
    this.gender,
    this.age,
    this.claim,
    this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        "age": int.parse(age),
        "claim": claim,
        "gender": gender,
        "name": name,
        "datetime": dateTime,
      };
}
