// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

// import 'package:flutter/ink_well.dart';
// import 'material.dart';
// import 'text_form_field.dart';
// import 'theme.dart';

/// {@macro flutter.widgets.RawAutocomplete.RawAutocomplete}
///
/// {@tool dartpad --template=freeform}
/// This example shows how to create a very basic Autocomplete widget using the
/// default UI.
///
/// ```dart main
/// import 'package:flutter/material.dart';
///
/// void main() => runApp(const AutocompleteExampleApp());
///
/// class AutocompleteExampleApp extends StatelessWidget {
///   const AutocompleteExampleApp({Key? key}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Scaffold(
///         appBar: AppBar(
///           title: const Text('Autocomplete Basic'),
///         ),
///         body: const Center(
///           child: AutocompleteBasicExample(),
///         ),
///       ),
///     );
///   }
/// }
///
/// class AutocompleteBasicExample extends StatelessWidget {
///   const AutocompleteBasicExample({Key? key}) : super(key: key);
///
///   static const List<String> _kOptions = <String>[
///     'aardvark',
///     'bobcat',
///     'chameleon',
///   ];
///
///   @override
///   Widget build(BuildContext context) {
///     return Autocomplete<String>(
///       optionsBuilder: (TextEditingValue textEditingValue) {
///         if (textEditingValue.text == '') {
///           return const Iterable<String>.empty();
///         }
///         return _kOptions.where((String option) {
///           return option.contains(textEditingValue.text.toLowerCase());
///         });
///       },
///       onSelected: (String selection) {
///         print('You just selected $selection');
///       },
///     );
///   }
/// }
/// ```
/// {@end-tool}
///
/// {@tool dartpad --template=freeform}
/// This example shows how to create an Autocomplete widget with a custom type.
/// Try searching with text from the name or email field.
///
/// ```dart main
/// import 'package:flutter/material.dart';
///
/// void main() => runApp(const AutocompleteExampleApp());
///
/// class AutocompleteExampleApp extends StatelessWidget {
///   const AutocompleteExampleApp({Key? key}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Scaffold(
///         appBar: AppBar(
///           title: const Text('Autocomplete Basic User'),
///         ),
///         body: const Center(
///           child: AutocompleteBasicUserExample(),
///         ),
///       ),
///     );
///   }
/// }
///
/// @immutable
/// class User {
///   const User({
///     required this.email,
///     required this.name,
///   });
///
///   final String email;
///   final String name;
///
///   @override
///   String toString() {
///     return '$name, $email';
///   }
///
///   @override
///   bool operator ==(Object other) {
///     if (other.runtimeType != runtimeType) {
///       return false;
///     }
///     return other is User
///         && other.name == name
///         && other.email == email;
///   }
///
///   @override
///   int get hashCode => hashValues(email, name);
/// }
///
/// class AutocompleteBasicUserExample extends StatelessWidget {
///   const AutocompleteBasicUserExample({Key? key}) : super(key: key);
///
///   static const List<User> _userOptions = <User>[
///     User(name: 'Alice', email: 'alice@example.com'),
///     User(name: 'Bob', email: 'bob@example.com'),
///     User(name: 'Charlie', email: 'charlie123@gmail.com'),
///   ];
///
///   static String _displayStringForOption(User option) => option.name;
///
///   @override
///   Widget build(BuildContext context) {
///     return Autocomplete<User>(
///       displayStringForOption: _displayStringForOption,
///       optionsBuilder: (TextEditingValue textEditingValue) {
///         if (textEditingValue.text == '') {
///           return const Iterable<User>.empty();
///         }
///         return _userOptions.where((User option) {
///           return option.toString().contains(textEditingValue.text.toLowerCase());
///         });
///       },
///       onSelected: (User selection) {
///         print('You just selected ${_displayStringForOption(selection)}');
///       },
///     );
///   }
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [RawAutocomplete], which is what Autocomplete is built upon, and which
///    contains more detailed examples.
class auto_complete_text_view<T extends Object> extends StatelessWidget {
  /// Creates an instance of [Autocomplete].
  const auto_complete_text_view({
    Key? key,
    required this.optionsBuilder,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder = _defaultFieldViewBuilder,
    this.onSelected,
    this.optionsMaxHeight = 200.0,
    this.optionsViewBuilder,
    this.initialValue,
  }) : assert(displayStringForOption != null),
        assert(optionsBuilder != null),
        super(key: key);

  /// {@macro flutter.widgets.RawAutocomplete.displayStringForOption}
  final AutocompleteOptionToString<T> displayStringForOption;

  /// {@macro flutter.widgets.RawAutocomplete.fieldViewBuilder}
  ///
  /// If not provided, will build a standard Material-style text field by
  /// default.
  final AutocompleteFieldViewBuilder fieldViewBuilder;

  /// {@macro flutter.widgets.RawAutocomplete.onSelected}
  final AutocompleteOnSelected<T>? onSelected;

  /// {@macro flutter.widgets.RawAutocomplete.optionsBuilder}
  final AutocompleteOptionsBuilder<T> optionsBuilder;

  /// {@macro flutter.widgets.RawAutocomplete.optionsViewBuilder}
  ///
  /// If not provided, will build a standard Material-style list of results by
  /// default.
  final AutocompleteOptionsViewBuilder<T>? optionsViewBuilder;

  /// The maximum height used for the default Material options list widget.
  ///
  /// When [optionsViewBuilder] is `null`, this property sets the maximum height
  /// that the options widget can occupy.
  ///
  /// The default value is set to 200.
  final double optionsMaxHeight;

  /// {@macro flutter.widgets.RawAutocomplete.initialValue}
  final TextEditingValue? initialValue;

  static Widget _defaultFieldViewBuilder(BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
    return _AutocompleteField(
      focusNode: focusNode,
      textEditingController: textEditingController,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      displayStringForOption: displayStringForOption,
      fieldViewBuilder: fieldViewBuilder,
      initialValue: initialValue,
      optionsBuilder: optionsBuilder,
      optionsViewBuilder: optionsViewBuilder ?? (BuildContext context, AutocompleteOnSelected<T> onSelected, Iterable<T> options) {
        return _AutocompleteOptions<T>(
          displayStringForOption: displayStringForOption,
          onSelected: onSelected,
          options: options,
          maxOptionsHeight: optionsMaxHeight,
        );
      },
      onSelected: onSelected,
    );
  }
}

// The default Material-style Autocomplete text field.
class _AutocompleteField extends StatelessWidget {
  const _AutocompleteField({
    Key? key,
    required this.focusNode,
    required this.textEditingController,
    required this.onFieldSubmitted,
  }) : super(key: key);

  final FocusNode focusNode;

  final VoidCallback onFieldSubmitted;

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Select your Company",
        border: OutlineInputBorder()
      ),
      controller: textEditingController,
      focusNode: focusNode,
      onFieldSubmitted: (String value) {
        onFieldSubmitted();
      },
    );
  }
}

// The default Material-style Autocomplete options.
class _AutocompleteOptions<T extends Object> extends StatelessWidget {
  const _AutocompleteOptions({
    Key? key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.maxOptionsHeight,
  }) : super(key: key);

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;
  final double maxOptionsHeight;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxOptionsHeight),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final T option = options.elementAt(index);
              return InkWell(
                onTap: () {
                  onSelected(option);
                },
                child: Builder(
                    builder: (BuildContext context) {
                      final bool highlight = AutocompleteHighlightedOption.of(context) == index;
                      if (highlight) {
                        SchedulerBinding.instance!.addPostFrameCallback((Duration timeStamp) {
                          Scrollable.ensureVisible(context, alignment: 0.5);
                        });
                      }
                      return Container(
                        color: highlight ? Theme.of(context).focusColor : null,
                        padding: const EdgeInsets.all(16.0),
                        child: Text(displayStringForOption(option)),
                      );
                    }
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
