enum PaymentType {
  cash,
  check,
  visa,
}
List<PaymentType> typeOptions = [
  PaymentType.cash,
  PaymentType.check,
  PaymentType.visa,
];

int paymentt(PaymentType value) {
  switch (value) {
    case PaymentType.cash:
      return 0;
    case PaymentType.check:
      return 1;
    case PaymentType.visa:
      return 2;
    default:
      return 3;
  }
}
String paymentTypeToString(PaymentType type) {
  switch (type) {
    case PaymentType.cash:
      return 'Cash';
    case PaymentType.check:
      return 'Check';
    case PaymentType.visa:
      return 'Visa';
  }
}
