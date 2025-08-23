import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/entra_id_hash_utils.dart';

void main() {
  group('AortemEntraIdHashUtils', () {
    test('should hash data using SHA256', () {
      final input = 'hello_world';
      final hash = AortemEntraIdHashUtils.hashSHA256(input);

      expect(hash, isNotEmpty);
    });

    test('should produce consistent hash for the same input', () {
      final input = 'consistent_data';
      final hash1 = AortemEntraIdHashUtils.hashSHA256(input);
      final hash2 = AortemEntraIdHashUtils.hashSHA256(input);

      expect(hash1, equals(hash2));
    });

    test('should validate hashed data successfully', () {
      final input = 'validate_this';
      final hash = AortemEntraIdHashUtils.hashSHA256(input);
      final isValid = AortemEntraIdHashUtils.validateSHA256(input, hash);

      expect(isValid, isTrue);
    });

    test('should return false for invalid hashed data', () {
      final input = 'invalid_check';
      final hash = AortemEntraIdHashUtils.hashSHA256(input);
      final isValid = AortemEntraIdHashUtils.validateSHA256('wrong_data', hash);

      expect(isValid, isFalse);
    });

    test('should throw an error for empty input', () {
      expect(() => AortemEntraIdHashUtils.hashSHA256(''), throwsArgumentError);
    });
  });
}
