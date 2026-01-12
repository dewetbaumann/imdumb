// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;

typedef JSON = Map<String, dynamic>;
typedef Reader = T Function<T>(ProviderListenable<T> provider);
