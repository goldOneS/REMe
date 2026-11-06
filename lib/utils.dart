import 'package:intl/intl.dart';

final fmtDate = DateFormat('dd/MM/yyyy HH:mm');
final fmtMoney = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

const _meses = [
  'ene', 'feb', 'mar', 'abr', 'may', 'jun',
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
];

String monthShort(DateTime d) => _meses[d.month - 1];

final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
bool isValidEmail(String v) => _emailRe.hasMatch(v);
