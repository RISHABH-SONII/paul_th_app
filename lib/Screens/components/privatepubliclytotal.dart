import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/PostInformation.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/utls.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class GridGalleryPublicTotal extends StatefulWidget {
  final bool showOverlays;
  final User theuser;

  GridGalleryPublicTotal({required this.showOverlays, required this.theuser});

  @override
  _GridGalleryPublicTotalState createState() => _GridGalleryPublicTotalState();
}

class _GridGalleryPublicTotalState extends State<GridGalleryPublicTotal> {
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;
  final int _itemsPerPage = 15;
  List<String> _imageList = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });
    setState(() {
      _imageList = _getPaginatedData(_currentPage);
      _isLoading = false;
    });
  }

  void _loadMoreData() async {
    if (_isLoading || _imageList.length >= widget.theuser.privates!.length)
      return;
    setState(() {
      _isLoading = true;
    });
    setState(() {
      _currentPage++;
      _imageList.addAll(_getPaginatedData(_currentPage));
      _isLoading = false;
    });
  }

  List<String> _getPaginatedData(int page) {
    int startIndex = (page - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    if (endIndex > widget.theuser.privates!.length) {
      endIndex = widget.theuser.privates!.length;
    }
    return widget.theuser.privates!.sublist(startIndex, endIndex);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadMoreData();
    }
  }

  void _toggleOverlay(int index, isVideo, mediaId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return PostInformation(
              play: true, isVideo: isVideo, mediaId: mediaId);
        });
  }

  @override
  Widget build(BuildContext context) {
    return _buildPostList(context: context, thelist: _imageList);
  }

  Widget _buildPostList(
      {required List<String>? thelist, required BuildContext context}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * .85,
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: MediaQuery.of(context).size.aspectRatio * 1.5,
              crossAxisSpacing: 4,
              padding: EdgeInsets.all(10),
              controller: _scrollController,
              children: List.generate(thelist!.length, (index) {
                var isVideo = "${thelist[index]}".contains("fed");
                var thecorectUrl = isVideo
                    ? videoUrl(thelist[index], thumbnail: true, jaipaye: true)!
                    : imageUrl(thelist[index], jaipaye: true)!;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  shadowColor: primaryColor,
                  elevation: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: GestureDetector(
                      onTap: () =>
                          _toggleOverlay(index, isVideo, thelist[index]),
                      child: Container(
                        decoration: BoxDecoration(
                          color: white,
                        ),
                        child: Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                              height: MediaQuery.of(context).size.height * .2,
                              fit: BoxFit.cover,
                              imageUrl: thecorectUrl,
                              useOldImageOnUrlChange: false,
                              cacheManager: CacheManager(
                                Config(
                                  'no_cache',
                                  stalePeriod: Duration(days: 0), // No cache
                                  maxNrOfCacheObjects: 0, // No cache objects
                                ),
                              ),
                              placeholder: (context, url) => loadingImage(),
                              errorWidget: (context, url, error) =>
                                  errorImage(),
                            ).paddingAll(4),
                            if (isVideo)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 25,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
