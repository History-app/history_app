import * as admin from "firebase-admin";
import { createCardData } from "../models/cardModel";
import { sendSlackNotification } from "../utils/slack";
export async function handleAnonymousUserCreation(user: admin.auth.UserRecord) {
  if (user.providerData.length === 0) {
    const userData = {
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isAnonymous: true,
    };

    const db = admin.firestore();
    await db.collection("users").doc(user.uid).set(userData);

    const batch = db.batch();
    for (let i = 1; i <= 1176; i++) {
      const padded = i.toString().padStart(i <= 52 ? 2 : 3, "0");
      const cardId = `Card${padded}`;
      const cardData = createCardData(cardId, `note${padded}`);

      const ref = db
        .collection("users")
        .doc(user.uid)
        .collection("learnedCards")
        .doc(cardId);
      batch.set(ref, cardData);
    }
    await batch.commit();
    await sendSlackNotification(
      `新しくユーザーがアプリをインストールしました。`
    );
  }
}
