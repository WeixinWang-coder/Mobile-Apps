import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'products_record.g.dart';

abstract class ProductsRecord
    implements Built<ProductsRecord, ProductsRecordBuilder> {
  static Serializer<ProductsRecord> get serializer =>
      _$productsRecordSerializer;

  @nullable
  @BuiltValueField(wireName: 'item_create_time')
  DateTime get itemCreateTime;

  @nullable
  @BuiltValueField(wireName: 'item_description')
  String get itemDescription;

  @nullable
  @BuiltValueField(wireName: 'item_name')
  String get itemName;

  @nullable
  @BuiltValueField(wireName: 'item_price')
  double get itemPrice;

  @nullable
  @BuiltValueField(wireName: 'item_image1')
  String get itemImage1;

  @nullable
  @BuiltValueField(wireName: 'item_image2')
  String get itemImage2;

  @nullable
  @BuiltValueField(wireName: 'item_image3')
  String get itemImage3;

  @nullable
  @BuiltValueField(wireName: 'item_image4')
  String get itemImage4;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(ProductsRecordBuilder builder) => builder
    ..itemDescription = ''
    ..itemName = ''
    ..itemPrice = 0.0
    ..itemImage1 = ''
    ..itemImage2 = ''
    ..itemImage3 = ''
    ..itemImage4 = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('products');

  static Stream<ProductsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<ProductsRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));

  ProductsRecord._();
  factory ProductsRecord([void Function(ProductsRecordBuilder) updates]) =
      _$ProductsRecord;

  static ProductsRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createProductsRecordData({
  DateTime itemCreateTime,
  String itemDescription,
  String itemName,
  double itemPrice,
  String itemImage1,
  String itemImage2,
  String itemImage3,
  String itemImage4,
}) =>
    serializers.toFirestore(
        ProductsRecord.serializer,
        ProductsRecord((p) => p
          ..itemCreateTime = itemCreateTime
          ..itemDescription = itemDescription
          ..itemName = itemName
          ..itemPrice = itemPrice
          ..itemImage1 = itemImage1
          ..itemImage2 = itemImage2
          ..itemImage3 = itemImage3
          ..itemImage4 = itemImage4));
