import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
import OpenAI from "openai";
import { onRequest } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";

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
      const era = String(req.body?.era ?? "").trim();

      if (!answer) {
        res.status(400).json({ success: false, error: "empty_answer" });
        return;
      }

      if (!era) {
        res.status(400).json({ success: false, error: "empty_era" });
        return;
      }

      const openai = new OpenAI({
        apiKey: OPENAI_API_KEY.value(),
      });

      const prompt = `
あなたは高校日本史（共通テスト〜難関大入試レベル）の出題者です。

以下に【答え】として与えられた日本史用語について、
その用語が想定される【時代】を内部条件として踏まえたうえで、
学習者が用語名を正確に特定できる一問一答形式の「問題文」を作成してください。

【前提】
・学習者は基礎知識をすでに習得している（高習熟度）
・単純な定義確認は禁止
・背景・立場・機能・政治的文脈・他時代との差異を手がかりに考えさせる

【制約】
・問題文中に【答え】は含めない
・【時代】を必ずしも明示する必要はない
・ただし【時代】を誤ると成立しない条件を少なくとも1つ含める
・同名人物・同系制度・類似用語と混同しない内容にする
・答えが一意に定まる
・高校生が理解可能な表現
・出力は問題文のみ
・解答は単一の日本史用語（名詞）1語のみを想定
・論述誘導は禁止

【時代】
${era}

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
