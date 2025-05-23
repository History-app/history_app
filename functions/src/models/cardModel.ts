import * as admin from "firebase-admin";

export function createCardData(id: string, noteRef: string) {
  return {
    noteRef,
    left: null,
    lapses: 0,
    ivl: 1,
    type: 0,
    queue: 0,
    reps: 0,
    due: null,
    factor: 2500,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  };
}
