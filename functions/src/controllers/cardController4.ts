// // import * as admin from "firebase-admin";
// // import { createCardData } from "../models/cardModel";

// export async function addMissingCardsToUsers4() {
//   const db = admin.firestore();
//   const usersSnap = await db.collection("users").select("id").get(); // 必要なフィールドだけ取得
// // userId が先頭小文字英字のものだけを抽出し、小文字アルファベットの降順で処理
// const userDocsSorted = usersSnap.docs
//   .filter((d) => /^[a-z]/.test(d.id))
//   .sort((a, b) =>
//     b.id.toLowerCase().localeCompare(a.id.toLowerCase(), undefined, {
//       numeric: true,
//       sensitivity: "base",
//     })
//   );

//   for (usersSnap) {
//     const userId = usersSnap.id;

//     try {
//       const cardsRef = db
//         .collection("users")
//         .doc(userId)
//         .collection("learnedCards");

//       const existingSnap = await cardsRef.select().get(); // ドキュメント ID のみ取得
//       const existingIds = new Set(existingSnap.docs.map((d) => d.id));

//       const batch = db.batch();
//       for (let i = 744; i <= 976; i++) {
//         const padded = i.toString().padStart(i <= 52 ? 2 : 3, "0");
//         const cardId = `Card${padded}`;
//         if (existingIds.has(cardId)) continue;

//         const ref = cardsRef.doc(cardId);
//         batch.set(ref, createCardData(cardId, `note${padded}`));
//       }
//       await batch.commit();
//       console.log(`Successfully processed user: ${userId}`);
//     } catch (err) {
//       console.error(`Error processing user ${userId}:`, err);
//     }
//   }
// }

// import * as admin from "firebase-admin";
// import { createCardData } from "../models/cardModel";

// export async function addMissingCardsToUsers4() {
//   const db = admin.firestore();
//   const usersSnap = await db.collection("users").select("id").get(); // 必要なフィールドだけ取得

//   // // 先頭が大文字アルファベットのユーザーIDだけ抽出し、降順で処理
//   const userDocsSorted = usersSnap.docs
//     .filter((d) => /^[n-z]/.test(d.id))
//     .sort((a, b) =>
//       a.id.toUpperCase().localeCompare(a.id.toUpperCase(), undefined, {
//         numeric: true,
//         sensitivity: "base",
//       })
//     );

//   // for (const userDoc of usersSnap) {
//   for (const userDoc of userDocsSorted) {
//     const userId = userDoc.id;

//     try {
//       const cardsRef = db
//         .collection("users")
//         .doc("3QdLPt2WrNTq0aUDTdWUHqPAIUh2")
//         .collection("learnedCards");

//       const existingSnap = await cardsRef.select().get(); // ドキュメント ID のみ取得
//       const existingIds = new Set(existingSnap.docs.map((d) => d.id));

//       const batch = db.batch();
//       // TODO(Taniguchi): アプリ用のリリースでは、977から始まるようにしておく
//       for (let i = 977; i <= 3289; i++) {
//         const padded = i.toString().padStart(i <= 52 ? 2 : 3, "0");
//         const cardId = `Card${padded}`;
//         if (existingIds.has(cardId)) continue;

//         const ref = cardsRef.doc(cardId);
//         batch.set(ref, createCardData(cardId, `note${padded}`));
//       }
//       await batch.commit();
//       console.log(`Successfully processed user: ${userId}`);
//     } catch (err) {
//       console.error(`Error processing user ${userId}:`, err);
//     }
//   }
// }

import * as admin from "firebase-admin";
import { createCardData } from "../models/cardModel";

export async function addMissingCardsToUsers4() {
  const db = admin.firestore();

  // ★ 固定するユーザーID（ここだけ変えればOK）
  const userId = "K9UowAyefAMMND2ePgVLyEXpDQR2";

  try {
    const cardsRef = db
      .collection("users")
      .doc(userId)
      .collection("learnedCards");

    const existingSnap = await cardsRef.select().get();
    const existingIds = new Set(existingSnap.docs.map((d) => d.id));

    const batch = db.batch();

    for (let i = 977; i <= 3289; i++) {
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
