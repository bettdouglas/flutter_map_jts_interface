import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final fireMilliSeconds = 1;

final timer = Stream.periodic(
  Duration(milliseconds: fireMilliSeconds),
  (idx) => idx % 3,
);

int makeRepeatingId(int current) {
  final ans = (current % count);
  print(ans);
  return ans;
}

var count = 1;

final timerListener = StreamProvider((ref) => timer);
