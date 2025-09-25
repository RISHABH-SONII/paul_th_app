import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:tharkyApp/Screens/PostInformation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pagination GridView Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaginationGridViewGallery(),
    );
  }
}

class PaginationGridViewGallery extends StatefulWidget {
  @override
  _PaginationGridViewGalleryState createState() =>
      _PaginationGridViewGalleryState();
}

class _PaginationGridViewGalleryState extends State<PaginationGridViewGallery> {
  final ScrollController _scrollController = ScrollController();
  List<String> _imageList = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10; // Nombre d'éléments à charger à chaque fois
  final int _totalItems = 100; // Taille totale de la liste (connue à l'avance)

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

  // Simule le chargement initial des données
  void _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    // Simule une requête réseau
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _imageList = _getPaginatedData(_currentPage);
      _isLoading = false;
    });
  }

  // Simule le chargement de plus de données
  void _loadMoreData() async {
    if (_isLoading || _imageList.length >= _totalItems) return;

    setState(() {
      _isLoading = true;
    });

    // Simule une requête réseau
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _currentPage++;
      _imageList.addAll(_getPaginatedData(_currentPage));
      _isLoading = false;
    });
  }

  // Retourne les données pour la page actuelle
  List<String> _getPaginatedData(int page) {
    int startIndex = (page - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;

    if (endIndex > _totalItems) {
      endIndex = _totalItems;
    }

    return List.generate(
        endIndex - startIndex,
        (index) =>
            "https://picsum.photos/200/300?random=${startIndex + index}");
  }

  // Détecte quand l'utilisateur atteint la fin de la liste
  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagination GridView Gallery'),
      ),
      body: _buildPostList(context: context, thelist: _imageList),
    );
  }

  Widget _buildPostList(
      {required List<String>? thelist, required BuildContext context}) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * .85,
            width: MediaQuery.of(context).size.width,
            child: thelist!.isEmpty
                ? Center(
                    child:
                        CircularProgressIndicator()) // Indicateur de chargement initial
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio:
                          MediaQuery.of(context).size.aspectRatio * 1.5,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: thelist.length +
                        (_isLoading
                            ? 1
                            : 0), // +1 pour l'indicateur de chargement
                    itemBuilder: (context, index) {
                      if (index == thelist.length) {
                        return Center(
                            child:
                                CircularProgressIndicator()); // Indicateur de chargement en bas
                      }

                      var anImage = thelist.length > index;
                      var isVideo = "${thelist[index]}".contains("fed");
                      var thecorectUrl = isVideo
                          ? videoUrl(thelist[index], thumbnail: true)!
                          : imageUrl(thelist[index])!;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        shadowColor: Colors.blue,
                        elevation: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: GestureDetector(
                            onTap: () => _toggleOverlay(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  anImage
                                      ? CachedNetworkImage(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .2,
                                          fit: BoxFit.cover,
                                          imageUrl: thecorectUrl,
                                          placeholder: (context, url) =>
                                              loadingImage(),
                                          errorWidget: (context, url, error) =>
                                              errorImage(),
                                        ).paddingAll(4)
                                      : InkWell(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(Icons.image,
                                                size: 50, color: Colors.grey),
                                          ),
                                          onTap: () => source(context),
                                        ),
                                  if (isVideo)
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
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
                                                      mediaId: thelist[index],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (anImage && _showOverlays[index]!)
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
                                              onPressed: () async {},
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.white,
                                                  size: 25),
                                              onPressed: () async {},
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.remove_red_eye,
                                                  color: Colors.white,
                                                  size: 25),
                                              onPressed: () async {},
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
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Méthodes factices pour simuler les URL
  String? videoUrl(String url, {bool thumbnail = false}) {
    return "https://picsum.photos/200/300?random=$url";
  }

  String? imageUrl(String url) {
    return "https://picsum.photos/200/300?random=$url";
  }

  Widget loadingImage() {
    return Center(child: CircularProgressIndicator());
  }

  Widget errorImage() {
    return Center(child: Icon(Icons.error, color: Colors.red));
  }

  void _toggleOverlay(int index) {
    setState(() {
      _showOverlays[index] = !_showOverlays[index]!;
    });
  }

  void source(BuildContext context) {
    // Ajoutez votre logique ici
  }

  Map<int, bool> _showOverlays = {}; // Pour gérer l'affichage des overlays
}
