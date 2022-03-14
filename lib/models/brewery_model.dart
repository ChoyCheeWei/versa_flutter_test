class BreweryModel {
  String? id;
  String? name;
  String? type;
  String? street;
  String? address_2;
  String? address_3;
  String? city;
  String? state;
  String? county_province;
  String? postal_code;
  String? country;
  String? longitude;
  String? latitude;
  String? phone;
  String? website_url;
  String? updated_at;
  String? created_at;
  bool? isFavorite;

  BreweryModel({
    this.id,
    this.name,
    this.type,
    this.street,
    this.address_2,
    this.address_3,
    this.city,
    this.state,
    this.county_province,
    this.postal_code,
    this.country,
    this.longitude,
    this.latitude,
    this.phone,
    this.website_url,
    this.updated_at,
    this.created_at,
    this.isFavorite,
  });
  factory BreweryModel.fromJson(Map<String, dynamic> json) =>
      BreweryModel(
        id: json['id'],
        name: json['name'],
        type: json['brewery_type'],
        street: json['street'],
        address_2: json['address_2'],
        address_3: json['address_3'],
        city: json['city'],
        state: json['state'],
        county_province: json['county_province'],
        postal_code: json['postal_code'],
        country: json['country'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        phone: json['phone'],
        website_url: json['website_url'],
        updated_at: json['updated_at'],
        created_at: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
    'id': id ?? '',
    'name': name ?? '',
    'brewery_type':type ?? '',
    'street':street ?? '',
    'address_2':address_2 ?? '',
    'address_3':address_3 ?? '',
    'city':city ?? '',
    'state':state ?? '',
    'county_province':county_province ?? '',
    'postal_code':postal_code ?? '',
    'country':country ?? '',
    'latitude':latitude ?? '',
    'longitude':longitude ?? '',
    'phone':phone ?? '',
    'website_url':website_url ?? '',
    'updated_at':updated_at ?? '',
    'created_at':created_at ?? '',
  };
}
