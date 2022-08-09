import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/constants/data_keys.dart';
import 'package:test2/data/item_model.dart';
class ItemService {


  static final ItemService _itemService =
      ItemService._internal(); //하나의 instance만 생성해주기 위해서는 이렇게 해줘야한다
  factory ItemService() => _itemService;

  ItemService._internal();

  Future createdNewItem(ItemModel itemModel,String itemKey,String userKey) async{
    DocumentReference<Map<String,dynamic>> documentReference=FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);

    DocumentReference<Map<String, dynamic>> userItemDocReference = //user에도 items collection을 새로 만들어 여기에 그 정보들을 추가적으로 넣어준다
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey).collection(COL_USER_ITEMS).doc(itemKey);

    final DocumentSnapshot documentSnapshot=await documentReference.get();
    if(!documentSnapshot.exists){
     // await documentReference.set(json);
      await FirebaseFirestore.instance.runTransaction((transaction) async{ //transaction에서는 기다리는 async가 필요하다
        transaction.set(documentReference, itemModel.toJson()); //transaciton은 데이터를이렇게 넣어준다
        transaction.set(userItemDocReference, itemModel.toMinJson()); //줄어든 데이터 minJson을 userItem에 이렇게 넣어준다
      });
    }
  }
  Future<void> toggleLike(String userKey,String itemKey,ItemModel itemModel) async{
    final DocumentReference documentReference=FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    final DocumentSnapshot documentSnapshot=await documentReference.get();
    if(documentSnapshot.exists){
      if((documentSnapshot.data() as Map<String,dynamic>)['heartNumber'].contains(userKey)){
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          //transaction.set(documentReference, itemModel.toJson());
           transaction.update(documentReference,
              {'heartNumber': FieldValue.arrayRemove([userKey])});
        });
      }
      else {
        //documentReference.update({'heartNumber':FieldValue.arrayUnion([userKey])});
        await FirebaseFirestore.instance.runTransaction((transaction) async {
         // transaction.set(documentReference, itemModel.toJson());
          transaction.update(documentReference,
              {'heartNumber': FieldValue.arrayUnion([userKey])});
        });
      }
    }

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
        await collectionReference.
            orderBy("createdDate",
            descending: false).get(); //시간순서대로 가져오기

    List<ItemModel> items = [];
    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      items.add(itemModel);
    }
    return items;
  }


  Future<List<ItemModel>> getUserItems(String userKey) async { //한 유저가 저장한 item들을 가져오기 ,itemKey로 현재의 item이 보이지 않도록 해줌
    //colleciton을 가져와서 그 안에 있는 모든 documents 들을 list로 받아오기
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey).collection(COL_USER_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference
        .get(); //get 을 통해 collection 내 document들을 받아오는데 이때 get은 future
    List<ItemModel> items = []; //ItemModel을 받아오는 list
    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
     // if(itemKey==null||itemKey!=itemModel.itemKey) //itemKey가 null 이거나 itemKey가 itemModel의 itemKey와 다를때만 넣어준다
        items.add(itemModel);
    }
    return items;
  }
}
