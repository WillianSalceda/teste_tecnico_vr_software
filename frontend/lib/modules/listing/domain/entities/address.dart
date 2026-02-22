class Address {
  const Address({
    this.cep = '',
    this.street = '',
    this.number,
    this.complement,
    this.neighborhood = '',
    this.city = '',
    this.state = '',
  });

  final String cep;
  final String street;
  final String? number;
  final String? complement;
  final String neighborhood;
  final String city;
  final String state;

  bool get isComplete =>
      street.isNotEmpty &&
      neighborhood.isNotEmpty &&
      city.isNotEmpty &&
      state.isNotEmpty;
}
