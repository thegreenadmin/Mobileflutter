enum OrderStatusEnum {
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

extension StatusExtension on OrderStatusEnum {
  String get statusName {
    switch (this) {
      case OrderStatusEnum.userReady:
        return 'user ready';
      case OrderStatusEnum.cancelRequest:
        return 'cancel request';
      case OrderStatusEnum.receivedOrder:
        return 'received';
      case OrderStatusEnum.inProgress:
        return 'in progress';
      case OrderStatusEnum.completed:
        return 'completed';
      case OrderStatusEnum.inTransit:
        return 'in transit';
      case OrderStatusEnum.returnRequest:
        return 'return request';
      case OrderStatusEnum.returnConfirmed:
        return 'return confirmed';
      case OrderStatusEnum.returnCancelled:
        return 'return cancelled';
      case OrderStatusEnum.returned:
        return 'returned';
      case OrderStatusEnum.cancelled:
        return 'cancelled';
      case OrderStatusEnum.failed:
        return 'failed';
      case OrderStatusEnum.cancellationRequest:
        return 'cancellation request';
      case OrderStatusEnum.readyForPickup:
        return 'ready for pickup';
      default:
        return 'new';
    }
  }
}
