import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/PostInformation.dart';
import 'package:tharkyApp/Screens/Profile/PostDescriptor.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/utls.dart';

class GridGallery extends StatefulWidget {
  final List<String> thelist;

  GridGallery({required this.thelist});

  @override
  _GridGalleryState createState() => _GridGalleryState();
}

class _GridGalleryState extends State<GridGallery> {
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;
  final int _itemsPerPage = 15;
  List<String> _imageList = [];
  List<bool> _showOverlays = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();

    _scrollController.addListener(_onScroll);
    _showOverlays = List.generate(widget.thelist.length, (_) => false);
  }

  @override
  void didUpdateWidget(covariant GridGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.thelist != oldWidget.thelist) {
      if (widget.thelist.length > oldWidget.thelist.length) {
        _showOverlays.add(false);
      }
      _loadInitialData();
    }
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

  // Simule le chargement de plus de données
  void _loadMoreData() async {
    if (_isLoading || _imageList.length >= widget.thelist.length) return;
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
    if (endIndex > widget.thelist.length) {
      endIndex = widget.thelist.length;
    }
    return widget.thelist.sublist(startIndex, endIndex);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadMoreData();
    }
  }

  Timer? _timer;

  void _toggleOverlay(int index) {
    setState(() {
      for (int i = 0; i < _showOverlays.length; i++) {
        _showOverlays[i] = i == index ? !_showOverlays[i] : false;
      }
    });
    if (_showOverlays[index]) {
      _startTimer(index);
    } else {
      _cancelTimer();
    }
  }

  void _startTimer(int index) {
    _cancelTimer();
    _timer = Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showOverlays[index] = false;
        });
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showOverlays = List.generate(widget.thelist.length, (_) => false);
        });
        _cancelTimer();
      },
      child: _buildPostList(context: context, thelist: _imageList),
    );
  }

  Widget _buildPostList(
      {required List<String>? thelist, required BuildContext context}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "To appear in swipes, you must add at least one photo to 'My Posts'. Only photos from 'My Posts' will be displayed to others.",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ).paddingAll(50),
          Container(
            alignment:
                thelist!.length == 0 ? Alignment.topCenter : Alignment.center,
            height: MediaQuery.of(context).size.height * .85,
            width: MediaQuery.of(context).size.width,
            child: thelist!.length == 0
                ? Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "asset/icons/ic_swipe_tab.png",
                          width: 80,
                          height: 80,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'No Photos Added Yet!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Your profile looks a bit empty. Add some photos to stand out and attract more matches!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        20.height,
                        ElevatedButton(
                          onPressed: () {
                            Rks.onclickAddMedia(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Add Photos',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        10.height
                      ],
                    ),
                  )
                : GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio:
                        MediaQuery.of(context).size.aspectRatio * 1.5,
                    crossAxisSpacing: 4,
                    padding: EdgeInsets.all(10),
                    controller: _scrollController,
                    children: List.generate(thelist.length, (index) {
                      var isVideo = "${thelist[index]}".contains("fed");
                      var thecorectUrl = isVideo
                          ? videoUrl(
                              thelist[index],
                              thumbnail: true,
                            )!
                          : imageUrl(
                              thelist[index],
                            )!;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        shadowColor: primaryColor,
                        elevation: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: GestureDetector(
                            onTap: () => _toggleOverlay(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: white,
                              ),
                              alignment: Alignment.center,
                              child: Stack(
                                children: <Widget>[
                                  CachedNetworkImage(
                                    height:
                                        MediaQuery.of(context).size.height * .2,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageUrl: thecorectUrl,
                                    placeholder: (context, url) =>
                                        loadingImage(),
                                    errorWidget: (context, url, error) =>
                                        errorImage(),
                                  ).paddingAll(4),
                                  if (isVideo)
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            onPressed: () async {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return PostInformation(
                                                        play: true,
                                                        isVideo: isVideo,
                                                        mediaId:
                                                            thelist[index]);
                                                  });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  if (_showOverlays[index])
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                              onPressed: () async {
                                                Rks.initdesciptor();
                                                await Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            PostDescriptor(
                                                                id: thelist[
                                                                    index],
                                                                isVideo:
                                                                    isVideo)));
                                                if (Rks.postdescriptor!["go"] ==
                                                    "go") {
                                                  await Rks.uploadFile(
                                                      Rks.postdescriptor![
                                                          "f_conten"],
                                                      update_id: thelist[index],
                                                      isVideoparam: isVideo);
                                                }

                                                _startTimer(index);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.white,
                                                  size: 25),
                                              onPressed: () async {
                                                showInDialog(
                                                  context,
                                                  backgroundColor: whiteColor,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  builder: (p0) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            "Are you sure to remove this ${isVideo ? "Video" : "image"} ?"
                                                                .tr()),
                                                        28.height,
                                                        Row(
                                                          children: [
                                                            AppButton(
                                                              child: Text(
                                                                  "No".tr(),
                                                                  style:
                                                                      boldTextStyle()),
                                                              elevation: 0,
                                                              onTap: () {
                                                                simulateScreenTap();
                                                              },
                                                            ).expand(),
                                                            16.width,
                                                            AppButton(
                                                              child: Text(
                                                                  "Yes".tr(),
                                                                  style: boldTextStyle(
                                                                      color:
                                                                          blackColor)),
                                                              elevation: 0,
                                                              onTap: () async {
                                                                await Rks.uploadFile(
                                                                    null,
                                                                    delete_id:
                                                                        thelist[
                                                                            index]);
                                                                simulateScreenTap();
                                                              },
                                                            ).expand(),
                                                          ],
                                                        ),
                                                      ],
                                                    ).paddingSymmetric(
                                                        horizontal: 16,
                                                        vertical: 24);
                                                  },
                                                );
                                                _startTimer(index);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.remove_red_eye,
                                                  color: Colors.white,
                                                  size: 25),
                                              onPressed: () async {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return PostInformation(
                                                          isVideo: isVideo,
                                                          mediaId:
                                                              thelist[index]);
                                                    });

                                                _startTimer(index);
                                              },
                                            ),
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
                    })).paddingBottom(50),
          ),
        ],
      ),
    );
  }
}
