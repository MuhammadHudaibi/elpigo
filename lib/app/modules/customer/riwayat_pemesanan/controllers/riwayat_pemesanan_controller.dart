import 'package:get/get.dart';

class RiwayatPemesananController extends GetxController {
  var transactions = <Transaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  void fetchTransactions() {
    var transactionList = [
      Transaction(
        itemName: "Laptop",
        purchaseDate: "2023-05-20",
        status: "Selesai",
        quantity: 1,
        price: 15000000,
        note: "Pembelian pertama",
      ),
      Transaction(
        itemName: "Smartphone",
        purchaseDate: "2023-04-18",
        status: "Dikirim",
        quantity: 2,
        price: 7000000,
        note: "Hadiah ulang tahun",
      ),
      // Tambahkan transaksi lain di sini
    ];

    transactions.addAll(transactionList);
  }
}
class Transaction {
  final String itemName;
  final String purchaseDate;
  final String status;
  final int quantity;
  final int price;
  final String note;

  Transaction({
    required this.itemName,
    required this.purchaseDate,
    required this.status,
    required this.quantity,
    required this.price,
    required this.note,
  });
}

