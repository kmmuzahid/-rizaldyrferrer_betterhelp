library corekit_compat;

export 'package:core_kit/core_kit.dart';
export 'package:core_kit/network/ck_response.dart';
export 'package:core_kit/network/ck_transport.dart';
export 'package:core_kit/network/request_input.dart';
export 'package:core_kit/utils/ck_screen_utils.dart';
export 'package:core_kit/button/ck_button.dart';
export 'package:core_kit/text/ck_text.dart';
export 'package:core_kit/text_field/ck_text_field.dart';
export 'package:core_kit/text_field/ck_validation_type.dart';

import 'package:core_kit/network/ck_transport.dart';
import 'package:core_kit/network/ck_response.dart';
import 'package:core_kit/network/request_input.dart';

typedef ResponseState<T> = CkResponse<T>;
