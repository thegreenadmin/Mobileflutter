import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class TextFieldWidget extends StatefulWidget {
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? textInputFormatter;
  final FocusNode? focusNode;
  final String? errorText;
  final String? label;
  final String? hintText;
  final bool isObscureText;
  final bool isDOB ;
  final bool isPass;
  final bool isLabelDark;
  final void Function(String)? onValue;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final Widget? suffix;
  final GestureTapCallback? onSuffixClick;

  const TextFieldWidget({Key? key,
    this.validator,
    this.textInputType,
    this.onTap,
    this.textInputFormatter,
    this.focusNode,
    this.controller,
    this.errorText,
    this.label,
    this.hintText,
    this.isObscureText = false,
    this.isLabelDark = true,
    this.isDOB= false,
    this.isPass= false,

    this.onValue,
    this.suffix,
    this.onSuffixClick,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() =>TextFieldWidgetState();
}

class TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
        child: TextFormField(
          controller: widget.controller,
            autofocus: false,
          obscureText: widget.isObscureText,
          inputFormatters:  widget.textInputFormatter,
          onTap: widget.onTap,
          validator: (v){
            return widget.validator!(v);
          },
          style:  const TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500),
          textInputAction: TextInputAction.next,
          keyboardType: widget.textInputType,
          maxLength: 55,
          onChanged: widget.onValue,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                  color: AppColors.grey, fontSize: 14),
              fillColor: Colors.white,
              border: UnderlineInputBorder(
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
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.0,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: AppColors.grey,
                  width: 1.0,
                ),
              ),
            )
        ),
      );
    });
  }
}


class TextAreaWidget extends StatefulWidget {
  // final _SignupPage? loginForm;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? textInputFormatter;
  final FocusNode? focusNode;
  final String? errorText;
  final String? label;
  final String? hintText;
  final int? maxLength;
  final bool isObscureText;
  final bool isDOB ;
  final bool isPass;
  final void Function(String)? onValue;
  final void Function()? onTap;
  final Widget? suffix;
  final GestureTapCallback? onSuffixClick;

  const TextAreaWidget({Key? key,
    // this.loginForm,
    this.textInputType,
    this.onTap,
    this.textInputFormatter,
    this.focusNode,
    this.controller,
    this.errorText,
    this.label,
    this.hintText,
    this.maxLength=3000,
    this.isObscureText = false,
    this.isDOB= false,
    this.isPass= false,

    this.onValue,
    this.suffix,
    this.onSuffixClick,
  }) : super(key: key);

  @override
  State<TextAreaWidget> createState() =>TextAreaWidgetState();
}

class TextAreaWidgetState extends State<TextAreaWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      // print('constraibtWidth ${constraint.maxWidth}');
      return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.zero,
        child: TextFormField(
          // focusNode:  widget.focusNode,
          controller: widget.controller,
          obscureText: widget.isObscureText,
          inputFormatters:  widget.textInputFormatter,
          onTap: widget.onTap,
          style:  const TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500),
          textInputAction: TextInputAction.next,
          // keyboardType: widget.textInputType,
          maxLength: widget.maxLength,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textAlign: TextAlign.start,
          onChanged: widget.onValue,
          decoration: InputDecoration(
            counterText: '',
            errorText:widget.errorText,
            // suffix: widget.suffix,
            suffixIcon: widget.isPass ||  widget.isDOB ? IconButton(
              onPressed: (){
                widget.onSuffixClick;
              },
              color: Colors.white,
              icon: Icon(
                !widget.isObscureText &&  widget.isPass
                    ? Icons.visibility
                    :  widget.isObscureText &&  widget.isPass ?
                Icons.visibility_off: Icons.calendar_month,
                color:  widget.isPass ? Theme.of(context)
                    .primaryColorLight:Theme.of(context).primaryColor,
              ),
            ):null,
            labelText: widget.label,
            hintText: widget.hintText,
            labelStyle:    const TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500),
            hintStyle:   const TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500),
            // contentPadding: EdgeInsets.symmetric(
            //     horizontal: config.AppConfig(context).appWidth(2),
            //     vertical: config.AppConfig(context).appWidth(2)),
            fillColor: Colors.white,
            filled: false,
            focusedBorder: OutlineInputBorder(
                borderSide:  const BorderSide(
                  color: AppColors.black,),
                borderRadius: BorderRadius.circular(15)
            ),
            border: InputBorder.none,
            disabledBorder: OutlineInputBorder(
                borderSide:  const BorderSide(
                  color: AppColors.black,),
                borderRadius: BorderRadius.circular(15)
            ),
            errorBorder: OutlineInputBorder(
                borderSide:  const BorderSide(
                  color: AppColors.black,),
                borderRadius: BorderRadius.circular(15)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide:  const BorderSide(
                  color: AppColors.black,),
                borderRadius: BorderRadius.circular(15)
            ),
            enabledBorder: OutlineInputBorder(
                borderSide:  const BorderSide(
                  color: AppColors.black,),
                borderRadius: BorderRadius.circular(15)
            ),
          ),
        ),
      );
    });
  }
}
