import { onCall } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import * as admin from "firebase-admin";
import OpenAI from "openai";

if (!admin.apps.length) {
  admin.initializeApp();
}

/** 必須 env */
function requireEnv(name: string): string {
  const v = process.env[name];
  if (!v) throw new Error(`Missing environment variable: ${name}`);
  return v;
}

export const generateJapaneseHistoryQuestion = onCall(
  {
    region: "asia-northeast1",
    timeoutSeconds: 120,
    minInstances: 1,
    secrets: ["OPENAI_API_KEY"],
  },
  async (request) => {
    try {
      /* ===== 入力 ===== */
      const answer = String(request.data?.answer ?? "").trim();
      if (!answer) {
        return { success: false, error: "empty_answer" };
      }

      const OPENAI_API_KEY = requireEnv("OPENAI_API_KEY");

      const openai = new OpenAI({
        apiKey: OPENAI_API_KEY,
      });

      /* ===== プロンプト ===== */
      const prompt = `
あなたは高校日本史（共通テスト〜難関大入試レベル）の出題者です。

以下に【答え】として与えられた日本史用語を、
学習者がその用語名を正確に答える必要がある「問題文」に変換してください。

【前提】
・学習者は基礎知識をすでに習得している（高習熟度）
・単純な定義確認（「〇〇とは何か」）は禁止
・背景・目的・機能・結果・他制度や他人類段階との違いなどを手がかりに考えさせる
・最終的に答えは【答え】の語句そのものになるようにする

【制約】
・問題文中に【答え】を含めてはいけない
・答えが一意に定まるようにする
・高校生が理解可能な表現にする
・出力は問題文のみ（余計な説明は禁止）

【答え】
${answer}

この【答え】を導く問題文を作成してください。
      `.trim();

      /* ===== OpenAI API ===== */
      const completion = await openai.chat.completions.create({
        model: "gpt-4o",
        messages: [
          {
            role: "system",
            content:
              "You are a professional Japanese history exam question writer.",
          },
          {
            role: "user",
            content: prompt,
          },
        ],
        temperature: 0.5,
        top_p: 1.0,
      });

      const question = completion.choices[0]?.message?.content?.trim() ?? "";

      if (!question) {
        throw new Error("empty_completion");
      }

      /* ===== 保険：答え漏洩チェック ===== */
      if (question.includes(answer)) {
        throw new Error("answer_leaked_in_question");
      }

      logger.info("Japanese history question generated", {
        answer,
      });

      return {
        success: true,
        question,
      };
    } catch (e) {
      logger.error("generateJapaneseHistoryQuestion error", e);
      return { success: false };
    }
  }
);
