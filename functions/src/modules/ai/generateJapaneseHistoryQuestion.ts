import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
import OpenAI from "openai";
import { onRequest } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";

// if (!admin.apps.length) {
//   admin.initializeApp();
// }

/** 必須 env */
// function requireEnv(name: string): string {
//   const v = process.env[name];
//   if (!v) throw new Error(`Missing environment variable: ${name}`);
//   return v;
// }

// export const generateJapaneseHistoryQuestion = onCall(
//   {
//     region: "asia-northeast1",
//     timeoutSeconds: 120,
//     minInstances: 1,
//     secrets: ["OPENAI_API_KEY"],
//   },
//   async (request) => {
//     try {
//       /* ===== 入力 ===== */
//       const answer = String(request.data?.answer ?? "").trim();
//       if (!answer) {
//         return { success: false, error: "empty_answer" };
//       }

//       /* ===== OpenAI ===== */
//       const openai = new OpenAI({
//         apiKey: requireEnv("OPENAI_API_KEY"),
//       });

//       /* ===== プロンプト ===== */
//       const prompt = `
// あなたは高校日本史（共通テスト〜難関大入試レベル）の出題者です。

// 以下に【答え】として与えられた日本史用語を、
// 学習者がその用語名を正確に答える必要がある「問題文」に変換してください。

// 【前提】
// ・学習者は基礎知識をすでに習得している（高習熟度）
// ・単純な定義確認は禁止
// ・背景・目的・機能・結果・他制度や人物との違いを手がかりに考えさせる

// 【制約】
// ・問題文中に【答え】を含めない
// ・答えが一意に定まる
// ・高校生が理解可能な表現
// ・出力は問題文のみ

// 【答え】
// ${answer}
// `.trim();

//       /* ===== OpenAI API ===== */
//       const completion = await openai.chat.completions.create({
//         model: "gpt-4o",
//         messages: [
//           {
//             role: "system",
//             content:
//               "You are a professional Japanese history exam question writer.",
//           },
//           { role: "user", content: prompt },
//         ],
//         temperature: 0.5,
//         top_p: 1.0,
//       });

//       const question = completion.choices[0]?.message?.content?.trim();
//       if (!question) {
//         throw new Error("empty_completion");
//       }

//       /* ===== 答え漏洩チェック ===== */
//       if (question.includes(answer)) {
//         throw new Error("answer_leak");
//       }

//       logger.info("Japanese history question generated", { answer });

//       return {
//         success: true,
//         question,
//       };
//     } catch (e) {
//       logger.error("generateJapaneseHistoryQuestion error", e);
//       return { success: false };
//     }
//   }
// );

if (!admin.apps.length) {
  admin.initializeApp();
}

// 🔑 Secret Manager（params）
const OPENAI_API_KEY = defineSecret("OPENAI_API_KEY");

export const generateJapaneseHistoryQuestion = onRequest(
  {
    region: "asia-northeast1",
    timeoutSeconds: 120,
    secrets: [OPENAI_API_KEY],
  },
  async (req, res) => {
    try {
      // ---- CORS ----
      res.set("Access-Control-Allow-Origin", "*");
      res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
      res.set("Access-Control-Allow-Headers", "Content-Type");

      if (req.method === "OPTIONS") {
        res.status(204).send("");
        return;
      }

      const answer = String(req.body?.answer ?? "").trim();
      if (!answer) {
        res.status(400).json({ success: false, error: "empty_answer" });
        return;
      }

      const openai = new OpenAI({
        apiKey: OPENAI_API_KEY.value(),
      });

      const prompt = `
あなたは高校日本史（共通テスト〜難関大入試レベル）の出題者です。
以下に【答え】として与えられた日本史用語を、
学習者がその用語名を正確に答える必要がある「問題文」に変換してください。
【答え】
${answer}
`.trim();

      const completion = await openai.chat.completions.create({
        model: "gpt-4o",
        messages: [
          {
            role: "system",
            content:
              "You are a professional Japanese history exam question writer.",
          },
          { role: "user", content: prompt },
        ],
        temperature: 0.5,
      });

      const question = completion.choices[0]?.message?.content?.trim();
      if (!question) {
        res.status(500).json({ success: false, error: "empty_completion" });
        return;
      }

      res.json({ success: true, question });
    } catch (e) {
      console.error(e);
      res.status(500).json({ success: false, error: "internal_error" });
    }
  }
);
