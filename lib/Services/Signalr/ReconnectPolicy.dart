import 'package:signalr_core/signalr_core.dart';

class ReconnectPolicy implements RetryPolicy {
  @override
  int? nextRetryDelayInMilliseconds(RetryContext retryContext) {
    return 5000;
  }
}