part of flutter_mapbox_autocomplete;

class ApiSearchDebouncer {
  Timer? _debounce;

  void run(void Function() callback) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), callback); // Corrected
  }
}

class MapBoxAutoCompleteWidget extends StatefulWidget {
  final String? hint;
  final void Function(MapBoxPlace place)? onSelect;
  final bool closeOnSelect;
  final String language;
  final Location? location;
  final String? country;
  final String? city;
  final int? limit;

  MapBoxAutoCompleteWidget({
    this.hint,
    this.onSelect,
    this.closeOnSelect = true,
    this.language = "en",
    this.location,
    this.city,
    this.limit,
    this.country,
  });

  @override
  _MapBoxAutoCompleteWidgetState createState() =>
      _MapBoxAutoCompleteWidgetState();
}

class _MapBoxAutoCompleteWidgetState extends State<MapBoxAutoCompleteWidget> {
  final _searchFieldTextController = TextEditingController();
  final _searchFieldTextFocus = FocusNode();
  final ApiSearchDebouncer _debouncer = ApiSearchDebouncer();

  Predections? _placePredictions = Predections.empty();

  Future<void> _getPlaces(String input) async {
    if (input.isNotEmpty) {
      final user = {"city": input};
      await getplaces(user).then((response) async {
        final predictions = Predections.fromJson(response.data);
        setState(() {
          _placePredictions = predictions; // Update the predictions state
        });
      }).catchError((e) {});
    } else {
      setState(() => _placePredictions = Predections.empty());
    }
  }

  void _onSearchTextChanged(String query) {
    _debouncer.run(() {
      _getPlaces(query);
    });
  }

  void _selectPlace(MapBoxPlace prediction) async {
    if (widget.onSelect != null) {
      widget.onSelect!(prediction);
    }
    if (widget.closeOnSelect) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextField(
          hintText: widget.hint,
          textController: _searchFieldTextController,
          onChanged: (input) => _onSearchTextChanged(input),
          focusNode: _searchFieldTextFocus,
          onFieldSubmitted: (value) => _searchFieldTextFocus.unfocus(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => _searchFieldTextController.clear(),
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (cx, _) => Divider(),
        padding: EdgeInsets.symmetric(horizontal: 15),
        itemCount: _placePredictions!.features!.length,
        itemBuilder: (ctx, i) {
          MapBoxPlace _singlePlace = _placePredictions!.features![i];
          return ListTile(
            title: Text(_singlePlace.placeName!),
            subtitle: Text(_singlePlace.placeName!),
            onTap: () => _selectPlace(_singlePlace),
          );
        },
      ),
    );
  }
}
