import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalState {
  final bool isProcessingHTTPRequest;
  final bool showError;
  final String jwt;
  final String appVersion;
  final Uri? urlForUpgrade;
  final String buildNumber;

  const GlobalState({
    this.isProcessingHTTPRequest = false,
    this.showError = true,
    this.jwt = '',
    this.appVersion = '',
    this.urlForUpgrade,
    this.buildNumber = '',
  });

  GlobalState copyWith({
    bool? isProcessingHTTPRequest,
    bool? showError,
    String? jwt,
    String? appVersion,
    Uri? urlForUpgrade,
    String? buildNumber,
  }) {
    return GlobalState(
      isProcessingHTTPRequest: isProcessingHTTPRequest ?? this.isProcessingHTTPRequest,
      showError: showError ?? this.showError,
      jwt: jwt ?? this.jwt,
      appVersion: appVersion ?? this.appVersion,
      urlForUpgrade: urlForUpgrade ?? this.urlForUpgrade,
      buildNumber: buildNumber ?? this.buildNumber,
    );
  }
}

class GlobalNotifier extends Notifier<GlobalState> {
  @override
  GlobalState build() {
    return const GlobalState();
  }

  void setProcessingHTTPRequest(bool value) {
    state = state.copyWith(isProcessingHTTPRequest: value);
  }

  void setShowError(bool value) {
    state = state.copyWith(showError: value);
  }

  void setJwt(String value) {
    state = state.copyWith(jwt: value);
  }

  void setAppVersion(String value) {
    state = state.copyWith(appVersion: value);
  }

  void setUrlForUpgrade(Uri value) {
    state = state.copyWith(urlForUpgrade: value);
  }

  void setBuildNumber(String value) {
    state = state.copyWith(buildNumber: value);
  }
}

final globalProvider = NotifierProvider<GlobalNotifier, GlobalState>(GlobalNotifier.new);
