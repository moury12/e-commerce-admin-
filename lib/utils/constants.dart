const String currencySymbol = '৳';
const serverKey ='AAAAmq17HBI:APA91bFYqoPeN87MGX6DHkDBTETyG56XuLPLE0q2jfqKvNqp_aDP0tT1BqQbbQ85BE1740Pfo7U65WvxIwFMr6evswpV6C0aUJPbr2Bs81QK3BgszGHzvSXHwywnjFM9xd2l9LyvFMT8';
const cities = [
  'Dhaka',
  'Chittagong',
  'Rajshahi',
  'Khulna',
  'Barishal',
  'Sylhet',
  'Comilla',
  'Noakhali',
  'Faridpur',
  'Rangpur',
  'Gopalgonj'
];

abstract class OrderStatus {
  static const String pending = 'Pending';
  static const String processing = 'Processing';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';
  static const String returned = 'Returned';
}

abstract class PaymentMethod {
  static const String cod = 'Cash on Delivery';
  static const String online = 'Online Payment';
}

abstract class NotificationType {
  static const String comment = 'New Comment';
  static const String order = 'New Order';
  static const String user = 'New User';
}
