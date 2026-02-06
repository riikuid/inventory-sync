part of 'edit_variant_cubit.dart';

enum EditVariantStatus { initial, loading, loaded, success, failure }

class EditVariantState extends Equatable {
  final String? rackId;
  final String? rackName;

  final String? brandId;
  final String? brandName;

  final String name;
  final String? uom;
  final String? uomId;
  final List<Uom> uomList;
  final String? specification;
  final String? manufCode;

  final String autoBase;
  final bool userEdited;

  final List<PhotoRow> photos;

  final EditVariantStatus status;
  final String? errorMessage;

  const EditVariantState({
    required this.rackId,
    required this.rackName,
    required this.brandId,
    required this.brandName,
    required this.name,
    required this.uom,
    required this.uomId,
    required this.uomList,
    required this.specification,
    required this.manufCode,
    required this.photos,
    required this.status,
    required this.errorMessage,
    required this.autoBase,
    required this.userEdited,
  });

  factory EditVariantState.initial({String autoBase = ''}) => EditVariantState(
    rackId: null,
    rackName: null,
    brandId: null,
    brandName: "Tanpa Brand",
    name: "",
    uom: null,
    uomId: null,
    uomList: [],
    specification: null,
    manufCode: null,
    photos: [],
    status: EditVariantStatus.initial,
    errorMessage: null,
    autoBase: autoBase,
    userEdited: false,
  );

  EditVariantState copyWith({
    String? rackId,
    String? rackName,
    String? brandId,
    String? brandName,
    String? name,
    String? uom,
    String? uomId,
    List<Uom>? uomList,
    String? specification,
    String? manufCode,
    List<PhotoRow>? photos,
    EditVariantStatus? status,
    String? errorMessage,
    String? autoBase,
    bool? userEdited,
  }) {
    return EditVariantState(
      rackId: rackId ?? this.rackId,
      rackName: rackName ?? this.rackName,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      name: name ?? this.name,
      uom: uom ?? this.uom,
      uomId: uomId ?? this.uomId,
      uomList: uomList ?? this.uomList,
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
    uomId,
    uomList,
    specification,
    manufCode,
    photos,
    status,
    autoBase,
    userEdited,
  ];
}
