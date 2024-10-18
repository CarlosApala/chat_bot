abstract class SerialCodeRepository {
  Future<bool> verifySerialCode(String serialCode);
  Future<bool> hasValidSerial();
}
