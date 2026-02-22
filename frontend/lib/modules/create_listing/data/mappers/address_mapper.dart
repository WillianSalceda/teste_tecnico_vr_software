import '../../domain/entities/address.dart';

extension AddressMapper on Address {
  static Address fromJson(Map<String, dynamic> json) => Address(
    cep: json['cep'] as String? ?? '',
    street: json['street'] as String? ?? json['logradouro'] as String? ?? '',
    number: json['number'] as String?,
    complement: json['complement'] as String?,
    neighborhood:
        json['neighborhood'] as String? ?? json['bairro'] as String? ?? '',
    city: json['localidade'] as String? ?? json['city'] as String? ?? '',
    state: json['uf'] as String? ?? json['state'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'cep': cep,
    'street': street,
    if (number != null && number!.isNotEmpty) 'number': number,
    if (complement != null && complement!.isNotEmpty) 'complement': complement,
    'neighborhood': neighborhood,
    'city': city,
    'state': state,
  };
}
