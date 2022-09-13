import '../backend/backend.dart';
import '../components/new_post_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../post_detail/post_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BrowerPostWidget extends StatefulWidget {
  const BrowerPostWidget({Key key}) : super(key: key);

  @override
  _BrowerPostWidgetState createState() => _BrowerPostWidgetState();
}

class _BrowerPostWidgetState extends State<BrowerPostWidget> {
  PagingController<DocumentSnapshot, ProductsRecord> _pagingController =
      PagingController(firstPageKey: null);
  List<StreamSubscription> _streamSubscriptions = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((nextPageMarker) {
      queryProductsRecordPage(
        queryBuilder: (productsRecord) =>
            productsRecord.orderBy('item_create_time', descending: true),
        nextPageMarker: nextPageMarker,
        pageSize: 25,
        isStream: true,
      ).then((page) {
        _pagingController.appendPage(
          page.data,
          page.nextPageMarker,
        );
        final streamSubscription = page.dataStream?.listen((data) {
          final itemIndexes = _pagingController.itemList
              .asMap()
              .map((k, v) => MapEntry(v.reference.id, k));
          data.forEach((item) {
            final index = itemIndexes[item.reference.id];
            if (index != null) {
              _pagingController.itemList.replaceRange(index, index + 1, [item]);
            }
          });
          setState(() {});
        });
        _streamSubscriptions.add(streamSubscription);
      });
    });
  }

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FloatingActionButton pressed ...');
        },
        backgroundColor: Color(0xFF060000),
        elevation: 8,
        child: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.add,
            color: Color(0xFFF7F7F7),
            size: 30,
          ),
          onPressed: () async {
            await showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    height: 610,
                    child: NewPostWidget(),
                  ),
                );
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: Image.network(
                      'https://cdn.forumcomm.com/dims4/default/8f0c458/2147483647/strip/true/crop/6000x2917+0+542/resize/1440x700!/quality/90/?url=https%3A%2F%2Ffcc-cue-exports-brightspot.s3.us-west-2.amazonaws.com%2Fpostbulletin%2Fbinary%2F050621.100-MILE-GARAGE-SALE.004_1_binary_7017824.jpg',
                    ).image,
                  ),
                  shape: BoxShape.rectangle,
                ),
                alignment: AlignmentDirectional(0, 0),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 20),
                      child: Text(
                        'Inventory',
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Poppins',
                              color: Color(0xC3009688),
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                  child:
                      PagedListView<DocumentSnapshot<Object>, ProductsRecord>(
                    pagingController: _pagingController,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    builderDelegate: PagedChildBuilderDelegate<ProductsRecord>(
                      // Customize what your widget looks like when it's loading the first page.
                      firstPageProgressIndicatorBuilder: (_) => Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primaryColor,
                          ),
                        ),
                      ),

                      itemBuilder: (context, _, listViewIndex) {
                        final listViewProductsRecord =
                            _pagingController.itemList[listViewIndex];
                        return StreamBuilder<ProductsRecord>(
                          stream: ProductsRecord.getDocument(
                              listViewProductsRecord.reference),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryColor,
                                  ),
                                ),
                              );
                            }
                            final listItemCardProductsRecord = snapshot.data;
                            return InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostDetailWidget(
                                      itemPostDetails:
                                          listItemCardProductsRecord.reference,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  boxShadow: [
                                    BoxShadow(
                                      color: FlutterFlowTheme.of(context)
                                          .tertiaryColor,
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            valueOrDefault<String>(
                                              listViewProductsRecord.itemImage1,
                                              'data:image/jpeg;base64,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',
                                            ),
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 0, 0, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                10, 5, 0, 4),
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        listViewProductsRecord
                                                            .itemName,
                                                        'Display Item',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .title1
                                                          .override(
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                10, 0, 0, 0),
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        formatNumber(
                                                          listViewProductsRecord
                                                              .itemPrice,
                                                          formatType: FormatType
                                                              .decimal,
                                                          decimalType:
                                                              DecimalType
                                                                  .automatic,
                                                          currency: '\$',
                                                        ),
                                                        '\$00.00',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .title3
                                                          .override(
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
