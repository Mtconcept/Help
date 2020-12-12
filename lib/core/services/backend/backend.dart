import '../../models/claim.dart';

abstract class Backend {
  Future<String> sendClaim(Claim claim);
}
