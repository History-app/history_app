import * as admin from "firebase-admin";

export async function seedNotes(chapterId: string, notes: any[]) {
  const db = admin.firestore();
  const batch = db.batch();

  notes.forEach((note) => {
    const { id, ...noteData } = note;
    const ref = db
      .collection("books")
      .doc("book1")
      .collection("chapters")
      .doc(chapterId)
      .collection("notes")
      .doc(id);

    batch.set(ref, noteData);
  });

  await batch.commit();
}
