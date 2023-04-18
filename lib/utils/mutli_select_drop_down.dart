import 'package:flutter/material.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'app_colors.dart';

class MultiCustomDropDown extends StatefulWidget {
  final TextEditingController? controller;
  final List<dynamic>? list;
  final String? title;
  final String? hintText;
  final String? label;
  final Function(String?)? validator;
  final Function(List<dynamic>)? onChanged;

  const MultiCustomDropDown(
      {Key? key,
      this.title,
      this.hintText,
      this.controller,
      this.list,
      this.label,
      this.validator,
      this.onChanged})
      : super(key: key);

  @override
  State<MultiCustomDropDown> createState() => _MultiCustomDropDownState();
}

class _MultiCustomDropDownState extends State<MultiCustomDropDown> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      var concatenate = StringBuffer();
      if (widget.list != null) {
        for (var item in widget.list??[]) {
          if(item.isSelected==true){
            concatenate.write(item.name);
            concatenate.write(', ');
          }
        }
        widget.controller!.text = concatenate.toString();
      }
      return  TextFormField(autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        validator: (val) {
          return widget.validator!(val);
        },
        readOnly: true,
        style: const TextStyle(
            color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w500),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.visiblePassword,
        onChanged: (text) {},
        onTap: () async {
          final value = await _showMultiSelect(
              widget.list, widget.title, widget.onChanged!);
          widget.controller!.text = value.toString();
        },
        maxLength: 50,
        decoration: InputDecoration(
          counterText: '',
          suffixIcon: InkWell(
            child: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
          // contentPadding: EdgeInsets.symmetric(
          //     horizontal: config.AppConfig(context).appWidth(2),
          //     vertical: config.AppConfig(context).appWidth(2)),
          fillColor: Colors.white,
          filled: false,
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide:  BorderSide(
              color: AppColors.blacklight,
              width: 1.0,
            ),
          ),
          border: InputBorder.none,
          disabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide:  BorderSide(
              color: AppColors.blacklight,
              width: 1.0,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide:  BorderSide(
              color: AppColors.blacklight,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide:  BorderSide(
              color: AppColors.blacklight,
              width: 1.0,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide:  BorderSide(
              color: AppColors.blacklight,
              width: 1.0,
            ),
          ),
        ),
      );
    });
  }

  Future<String?> _showMultiSelect(
      items, title, Function(List<dynamic>)? onChanged) async {
    final List<dynamic>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
          items: items,
          title: title,
        );
      },
    );
    var concatenate = StringBuffer();
    onChanged!(results?.toList()?? []);
    if (results != null) {
      for (var item in results) {
        if(item.isSelected==true){
          concatenate.write(item.name);
          concatenate.write(', ');
        }
      }
    }
    return concatenate.toString();
  }
}

class MultiSelect extends StatefulWidget {
  final List<dynamic> items;
  final String? title;
  const MultiSelect({Key? key, required this.items, this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(dynamic itemValue, bool isSelected) {
    setState(() {
      itemValue.isSelected=isSelected;
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title.toString(),
        style: const TextStyle(
            color: AppColors.black, fontWeight: FontWeight.w600, fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value:item.isSelected==true, //_selectedItems.contains(item),
                    activeColor: AppColors.primary,
                    title: Text(item.name),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: Text(StringConstants.cancelText,
              style: TextStyle(
                  color: AppColors.blacklight,
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: Text(StringConstants.submitText,
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
        ),
      ],
    );
  }
}
