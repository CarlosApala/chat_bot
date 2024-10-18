import '../repositories/serial_code_repository.dart';

class VerifySerialCode {
  final SerialCodeRepository repository;

  VerifySerialCode(this.repository);

  Future<bool> execute(String serialCode) {
    return repository.verifySerialCode(serialCode);
  }
   Future<bool> hasCodeSerial() {
    return repository.hasValidSerial();
  }
}
