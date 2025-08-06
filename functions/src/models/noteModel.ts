import * as admin from "firebase-admin";
export function createNoteData(
  sfld: string,
  answer: string,
  kana: string,
  theme: string,
  star: number,
  id: string
) {
  return {
    sfld,
    flds: [sfld, answer, kana],
    theme,
    star,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    id,
    hnref: null,
  };
}
