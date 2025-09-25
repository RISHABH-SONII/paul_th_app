// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FilterStore on FilterStoreBase, Store {
  late final _$providerIdAtom =
      Atom(name: 'FilterStoreBase.providerId', context: context);

  @override
  List<int> get providerId {
    _$providerIdAtom.reportRead();
    return super.providerId;
  }

  @override
  set providerId(List<int> value) {
    _$providerIdAtom.reportWrite(value, super.providerId, () {
      super.providerId = value;
    });
  }

  late final _$typeIdAtom =
      Atom(name: 'FilterStoreBase.typeId', context: context);

  @override
  List<int> get typeId {
    _$typeIdAtom.reportRead();
    return super.typeId;
  }

  @override
  set typeId(List<int> value) {
    _$typeIdAtom.reportWrite(value, super.typeId, () {
      super.typeId = value;
    });
  }

  late final _$handymanIdAtom =
      Atom(name: 'FilterStoreBase.handymanId', context: context);

  @override
  List<int> get handymanId {
    _$handymanIdAtom.reportRead();
    return super.handymanId;
  }

  @override
  set handymanId(List<int> value) {
    _$handymanIdAtom.reportWrite(value, super.handymanId, () {
      super.handymanId = value;
    });
  }

  late final _$ratingIdAtom =
      Atom(name: 'FilterStoreBase.ratingId', context: context);

  @override
  List<int> get ratingId {
    _$ratingIdAtom.reportRead();
    return super.ratingId;
  }

  @override
  set ratingId(List<int> value) {
    _$ratingIdAtom.reportWrite(value, super.ratingId, () {
      super.ratingId = value;
    });
  }

  late final _$categoryIdAtom =
      Atom(name: 'FilterStoreBase.categoryId', context: context);

  @override
  List<int> get categoryId {
    _$categoryIdAtom.reportRead();
    return super.categoryId;
  }

  @override
  set categoryId(List<int> value) {
    _$categoryIdAtom.reportWrite(value, super.categoryId, () {
      super.categoryId = value;
    });
  }

  late final _$selectedSubCategoryIdAtom =
      Atom(name: 'FilterStoreBase.selectedSubCategoryId', context: context);

  @override
  int get selectedSubCategoryId {
    _$selectedSubCategoryIdAtom.reportRead();
    return super.selectedSubCategoryId;
  }

  @override
  set selectedSubCategoryId(int value) {
    _$selectedSubCategoryIdAtom.reportWrite(value, super.selectedSubCategoryId,
        () {
      super.selectedSubCategoryId = value;
    });
  }

  late final _$isPriceMaxAtom =
      Atom(name: 'FilterStoreBase.isPriceMax', context: context);

  @override
  String get isPriceMax {
    _$isPriceMaxAtom.reportRead();
    return super.isPriceMax;
  }

  @override
  set isPriceMax(String value) {
    _$isPriceMaxAtom.reportWrite(value, super.isPriceMax, () {
      super.isPriceMax = value;
    });
  }

  late final _$isPriceMinAtom =
      Atom(name: 'FilterStoreBase.isPriceMin', context: context);

  @override
  String get isPriceMin {
    _$isPriceMinAtom.reportRead();
    return super.isPriceMin;
  }

  @override
  set isPriceMin(String value) {
    _$isPriceMinAtom.reportWrite(value, super.isPriceMin, () {
      super.isPriceMin = value;
    });
  }

  late final _$searchAtom =
      Atom(name: 'FilterStoreBase.search', context: context);

  @override
  String get search {
    _$searchAtom.reportRead();
    return super.search;
  }

  @override
  set search(String value) {
    _$searchAtom.reportWrite(value, super.search, () {
      super.search = value;
    });
  }

  late final _$experienceAtom =
      Atom(name: 'FilterStoreBase.experience', context: context);

  @override
  String get experience {
    _$experienceAtom.reportRead();
    return super.experience;
  }

  @override
  set experience(String value) {
    _$experienceAtom.reportWrite(value, super.experience, () {
      super.experience = value;
    });
  }

  late final _$etudeAtom =
      Atom(name: 'FilterStoreBase.etude', context: context);

  @override
  String get etude {
    _$etudeAtom.reportRead();
    return super.etude;
  }

  @override
  set etude(String value) {
    _$etudeAtom.reportWrite(value, super.etude, () {
      super.etude = value;
    });
  }

  late final _$contratsAtom =
      Atom(name: 'FilterStoreBase.contrats', context: context);

  @override
  List<String> get contrats {
    _$contratsAtom.reportRead();
    return super.contrats;
  }

  @override
  set contrats(List<String> value) {
    _$contratsAtom.reportWrite(value, super.contrats, () {
      super.contrats = value;
    });
  }

  late final _$latitudeAtom =
      Atom(name: 'FilterStoreBase.latitude', context: context);

  @override
  String get latitude {
    _$latitudeAtom.reportRead();
    return super.latitude;
  }

  @override
  set latitude(String value) {
    _$latitudeAtom.reportWrite(value, super.latitude, () {
      super.latitude = value;
    });
  }

  late final _$longitudeAtom =
      Atom(name: 'FilterStoreBase.longitude', context: context);

  @override
  String get longitude {
    _$longitudeAtom.reportRead();
    return super.longitude;
  }

  @override
  set longitude(String value) {
    _$longitudeAtom.reportWrite(value, super.longitude, () {
      super.longitude = value;
    });
  }

  late final _$addToProviderListAsyncAction =
      AsyncAction('FilterStoreBase.addToProviderList', context: context);

  @override
  Future<void> addToProviderList({required int prodId}) {
    return _$addToProviderListAsyncAction
        .run(() => super.addToProviderList(prodId: prodId));
  }

  late final _$addToTypeListAsyncAction =
      AsyncAction('FilterStoreBase.addToTypeList', context: context);

  @override
  Future<void> addToTypeList({required int prodId}) {
    return _$addToTypeListAsyncAction
        .run(() => super.addToTypeList(prodId: prodId));
  }

  late final _$removeFromProviderListAsyncAction =
      AsyncAction('FilterStoreBase.removeFromProviderList', context: context);

  @override
  Future<void> removeFromProviderList({required int prodId}) {
    return _$removeFromProviderListAsyncAction
        .run(() => super.removeFromProviderList(prodId: prodId));
  }

  late final _$removeFromTypeListAsyncAction =
      AsyncAction('FilterStoreBase.removeFromTypeList', context: context);

  @override
  Future<void> removeFromTypeList({required int prodId}) {
    return _$removeFromTypeListAsyncAction
        .run(() => super.removeFromTypeList(prodId: prodId));
  }

  late final _$addToCategoryIdListAsyncAction =
      AsyncAction('FilterStoreBase.addToCategoryIdList', context: context);

  @override
  Future<void> addToCategoryIdList({required int prodId}) {
    return _$addToCategoryIdListAsyncAction
        .run(() => super.addToCategoryIdList(prodId: prodId));
  }

  late final _$addToContratListAsyncAction =
      AsyncAction('FilterStoreBase.addToContratList', context: context);

  @override
  Future<void> addToContratList({required String prodId}) {
    return _$addToContratListAsyncAction
        .run(() => super.addToContratList(prodId: prodId));
  }

  late final _$setSelectedSubCategoryAsyncAction =
      AsyncAction('FilterStoreBase.setSelectedSubCategory', context: context);

  @override
  Future<void> setSelectedSubCategory({required int catId}) {
    return _$setSelectedSubCategoryAsyncAction
        .run(() => super.setSelectedSubCategory(catId: catId));
  }

  late final _$removeFromCategoryIdListAsyncAction =
      AsyncAction('FilterStoreBase.removeFromCategoryIdList', context: context);

  @override
  Future<void> removeFromCategoryIdList({required int prodId}) {
    return _$removeFromCategoryIdListAsyncAction
        .run(() => super.removeFromCategoryIdList(prodId: prodId));
  }

  late final _$removeFromContratListAsyncAction =
      AsyncAction('FilterStoreBase.removeFromContratList', context: context);

  @override
  Future<void> removeFromContratList({required String prodId}) {
    return _$removeFromContratListAsyncAction
        .run(() => super.removeFromContratList(prodId: prodId));
  }

  late final _$addToHandymanListAsyncAction =
      AsyncAction('FilterStoreBase.addToHandymanList', context: context);

  @override
  Future<void> addToHandymanList({required int prodId}) {
    return _$addToHandymanListAsyncAction
        .run(() => super.addToHandymanList(prodId: prodId));
  }

  late final _$removeFromHandymanListAsyncAction =
      AsyncAction('FilterStoreBase.removeFromHandymanList', context: context);

  @override
  Future<void> removeFromHandymanList({required int prodId}) {
    return _$removeFromHandymanListAsyncAction
        .run(() => super.removeFromHandymanList(prodId: prodId));
  }

  late final _$addToRatingIdAsyncAction =
      AsyncAction('FilterStoreBase.addToRatingId', context: context);

  @override
  Future<void> addToRatingId({required int prodId}) {
    return _$addToRatingIdAsyncAction
        .run(() => super.addToRatingId(prodId: prodId));
  }

  late final _$removeFromRatingIdAsyncAction =
      AsyncAction('FilterStoreBase.removeFromRatingId', context: context);

  @override
  Future<void> removeFromRatingId({required int prodId}) {
    return _$removeFromRatingIdAsyncAction
        .run(() => super.removeFromRatingId(prodId: prodId));
  }

  late final _$clearFiltersAsyncAction =
      AsyncAction('FilterStoreBase.clearFilters', context: context);

  @override
  Future<void> clearFilters() {
    return _$clearFiltersAsyncAction.run(() => super.clearFilters());
  }

  late final _$FilterStoreBaseActionController =
      ActionController(name: 'FilterStoreBase', context: context);

  @override
  void setMaxPrice(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(
        name: 'FilterStoreBase.setMaxPrice');
    try {
      return super.setMaxPrice(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMinPrice(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(
        name: 'FilterStoreBase.setMinPrice');
    try {
      return super.setMinPrice(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearch(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(
        name: 'FilterStoreBase.setSearch');
    try {
      return super.setSearch(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setExperience(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(
        name: 'FilterStoreBase.setExperience');
    try {
      return super.setExperience(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEtude(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(
        name: 'FilterStoreBase.setEtude');
    try {
      return super.setEtude(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLatitude(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(
        name: 'FilterStoreBase.setLatitude');
    try {
      return super.setLatitude(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLongitude(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(
        name: 'FilterStoreBase.setLongitude');
    try {
      return super.setLongitude(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
providerId: ${providerId},
typeId: ${typeId},
handymanId: ${handymanId},
ratingId: ${ratingId},
categoryId: ${categoryId},
selectedSubCategoryId: ${selectedSubCategoryId},
isPriceMax: ${isPriceMax},
isPriceMin: ${isPriceMin},
search: ${search},
experience: ${experience},
etude: ${etude},
contrats: ${contrats},
latitude: ${latitude},
longitude: ${longitude}
    ''';
  }
}
