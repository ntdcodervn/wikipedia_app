import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikipedia_app/base/base_state.dart';
import 'package:wikipedia_app/data/model/error/search_error.dart';
import 'package:wikipedia_app/data/model/local_model/wikipedia.dart';
import 'package:wikipedia_app/data/model/response/search_response.dart';
import 'package:wikipedia_app/routes/navigation.dart';
import 'package:wikipedia_app/ui/components/loading.dart';
import 'package:wikipedia_app/ui/modules/bookmark/view/bookmark_page.dart';
import 'package:wikipedia_app/ui/modules/home/contract/home_contract.dart';
import 'package:wikipedia_app/ui/modules/home/view_model/home_view_model.dart';
import 'package:wikipedia_app/ui/modules/wikipedia_detail/view/wikipedia_detail.dart';
import 'package:wikipedia_app/ui/components/box_search_textfield.dart';
import 'package:wikipedia_app/ui/components/item_wikipedia.dart';
import 'package:wikipedia_app/utils/check_internet.dart';
import 'package:wikipedia_app/values/strings.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> implements HomeContract {
  HomeViewModel mModel;
  List<String> histories = [];

  @override
  void initState() {
    super.initState();
    mModel = Provider.of<HomeViewModel>(context, listen: false);
    mModel.contract = this;
    mModel.getWikiesLocal(20);

  }

  void onGoBack() {
    mModel.getWikiesLocal(20);
  }

  @override
  Widget buildWidget() {
    return Consumer<HomeViewModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: LoadingWidget(
            message: please_wait,
            status: model.isLoadData,
            child: _buildBody(model),
          ),
        ),
      );
    });
  }

  Widget _buildBody(HomeViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildSearch(model),
        model.searchResponse != null && model.searchResponse.pages != null
            ? _buildListWiki(model.searchResponse.pages)
            : Container()
      ],
    );
  }

  Widget _buildSearch(HomeViewModel model) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey[200]),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ]),
      padding: EdgeInsets.only(left: 15, right: 15, top: 60, bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: BoxSearchTextField(
              controller: model.searchTextController,
              hintText: search_hint_text,
              onSearch: (value) {
                model.onSearch();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.bookmark_outline),
            color: Colors.grey[500],
            onPressed: () {
              Route route = MaterialPageRoute(builder: (context) => Bookmark());
              Navigator.push(context, route).then((value) => onGoBack());
            },
          )
        ],
      ),
    );
  }

  Widget _buildListWiki(List<Wikipedia> wikipedia) {
    return Expanded(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: wikipedia.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      checkInterNet().then((value) {
                        if (value != null && value) {
                          pushWithAnimation(
                              context,
                              WikiDetailPage(
                                  title: wikipedia[index].title,
                                  wikipediaDetail: wikipedia[index]));
                        } else {
                          showDialog();
                        }
                      });
                    },
                    child: ItemWikipediaWidget(wikipedia: wikipedia[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onSearchError(SearchError error) {
    mModel.searchError();
  }

  @override
  void onSearchSuccess(SearchResponse response) {
    mModel.searchSuccess(response);
  }

  void showDialog() {
    return showDialogBox(please_connect, error, <Widget>[
      FlatButton(
        onPressed: () {
          pop(context);
        },
        child: Text(close, style: TextStyle(color: Colors.blueAccent)),
      )
    ]);
  }
}

class TagItem extends StatelessWidget {
  final label;
  final active;
  const TagItem({
    Key key,
    this.label,
    this.active = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          color: !active ? Colors.grey[200] : Colors.amber,
          child: OutlineButton(
            padding: EdgeInsets.zero,
            borderSide: BorderSide.none,
            onPressed: () {},
            child: Text('$label'),
          ),
        ),
      ),
    );
  }
}
