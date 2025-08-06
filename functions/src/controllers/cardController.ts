import * as admin from "firebase-admin";
import { createCardData } from "../models/cardModel";

export async function addMissingCardsToUsers() {
  const db = admin.firestore();
  const usersSnap = await db.collection("users").get();

  for (const userDoc of usersSnap.docs) {
    const userId = userDoc.id;
    const cardsRef = db
      .collection("users")
      .doc(userId)
      .collection("learnedCards");

    const existingSnap = await cardsRef.get();
    const existingIds = new Set(existingSnap.docs.map((d) => d.id));

    const batch = db.batch();
    for (let i = 53; i <= 136; i++) {
      const padded = i.toString().padStart(i <= 52 ? 2 : 3, "0");
      const cardId = `Card${padded}`;
      if (existingIds.has(cardId)) continue;

      const ref = cardsRef.doc(cardId);
      batch.set(ref, createCardData(cardId, `note${padded}`));
    }
    await batch.commit();
  }
}
