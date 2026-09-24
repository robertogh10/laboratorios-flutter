const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');

initializeApp();

exports.notifyPurchase = onDocumentCreated('sales/{saleId}', async (event) => {
  // Cloud Messaging has no local emulator. The app shows a local notification
  // after checkout while Auth, Firestore and Storage run in Emulator Suite.
  if (process.env.FUNCTIONS_EMULATOR === 'true') return;

  const sale = event.data?.data();
  if (typeof sale?.userId !== 'string' || sale.userId.length === 0) return;

  const user = await getFirestore().collection('users').doc(sale.userId).get();
  const token = user.get('fcmToken');
  if (typeof token !== 'string' || token.length === 0) return;

  const saleId = event.params.saleId;
  const route = `/store/sales/${encodeURIComponent(saleId)}`;
  const total = Number(sale.total);
  const amount = Number.isFinite(total) ? ` por € ${total.toFixed(2)}` : '';

  try {
    await getMessaging().send({
      token,
      notification: {
        title: 'Compra registrada',
        body: `Tu compra${amount} fue registrada. Toca para ver el resumen.`,
      },
      data: { route, saleId },
      android: {
        notification: { channelId: 'high_priority_notifications' },
      },
    });
  } catch (error) {
    console.error(`No se pudo enviar la notificación de la compra ${saleId}:`, error);
  }
});
