enum OrderStatus {
  readyPickup,
  userReady,
  cancelRequest,
  created,
  newOrder,
  pending,
  confirmed,
  delivered,
  shipped,
  cancelled,
  cancellationRequest,
  pickupRequest,
  failed,
  returnRequest,
  returnConfirmed,
  returnCompleted,
  returnCancelled,
}

extension StatusExtension on OrderStatus {
  String get statusName {
    switch (this) {
      case OrderStatus.readyPickup:
        return 'ready pickup';
      case OrderStatus.userReady:
        return 'user ready';
      case OrderStatus.cancelRequest:
        return 'cancel request';
      case OrderStatus.created:
        return 'created';
      case OrderStatus.newOrder:
        return 'new';
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.returnRequest:
        return 'return request';
      case OrderStatus.returnConfirmed:
        return 'return confirmed';
      case OrderStatus.returnCancelled:
        return 'return cancelled';
     case OrderStatus.returnCompleted:
        return 'return completed';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.failed:
        return 'failed';
      case OrderStatus.cancellationRequest:
        return 'cancellation request';
      case OrderStatus.pickupRequest:
        return 'pickup request';
      default:
        return 'new';
    }
  }
}
