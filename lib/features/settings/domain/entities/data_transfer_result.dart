/// Domain entity representing data transfer outcome.
class DataTransferResult {
  final bool isSuccess;
  final String? message;
  final int? bytesTransferred;

  const DataTransferResult({
    required this.isSuccess,
    this.message,
    this.bytesTransferred,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataTransferResult &&
          runtimeType == other.runtimeType &&
          isSuccess == other.isSuccess &&
          message == other.message &&
          bytesTransferred == other.bytesTransferred;

  @override
  int get hashCode => Object.hash(isSuccess, message, bytesTransferred);
}
