import * as functions from "firebase-functions/v1";
import { seedNotes } from "../controllers/noteController";
import { chapter1Notes } from "../data/chapter1Notes";
import { chapter2Notes } from "../data/chapter2Notes";
import { chapter3Notes } from "../data/chapter3Notes";
import { chapter4Notes } from "../data/chapter4Notes";
import { chapter5Notes } from "../data/chapter5Notes";
import { chapter6Notes } from "../data/chapter6Notes";
import { chapter7Notes } from "../data/chapter7Notes";
import { chapter7_1Notes } from "../data/chapter7Notes_1";

export const seedSampleNotesToChapter1 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter1", chapter1Notes);
      res.status(200).send("Chapter 1 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 1 notes.");
    }
  }
);

export const seedNotesToChapter2 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter2", chapter2Notes);
      res.status(200).send("Chapter 2 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 2 notes.");
    }
  }
);

export const seedNotesToChapter3 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter3", chapter3Notes);
      res.status(200).send("Chapter 3 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 3 notes.");
    }
  }
);

export const seedNotesToChapter4 = functions
  .runWith({ timeoutSeconds: 540 })
  .https.onRequest(async (req, res) => {
    try {
      // データをシード
      await seedNotes("chapter4", chapter4Notes);

      // 成功レスポンス
      res.status(200).send("Chapter 4 notes seeded.");
    } catch (err) {
      // エラー詳細をログに出力
      console.error("Error seeding Chapter 4 notes:", err);

      // エラーの種類に応じたレスポンス
      if (err instanceof Error) {
        res.status(500).send({
          message: "Error seeding Chapter 4 notes.",
          error: err.message,
          stack: err.stack, // スタックトレースを含める
        });
      } else {
        res.status(500).send({
          message: "Unknown error occurred while seeding Chapter 4 notes.",
          error: String(err),
        });
      }
    }
  });

export const seedNotesToChapter5 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter5", chapter5Notes);
      res.status(200).send("Chapter 5 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 5 notes.");
    }
  }
);

export const seedNotesToChapter6 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter6", chapter6Notes);
      res.status(200).send("Chapter 6 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 6 notes.");
    }
  }
);

export const seedNotesToChapter7 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter7", chapter7Notes);
      res.status(200).send("Chapter 7 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 7 notes.");
    }
  }
);

export const seedNotesToChapter7_1 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter7", chapter7_1Notes);
      res.status(200).send("Chapter 7_1 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 7_1 notes.");
    }
  }
);
