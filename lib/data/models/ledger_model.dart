class LedgerEntryModel {
  final int? id;
  final DateTime date;
  final String accountCode;
  final String accountName;
  final String description;
  final double? debit;
  final double? credit;
  final String? reference;
  final String? documentNumber;
  final int userId;
  final int companyId;
  final DateTime createdAt;

  LedgerEntryModel({
    this.id,
    required this.date,
    required this.accountCode,
    required this.accountName,
    required this.description,
    this.debit,
    this.credit,
    this.reference,
    this.documentNumber,
    required this.userId,
    required this.companyId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'accountCode': accountCode,
    'accountName': accountName,
    'description': description,
    'debit': debit,
    'credit': credit,
    'reference': reference,
    'documentNumber': documentNumber,
    'userId': userId,
    'companyId': companyId,
    'createdAt': createdAt.toIso8601String(),
  };

  factory LedgerEntryModel.fromMap(Map<String, dynamic> map) => LedgerEntryModel(
    id: map['id'],
    date: DateTime.parse(map['date']),
    accountCode: map['accountCode'],
    accountName: map['accountName'],
    description: map['description'],
    debit: map['debit']?.toDouble(),
    credit: map['credit']?.toDouble(),
    reference: map['reference'],
    documentNumber: map['documentNumber'],
    userId: map['userId'],
    companyId: map['companyId'],
    createdAt: DateTime.parse(map['createdAt']),
  );
}
