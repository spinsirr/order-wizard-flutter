import 'package:order_wizard/models/order.dart';
import 'package:sqlite3/sqlite3.dart';

class OrderService {
  late final Database db;
  
  OrderService() {
    db = sqlite3.open('orders.db');
    db.execute('''
      CREATE TABLE IF NOT EXISTS orders (
        order_number TEXT PRIMARY KEY,
        amount REAL,
        image_uri TEXT,
        comment_with_picture INTEGER,
        commented INTEGER,
        revealed INTEGER,
        reimbursed INTEGER,
        reimbursed_amount REAL,
        note TEXT
      )
    ''');
  }

  Future<List<Order>> getOrders() async {
    final ResultSet results = db.select('SELECT * FROM orders');
    return results.map((row) => Order.fromJson({
      'orderNumber': row['order_number'],
      'amount': row['amount'],
      'imageUri': row['image_uri'],
      'commentWithPicture': row['comment_with_picture'] == 1,
      'commented': row['commented'] == 1,
      'revealed': row['revealed'] == 1,
      'reimbursed': row['reimbursed'] == 1,
      'reimbursedAmount': row['reimbursed_amount'],
      'note': row['note'],
    })).toList();
  }

  Future<void> addOrder(Order order) async {
    db.execute(
      'INSERT INTO orders (order_number, amount, image_uri, comment_with_picture, commented, revealed, reimbursed, reimbursed_amount, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        order.orderNumber,
        order.amount,
        order.imageUri,
        order.commentWithPicture ? 1 : 0,
        order.commented ? 1 : 0,
        order.revealed ? 1 : 0,
        order.reimbursed ? 1 : 0,
        order.reimbursedAmount,
        order.note,
      ]
    );
  }

  Future<void> updateOrder(Order order) async {
    db.execute(
      '''UPDATE orders SET 
        amount = ?, 
        image_uri = ?, 
        comment_with_picture = ?, 
        commented = ?, 
        revealed = ?, 
        reimbursed = ?, 
        reimbursed_amount = ?, 
        note = ? 
      WHERE order_number = ?''',
      [
        order.amount,
        order.imageUri,
        order.commentWithPicture ? 1 : 0,
        order.commented ? 1 : 0,
        order.revealed ? 1 : 0,
        order.reimbursed ? 1 : 0,
        order.reimbursedAmount,
        order.note,
        order.orderNumber,
      ]
    );
  }

  Future<void> deleteOrder(Order order) async {
    db.execute('DELETE FROM orders WHERE order_number = ?', [order.orderNumber]);
  }

  void dispose() {
    db.dispose();
  }
}