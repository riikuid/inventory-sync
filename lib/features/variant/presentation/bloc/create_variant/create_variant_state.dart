part of 'create_variant_cubit.dart';

enum CreateVariantStatus { initial, loading, success, failure }

class CreateVariantState extends Equatable {
  final String? rackId;
  final String? rackName;

  final String? brandId;
  final String? brandName;

  final String name;
  final String? uom;
  final String? specification;
  final String? manufCode;

  final String autoBase; // base otomatis (productName)
  final bool userEdited; // apakah user sudah mengedit manual

  final List<String> photos;

  final CreateVariantStatus status;
  final String? errorMessage;

  const CreateVariantState({
    required this.rackId,
    required this.rackName,
    required this.brandId,
    required this.brandName,
    required this.name,
    required this.uom,
    required this.specification,
    required this.manufCode,
    required this.photos,
    required this.status,
    required this.errorMessage,
    required this.autoBase,
    required this.userEdited,
  });

  factory CreateVariantState.initial({String autoBase = ''}) =>
      CreateVariantState(
        rackId: null,
        rackName: null,
        brandId: null,
        brandName: "Tanpa Brand",
        name: "",
        uom: null,
        specification: null,
        manufCode: null,
        photos: [],
        status: CreateVariantStatus.initial,
        errorMessage: null,
        autoBase: autoBase,
        userEdited: false,
      );

  CreateVariantState copyWith({
    String? rackId,
    String? rackName,
    String? brandId,
    String? brandName,
    String? name,
    String? uom,
    String? specification,
    String? manufCode,
    List<String>? photos,
    CreateVariantStatus? status,
    String? errorMessage,
    String? autoBase,
    bool? userEdited,
  }) {
    return CreateVariantState(
      rackId: rackId ?? this.rackId,
      rackName: rackName ?? this.rackName,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      name: name ?? this.name,
      uom: uom ?? this.uom,
      specification: specification ?? this.specification,
      manufCode: manufCode ?? this.manufCode,
      photos: photos ?? this.photos,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      autoBase: autoBase ?? this.autoBase,
      userEdited: userEdited ?? this.userEdited,
    );
  }

  @override
  List<Object?> get props => [
    rackId,
    brandId,
    name,
    uom,
    specification,
    manufCode,
    photos,
    status,
    autoBase,
    userEdited,
  ];
}
