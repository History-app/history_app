import * as admin from "firebase-admin";
export function createNoteData(
  sfld: string,
  answer: string,
  theme: string,
  star: number
) {
  return {
    sfld,
    flds: [sfld, answer],
    theme,
    star,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
}
