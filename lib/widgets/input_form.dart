import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lupiter/generated/lupiter_assets.g.dart';
import 'package:lupiter/generated/lupiter_icons.g.dart';
import 'package:lupiter/generated/lupiter_localization.g.dart';
import 'package:lupiter/lupiter_cubit.dart';
import 'package:lupiter/lupiter_style.dart';
import 'package:lupiter/models/order_model.dart';
import 'package:lupiter/widgets/focus_wrapper.dart';
import 'package:lupiter/widgets/lupiter_icon.dart';

/// The input form for inputting name, address, zipcode and country.
class InputForm extends StatefulWidget {
  /// The input form for inputting name, address, zipcode and country.
  const InputForm({Key? key}) : super(key: key);

  @override
  InputFormState createState() => InputFormState();
}

/// The input form for inputting name, address, zipcode and country.
class InputFormState extends State<InputForm>
    with AutomaticKeepAliveClientMixin {
  bool _isPressed = false;
  String? _nameError, _addressError, _zipCodeError, _cityError;

  late final GlobalKey _nameKey, _addressKey, _zipCodeKey, _cityKey;

  late final TextEditingController _nameController,
      _addressController,
      _zipCodeController,
      _cityController;

  late final FocusNode _nameFocusNode,
      _addressFocusNode,
      _zipCodeFocusNode,
      _cityFocusNode;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _nameKey = GlobalKey(debugLabel: 'name_input');
    _addressKey = GlobalKey(debugLabel: 'address_input');
    _zipCodeKey = GlobalKey(debugLabel: 'zip_code_input');
    _cityKey = GlobalKey(debugLabel: 'city_input');

    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _zipCodeController = TextEditingController();
    _cityController = TextEditingController();

    _nameFocusNode = FocusNode()..addListener(() => setState(() {}));
    _addressFocusNode = FocusNode()..addListener(() => setState(() {}));
    _zipCodeFocusNode = FocusNode()..addListener(() => setState(() {}));
    _cityFocusNode = FocusNode()..addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();

    _nameFocusNode.dispose();
    _addressFocusNode.dispose();
    _zipCodeFocusNode.dispose();
    _cityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FocusWrapper(
      unfocussableKeys: <GlobalKey>[
        _nameKey,
        _addressKey,
        _zipCodeKey,
        _cityKey
      ],
      child: SingleChildScrollView(
        padding: screenPadding(context, withInsets: false),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.075),

            /// Logo
            IconButton(
              iconSize: 150,
              splashRadius: 100,
              icon: Image.asset(LupiterAssets.icon),
              onPressed: () async {
                final isLight =
                    Theme.of(context).brightness == Brightness.light;
                context.read<LupiterCubit>().appService.changeAppTheme(
                      isLight ? ThemeMode.dark : ThemeMode.light,
                    );
              },
            ),
            const SizedBox(height: 25),
            const SizedBox(height: 16),

            /// Name
            TextField(
              key: _nameKey,
              toolbarOptions: _enabledToolbarOptions,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: _decoration(
                controller: _nameController,
                focusNode: _nameFocusNode,
                label: TR.inputFormNameLabel.tr(),
                hint: TR.inputFormNameHint.tr(),
                errorText: _nameError,
              ),
              controller: _nameController,
              focusNode: _nameFocusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) => FocusScope.of(context).nextFocus(),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                  RegExp(r'[\p{L} ]', unicode: true),
                ),
                LengthLimitingTextInputFormatter(255),
              ],
            ),
            const SizedBox(height: 16),

            /// Address
            TextField(
              toolbarOptions: _enabledToolbarOptions,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: _decoration(
                controller: _addressController,
                focusNode: _addressFocusNode,
                label: TR.inputFormAddressLabel.tr(),
                hint: TR.inputFormAddressHint.tr(),
                errorText: _addressError,
              ),
              key: _addressKey,
              controller: _addressController,
              focusNode: _addressFocusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) => FocusScope.of(context).nextFocus(),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                  RegExp(r'[\p{L} ,.]', unicode: true),
                ),
                LengthLimitingTextInputFormatter(255),
              ],
            ),
            const SizedBox(height: 16),

            /// Zip Code
            TextField(
              toolbarOptions: _enabledToolbarOptions,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: _decoration(
                controller: _zipCodeController,
                focusNode: _zipCodeFocusNode,
                label: TR.inputFormZipCodeLabel.tr(),
                hint: TR.inputFormZipCodeHint.tr(),
                errorText: _zipCodeError,
              ),
              key: _zipCodeKey,
              controller: _zipCodeController,
              focusNode: _zipCodeFocusNode,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) => FocusScope.of(context).nextFocus(),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                LengthLimitingTextInputFormatter(6),
              ],
            ),
            const SizedBox(height: 16),

            /// City Name
            TextField(
              toolbarOptions: _enabledToolbarOptions,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: _decoration(
                controller: _cityController,
                focusNode: _cityFocusNode,
                label: TR.inputFormCityLabel.tr(),
                hint: TR.inputFormCityHint.tr(),
                errorText: _cityError,
              ),
              key: _cityKey,
              controller: _cityController,
              focusNode: _cityFocusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) => FocusScope.of(context).nextFocus(),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                  RegExp(r'[\p{L} ]', unicode: true),
                ),
                LengthLimitingTextInputFormatter(255),
              ],
            ),

            const SizedBox(height: 25),

            /// Button
            if (!_isPressed)
              Padding(
                padding: horizontalPadding(context),
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      _isPressed = true;
                      _nameError =
                          _addressError = _zipCodeError = _cityError = null;
                    });

                    if (_nameController.text.isEmpty) {
                      _nameError = TR.inputFormNameErrorRequired.tr();
                    } else {
                      final cubit = context.read<LupiterCubit>();
                      final orders = cubit.state.orderState.orders;
                      final biggestId = orders.isNotEmpty
                          ? (orders.map((e) => e.id).toList()..sort()).last
                          : 0;
                      await cubit.orderService.addOrder(
                        OrderModel(
                          id: biggestId + 1,
                          name: _nameController.text,
                          address: _addressController.text,
                          zipCode: _zipCodeController.text,
                          city: _cityController.text,
                        ),
                      );

                      _nameController.clear();
                      _addressController.clear();
                      _zipCodeController.clear();
                      _cityController.clear();
                    }

                    await Future.delayed(const Duration(milliseconds: 500));
                    if (mounted) {
                      setState(() => _isPressed = false);
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    primary: Theme.of(context).colorScheme.surface,
                  ),
                  child: Text(
                    TR.inputFormButton.tr(),
                    style: Theme.of(context).textTheme.button?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator.adaptive(strokeWidth: 3),
              ),
          ],
        ),
      ),
    );
  }

  static const ToolbarOptions _enabledToolbarOptions = ToolbarOptions(
    paste: true,
    copy: true,
    cut: true,
    selectAll: true,
  );

  InputDecoration _decoration({
    required TextEditingController controller,
    required FocusNode focusNode,
    String? label,
    String? hint,
    String? errorText,
  }) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      alignLabelWithHint: true,
      labelText: label,
      labelStyle: Theme.of(context).textTheme.subtitle2,
      filled: true,
      fillColor: Theme.of(context).cardColor,
      hoverColor: Theme.of(context).colorScheme.onSurface.withOpacity(1 / 8),
      contentPadding: const EdgeInsets.all(14),
      hintText: hint,
      hintMaxLines: 1,
      hintStyle: Theme.of(context).textTheme.bodyText1,
      errorText: errorText,
      errorMaxLines: 1,
      errorStyle:
          Theme.of(context).textTheme.headline5?.copyWith(color: Colors.red),
      suffixIcon: focusNode.hasPrimaryFocus
          ? IconButton(
              padding: EdgeInsets.zero,
              splashRadius: 20,
              icon: const LupiterIcon(LupiterIcons.close),
              color: Theme.of(context).colorScheme.onSurface,
              onPressed: () => controller.clear(),
            )
          : null,
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      disabledBorder: const OutlineInputBorder(),
    );
  }
}
