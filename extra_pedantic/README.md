This package contains the analysis rules used internally at I.C.N.H GmbH.

It mainly follows the style of the Flutter team and otherwise incorporates [Effective Dart](https://dart.dev/guides/language/effective-dart). We prefer `final` over `var` but do not add type information to every variable if they can be safely omitted.


## How to integrate the package:

1. Add the dependency to **pubspec.yaml**

        dev_dependencies:
          extra_pedantic:
            git:
              url: https://github.com/icnh/flutter_packages.git
              path: extra_pedantic
      
2. Include package in **analysis_options.yaml**

        include: package:extra_pedantic/analysis_options.yaml

3. If the project contains generated code, you probably want to exclude these files from analysis

        analyzer:
          exclude:
            - "<filepath>"


4. Please consider strongly to use strict mode:

        analyzer:
          language:
            strict-casts: true
            strict-inference: true
            strict-raw-types: true

## Customization

You might want to also add other rules like so:

    linter:
      rules:
        collection_methods_unrelated_type: true
