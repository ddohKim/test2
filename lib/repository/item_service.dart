import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/constants/data_keys.dart';
import 'package:test2/data/item_model.dart';

class ItemService {
  static final ItemService _itemService =
      ItemService._internal(); //하나의 instance만 생성해주기 위해서는 이렇게 해줘야한다
  factory ItemService() => _itemService;

  ItemService._internal();

  Future createdNewItem( String itemKey,ItemModel itemModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();
    DocumentReference<Map<String, dynamic>> heartNumber =
    FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    if (!documentSnapshot.exists) {
      await documentReference.set(itemModel.toJson());
    }
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, itemModel.toJson());
      transaction
          .update(heartNumber, {'heartNumber': itemModel.heartNumber});
    });
  }



  Future<ItemModel> getItem(String itemKey) async {
    //firebase에서 userModel 가져오기
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();
    ItemModel itemModel = ItemModel.fromSnapshot(documentSnapshot);
    return itemModel;
  }

  Future<List<ItemModel>> getItems() async {
    //document가 아니라 collection을 가져오는것
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection(COL_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots =
        await collectionReference.get();

    List<ItemModel> items = [];
    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      items.add(itemModel);
    }
    return items;
  }
}
