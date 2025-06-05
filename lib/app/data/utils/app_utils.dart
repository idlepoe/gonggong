import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'logger.dart';

class AppUtils {
  static DateTime parseCompactDateTime(String compact) {
    if (compact.length != 12) {
      throw FormatException('Expected date string of length 12, got ${compact.length}');
    }

    final year = int.parse(compact.substring(0, 4));
    final month = int.parse(compact.substring(4, 6));
    final day = int.parse(compact.substring(6, 8));
    final hour = int.parse(compact.substring(8, 10));
    final minute = int.parse(compact.substring(10, 12));

    return DateTime(year, month, day, hour, minute);
  }
}