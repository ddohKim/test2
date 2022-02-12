import 'package:flutter/material.dart';
import 'package:test2/pages/home_page/upload_page.dart';
import 'package:test2/provider/page_notifier.dart';
import 'package:test2/states/category_notifier.dart';
import 'package:provider/provider.dart';

class CategoryInputPage extends StatelessWidget {
  const CategoryInputPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        elevation: 2,
        leading: TextButton(
          style: TextButton.styleFrom(
              primary: Colors.black54, //클릭했을때 색깔 나오도록
              backgroundColor: Theme
                  .of(context)
                  .appBarTheme
                  .backgroundColor),
          child: Text(
            '뒤로',
            style: Theme
                .of(context)
                .textTheme
                .bodyText2,
          ),
          onPressed: () {
            Navigator.pop(context); //뒤로가기 버튼 만들기
          },
        ),
        title: Text(
          '카테고리 선택',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                context.read<CategoryNotifier>().setNewCategory(
                    CategoryNotifier.categories.elementAt(index));
                Navigator.pop(context);
              },
              title: Text(
                CategoryNotifier.categories.elementAt(index),
                style: TextStyle(
                    color: context.read<CategoryNotifier>().currentCategory ==
                            CategoryNotifier.categories.elementAt(index)
                        ? Theme.of(context).primaryColor
                        : Colors.black87),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[300],
            );
          },
          itemCount: CategoryNotifier.categories.length),
    );
  }
}
