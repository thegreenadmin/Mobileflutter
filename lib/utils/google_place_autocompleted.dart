import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class GooglePlaceAutocompleteField extends StatefulWidget {
  final String apiKey;
  final Function(Place place) onPlaceSelected;
  final InputDecoration? decoration;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final double? maxPredictionsHeight;
  final FormFieldValidator<String>? validator;

  const GooglePlaceAutocompleteField({
    Key? key,
    required this.apiKey,
    required this.onPlaceSelected,
    this.decoration,
    this.textStyle, this.controller, this.maxPredictionsHeight, this.validator,
  }) : super(key: key);

  @override
  State<GooglePlaceAutocompleteField> createState() =>
      _GooglePlaceAutocompleteFieldState();
}

class _GooglePlaceAutocompleteFieldState
    extends State<GooglePlaceAutocompleteField> {
  late final FlutterGooglePlacesSdk _places;
  // final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<AutocompletePrediction> _predictions = [];
  Timer? _debounce;
  bool _showClear = false;

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _places = FlutterGooglePlacesSdk(widget.apiKey);
    // Defensive check in case controller is disposed or null
    if (widget.controller != null) {
      try {
        widget.controller!.addListener(_onTextChanged);
      } catch (_) {
        // Safeguard: controller may already be disposed
      }
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }
  bool _suppressInputChange = false;
  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5), // show below the TextField
          child: Material(
            elevation: 4,
            child: Container(
              // height: widget.maxPredictionsHeight ?? 200,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _predictions.length,
                  separatorBuilder: (_, __) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final p = _predictions[index];
                    return ListTile(
                      leading: Icon(Icons.location_on, color: Colors.grey),
                      title: Text(p.fullText ?? ''),
                      subtitle: Text(p.secondaryText ?? ''),
                      onTap: () => _onPredictionTapped(p),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _onTextChanged() {
    if (_suppressInputChange) return;
    final text = widget.controller?.text ?? '';

    setState(() => _showClear = text.isNotEmpty);

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (text.isEmpty) {
        _removeOverlay();
        return;
      }

      final result = await _places.findAutocompletePredictions(text);
      _predictions
        ..clear()
        ..addAll(result.predictions);

      if (_predictions.isNotEmpty) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

/*  void _onTextChanged() {
    if (_suppressInputChange) return;

    final text = widget.controller?.text;
    setState(() => _showClear = widget.controller!.text.isNotEmpty);

    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 400), () async {
      if (text!.isEmpty) {
        setState(() => _predictions.clear());
        return;
      }

      final result = await _places.findAutocompletePredictions(text);
      setState(() {
        _predictions.clear();
        _predictions.addAll(result.predictions);
      });
    });
  }*/
  Future<void> _onPredictionTapped(AutocompletePrediction prediction) async {
    _suppressInputChange = true;

    final details = await _places.fetchPlace(
      prediction.placeId,
      fields: [
        PlaceField.Address,
        PlaceField.Name,
        PlaceField.AddressComponents,
        PlaceField.Location,
      ],
    );

    widget.onPlaceSelected(details.place!);
    widget.controller?.text = details.place?.address ?? prediction.fullText ?? '';
    widget.controller?.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.controller!.text.length),
    );

    if (mounted) {
      setState(() => _predictions.clear());
    }

    _focusNode.unfocus();
    _removeOverlay(); // <-- Ensure this removes the dropdown

    // Allow input to be changed again after a short delay
    Future.delayed(Duration(milliseconds: 100), () {
      _suppressInputChange = false;
    });
  }

  void _clearInput() {
    widget.controller!.clear();
    setState(() => _predictions.clear());
  }


  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        style: widget.textStyle,
        decoration: widget.decoration?.copyWith(
          suffixIcon: _showClear
              ? IconButton(
            icon: Icon(Icons.close),
            onPressed: _clearInput,
          )
              : null,
        ) ??
            InputDecoration(
              hintText: 'Search address',
              suffixIcon: _showClear
                  ? IconButton(
                icon: Icon(Icons.close),
                onPressed: _clearInput,
              )
                  : null,
            ),
        validator: widget.validator,
      ),
    );
  }


/*  @override
  Widget build(BuildContext context) {
    final input = TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      style: widget.textStyle,
      decoration: widget.decoration?.copyWith(
        suffixIcon: _showClear
            ? IconButton(
          icon: Icon(Icons.close),
          onPressed: _clearInput,
        )
            : null,
      ) ??
          InputDecoration(
            hintText: 'Search address',
            suffixIcon: _showClear
                ? IconButton(
              icon: Icon(Icons.close),
              onPressed: _clearInput,
            )
                : null,
          ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        input,
        if (_predictions.isNotEmpty)
          Container(
            height: widget.maxPredictionsHeight ?? 200, // fallback height
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Scrollbar(
              thumbVisibility: true, // Always show scrollbar
              child: ListView.separated(
                itemCount: _predictions.length,
                shrinkWrap: true,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final p = _predictions[index];
                  return ListTile(
                    leading: Icon(Icons.location_on, color: Colors.grey),
                    title: Text(p.fullText ?? ''),
                    subtitle: Text(p.secondaryText ?? ''),
                    onTap: () => _onPredictionTapped(p),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }*/
}
