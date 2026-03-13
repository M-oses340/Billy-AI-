// Notification service for sending alerts to users

export interface Notification {
  userId: string;
  title: string;
  message: string;
  type: 'success' | 'warning' | 'error' | 'info';
  data?: any;
}

export async function sendNotification(notification: Notification): Promise<void> {
  // TODO: Implement with Firebase Cloud Messaging or similar
  console.log('📱 Notification:', notification);
  
  // For now, just log. In production, integrate with:
  // - Firebase Cloud Messaging (FCM)
  // - OneSignal
  // - Pusher
  // - Custom WebSocket
}

export async function sendBillPaidNotification(
  userId: string,
  biller: string,
  amount: number,
  txHash: string
): Promise<void> {
  await sendNotification({
    userId,
    title: '✅ Bill Paid',
    message: `${biller}: $${amount} paid successfully`,
    type: 'success',
    data: { txHash },
  });
}

export async function sendLowBalanceNotification(
  userId: string,
  biller: string,
  needed: number,
  current: number
): Promise<void> {
  await sendNotification({
    userId,
    title: '⚠️ Low Balance',
    message: `Need $${needed} more to pay ${biller}. Current: $${current}`,
    type: 'warning',
    data: { needed, current },
  });
}

export async function sendBillDetectedNotification(
  userId: string,
  biller: string,
  amount: number,
  dueDate: Date
): Promise<void> {
  await sendNotification({
    userId,
    title: '📋 New Bill Detected',
    message: `${biller}: $${amount} due ${dueDate.toLocaleDateString()}`,
    type: 'info',
    data: { biller, amount, dueDate },
  });
}
