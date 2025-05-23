import fetch from "node-fetch";
import * as functions from "firebase-functions";

const WEBHOOK_URL = functions.config().slack.webhook_url;

export async function sendSlackNotification(message: string) {
  try {
    const payload = {
      text: message,
    };

    const response = await fetch(WEBHOOK_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      console.error("Slack送信失敗:", response.statusText);
    }
  } catch (err) {
    console.error("Slack送信エラー:", err);
  }
}
