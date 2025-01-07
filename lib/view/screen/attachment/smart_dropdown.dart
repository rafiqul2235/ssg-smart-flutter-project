import 'package:flutter/material.dart';

class SmartDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String Function(T) displayStringForOption;
  final void Function(T?) onChanged;
  final String? hint;  // Optional hint
  final String label;
  final bool enableSearch;

  const SmartDropdown({
    Key? key,
    required this.items,
    required this.value,
    required this.displayStringForOption,
    required this.onChanged,
    this.hint,  // Optional hint
    this.label = 'Label',
    this.enableSearch = true,
  }) : super(key: key);

  @override
  State<SmartDropdown<T>> createState() => _SmartDropdownState<T>();
}

class _SmartDropdownState<T> extends State<SmartDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  bool _isOpen = false;
  List<T> _filteredItems = [];
  OverlayEntry? _overlayEntry;

  // Track if the dropdown is focused or not
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isOpen) {
        _closeDropdown();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => widget.displayStringForOption(item)
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
    _updateOverlay();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _focusNode.requestFocus();
    _isOpen = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  void _closeDropdown() {
    _focusNode.unfocus();
    _isOpen = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 300,
                minWidth: size.width,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.enableSearch)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          isDense: true,
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: _filterItems,
                      ),
                    ),
                  Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shrinkWrap: true,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return ListTile(
                          dense: true,
                          title: Text(widget.displayStringForOption(item)),
                          selected: widget.value == item,
                          onTap: () {
                            widget.onChanged(item);
                            setState(() {
                              _isSelected = true; // Mark as selected when an item is tapped
                            });
                            _closeDropdown();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,  // Use the optional hint if provided
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: _isSelected
                    ? Theme.of(context).primaryColor  // Change border color when selected
                    : Theme.of(context).dividerColor, // Default border color
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          isEmpty: widget.value == null, // The field is considered empty when no value is selected
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.value != null
                      ? widget.displayStringForOption(widget.value as T)
                      : '', // No hint text is shown when no value is selected
                  style: widget.value != null
                      ? null
                      : TextStyle(color: Theme.of(context).hintColor),
                ),
              ),
              Icon(
                _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Theme.of(context).iconTheme.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
