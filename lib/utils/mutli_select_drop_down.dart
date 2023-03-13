import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';


class MultiCustomDropDown extends StatefulWidget {
  // final _ProviderSignupPage? signupPage;
  final TextEditingController? controller;
  final List<dynamic>? list;
  final String? title;
  final String? hintText;
  final String? label;
  final Function(List<dynamic>)? onChanged;

  const MultiCustomDropDown({Key? key,this.title, this.hintText, this.controller, this.list, this.label, this.onChanged}) : super(key: key);

  @override
  State<MultiCustomDropDown> createState() => _MultiCustomDropDownState();
}

class _MultiCustomDropDownState extends State<MultiCustomDropDown> {
  // FocusNode myFocusNode =  FocusNode();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return TextFormField(
        controller: widget.controller,
        style: const TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500),
        // obscureText: state.showPassword,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.visiblePassword,
        onChanged: (text) {

        },
        onTap: ()async{
          final value = await _showMultiSelect(widget.list,widget.title,widget.onChanged!);
          widget.controller!.text = widget.controller!.text +value.toString();
        },
        maxLength: 50,
        decoration: InputDecoration(
          counterText: '',
          suffixIcon: InkWell(
            onTap: ()async{
              final value = await _showMultiSelect(widget.list,widget.title,widget.onChanged!);
              widget.controller!.text =widget.controller!.text + value.toString();
            },
            child: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          hintText: widget.hintText,
          hintStyle:  const TextStyle(
              color: AppColors.grey, fontSize: 14),
          // contentPadding: EdgeInsets.symmetric(
          //     horizontal: config.AppConfig(context).appWidth(2),
          //     vertical: config.AppConfig(context).appWidth(2)),
          fillColor: Colors.white,
          filled: true,
          focusedBorder:UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.0,
            ),
          ),
          border: InputBorder.none,
          disabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.0,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.0,
            ),
          ),
          focusedErrorBorder:UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.0,
            ),
          ),
          enabledBorder:UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.0,
            ),
          ),
        ),
      );
    });
  }

  Future <String> _showMultiSelect(items,title,Function(List<dynamic>)? onChanged) async {
    final List<dynamic>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items,title: title,);
      },
    );

    var concatenate = StringBuffer();
    onChanged!(results?.toList()??[]);
    if(results!=null){
      for (var item in results!) {
        concatenate.write(item);
        concatenate.write(', ');
      }
    }
    return concatenate.toString();
  }
}
class MultiSelect extends StatefulWidget {

  final List<dynamic> items;
  final String? title;
  const MultiSelect({Key? key, required this.items, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<dynamic> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(dynamic itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title.toString(), style:const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            activeColor: AppColors.primary,

            title: Text(item),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked!),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: Text("Cancel", style:  TextStyle(
              color: AppColors.blacklight,
              fontSize: 16,
              fontWeight: FontWeight.w400)
          ),),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor:  AppColors.primary,
          ),
          child: const Text("Submit", style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400)
          ),
        ),
      ],
    );
  }
}