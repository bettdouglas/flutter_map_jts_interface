import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final fireMilliSeconds = 1;

final timer = Stream.periodic(
  Duration(milliseconds: fireMilliSeconds),
  makeRepeatingId,
);

int makeRepeatingId(int current) {
  final ans = (current % count);
  print(ans);
  return ans;
}

var count = 0;

final timerListener = StreamProvider((ref) => timer);
