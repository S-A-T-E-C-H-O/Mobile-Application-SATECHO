class SubscriptionModel {
  const SubscriptionModel({
    required this.id,
    required this.planType,
    required this.status,
    required this.billingCycle,
  });

  final int id;
  final String planType;
  final String status;
  final String billingCycle;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as int,
      planType: json['planType'] as String,
      status: json['status'] as String? ?? 'ACTIVE',
      billingCycle: json['billingCycle'] as String? ?? 'MONTHLY',
    );
  }
}
