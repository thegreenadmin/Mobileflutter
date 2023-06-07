enum OrderStatus {

  userReady,
  cancelRequest,
  receivedOrder,
  inProgress,
  completed,
  inTransit,
  cancelled,
  cancellationRequest,
  readyForPickup,
  failed,
  returnRequest,
  returnConfirmed,
  returned,
  returnCancelled,
}

extension StatusExtension on OrderStatus {
  String get statusName {
    switch (this) {
      case OrderStatus.userReady:
        return 'user ready';
      case OrderStatus.cancelRequest:
        return 'cancel request';
      case OrderStatus.receivedOrder:
        return 'received';
      case OrderStatus.inProgress:
        return 'in progress';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.inTransit:
        return 'in transit';
      case OrderStatus.returnRequest:
        return 'return request';
      case OrderStatus.returnConfirmed:
        return 'return confirmed';
      case OrderStatus.returnCancelled:
        return 'return cancelled';
     case OrderStatus.returned:
        return 'returned';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.failed:
        return 'failed';
      case OrderStatus.cancellationRequest:
        return 'cancellation request';
      case OrderStatus.readyForPickup:
        return 'ready for pickup';
      default:
        return 'new';
    }
  }
}
