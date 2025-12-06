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
import { chapter8Notes } from "../data/chapter8Notes";
import { chapter8_1Notes } from "../data/chapter8_1Notes";
import { chapter9Notes } from "../data/chapter9Notes";
import { chapter10Notes } from "../data/chapter10Notes";
import { chapter11Notes } from "../data/chapter11Notes";
import { chapter12Notes } from "../data/chapter12Notes";
// import { chapter12_1Notes } from "../data/chapter12_1Notes";
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

export const seedNotesToChapter8 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter8", chapter8Notes);
      res.status(200).send("Chapter 8 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 8 notes.");
    }
  }
);

export const seedNotesToChapter8_1 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter8", chapter8_1Notes);
      res.status(200).send("Chapter 8 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 8 notes.");
    }
  }
);

export const seedNotesToChapter9 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter9", chapter9Notes);
      res.status(200).send("Chapter 8 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 8 notes.");
    }
  }
);

export const seedNotesToChapter10 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter10", chapter10Notes);
      res.status(200).send("Chapter 10 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 10 notes.");
    }
  }
);

export const seedNotesToChapter11 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter11", chapter11Notes);
      res.status(200).send("Chapter 10 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 10 notes.");
    }
  }
);

export const seedNotesToChapter12 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter12", chapter12Notes);
      res.status(200).send("Chapter 10 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 10 notes.");
    }
  }
);

// export const seedNotesToChapter13 = functions.https.onRequest(
//   async (req, res) => {
//     try {
//       await seedNotes("chapter13", chapter12_1Notes);
//       res.status(200).send("Chapter 10 notes seeded.");
//     } catch (err) {
//       console.error(err);
//       res.status(500).send("Error seeding Chapter 10 notes.");
//     }
//   }
// );
