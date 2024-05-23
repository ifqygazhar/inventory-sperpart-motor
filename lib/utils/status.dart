enum Status {
  masuk,
  keluar,
}

String statusToString(Status status) {
  return status.toString().split('.').last;
}

Status statusFromString(String status) {
  return Status.values
      .firstWhere((e) => e.toString().split('.').last == status);
}
