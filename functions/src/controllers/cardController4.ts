import * as admin from "firebase-admin";
import { createCardData } from "../models/cardModel";

export async function addMissingCardsToUsers4() {
  const db = admin.firestore();
  const usersSnap = await db.collection("users").select("id").get(); // 必要なフィールドだけ取得

  for (const userDoc of usersSnap.docs) {
    const userId = userDoc.id;

    try {
      const cardsRef = db
        .collection("users")
        .doc(userId)
        .collection("learnedCards");

      const existingSnap = await cardsRef.select().get(); // ドキュメント ID のみ取得
      const existingIds = new Set(existingSnap.docs.map((d) => d.id));

      const batch = db.batch();
      for (let i = 744; i <= 862; i++) {
        const padded = i.toString().padStart(i <= 52 ? 2 : 3, "0");
        const cardId = `Card${padded}`;
        if (existingIds.has(cardId)) continue;

        const ref = cardsRef.doc(cardId);
        batch.set(ref, createCardData(cardId, `note${padded}`));
      }
      await batch.commit();
      console.log(`Successfully processed user: ${userId}`);
    } catch (err) {
      console.error(`Error processing user ${userId}:`, err);
    }
  }
}
