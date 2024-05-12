import 'package:anysongs/core/utils/global.dart';
import 'package:async/async.dart';

extension StreamExts<T> on Stream<T> {
  Stream<Pair<T, S>> concat<S>(Stream<S> stream) {
    return StreamZip([this, stream])
        .map((obj) => (first: obj[0] as T, second: obj[1] as S))
        .asBroadcastStream();
  }
}
