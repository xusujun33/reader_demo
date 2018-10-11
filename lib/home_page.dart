import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeReader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeReaderState();
}

class HomeReaderState extends State<HomeReader> {
  final String title = '最新博文';
  int _page = 1;
  String _loadUrl = 'http://www.wanandroid.com/article/list/0/json';

  List listDatasAll = [];
  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;

  //var subjects;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    _loadData();
    _scrollController.addListener((){
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
  }

  //下载数据
  _loadData() async {
    List listDatas = [];
    http.Response response = await http.get(_loadUrl);
    print(_loadUrl);
    var result = json.decode(response.body);
    listDatas = result['data']['datas'];
    setState(() {
      listDatasAll = listDatas;
    });
  }

  //上滑加载新的数据
  Future _getMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      String _loadUrl =
          'http://www.wanandroid.com/article/list/' + '$_page' + '/json';
      http.Response response = await http.get(_loadUrl);
      var result = json.decode(response.body);
      setState(() {
        listDatasAll.addAll(result['data']['datas']);
        isLoading = true;
      });
      _page += 1;
    }
  }

  //上滑加载中控件
  _getMoreWidget() {
    return new Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: new Text(
        '数据正在加载中...',
        style: new TextStyle(fontSize: 12.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new CupertinoPageScaffold(
      navigationBar: new CupertinoNavigationBar(
        middle: new Text(title),
      ),
      child: new Center(
        child: getArticle(),
      ),
    );
  }

  getArticle() {
    if (listDatasAll.length != 0) {
      return new ListView.builder(
        controller: _scrollController,
        itemCount: listDatasAll.length + 1,
        itemBuilder: (context, index) {
          if (index < listDatasAll.length) {
            print('执行了 $index 次');
            return articlesItem(listDatasAll[index]);
          } else {
            return _getMoreWidget();
          }
        },
      );
    } else {
      return new CupertinoActivityIndicator();
    }
  }

  articlesItem(var list) {
    var authorRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          '作者：${list['author']}',
          style: new TextStyle(
            fontSize: 13.0,
          ),
        ),
      ],
    );

    var articleRow = Container(
      alignment: Alignment.centerLeft,
      child: new Text(
        '${list['title']}',
        style: new TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700),
        maxLines: 2,
      ),
    );

    var row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text(
          '分类：${list['superChapterName']}',
          style: new TextStyle(
            fontSize: 12.0,
          ),
        ),
        new Text(
          '时间：${list['niceDate']}',
          style: new TextStyle(fontSize: 12.0),
        ),
      ],
    );

    var articleColumn = Container(
      height: 100.0,
      padding: const EdgeInsets.all(5.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          authorRow,
          articleRow,
          row,
        ],
      ),
    );

    return new Card(
      child: articleColumn,
    );
  }
}
