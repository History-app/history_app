import { onCall } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import * as admin from "firebase-admin";
import {
  SESClient,
  SendEmailCommand,
  GetSendQuotaCommand,
} from "@aws-sdk/client-ses";

if (!admin.apps.length) {
  admin.initializeApp();
}

/** 必須 env */
function requireEnv(name: string): string {
  const v = process.env[name];
  if (!v) throw new Error(`Missing environment variable: ${name}`);
  return v;
}

export const createAuthEmailLink = onCall(
  {
    region: "asia-northeast1",
    timeoutSeconds: 540,
    minInstances: 1,
    secrets: [
      "AWS_ACCESS_KEY_ID",
      "AWS_SECRET_ACCESS_KEY",
      "AWS_REGION",
      "SES_FROM",
      "IOS_BUNDLE_ID",
      "ANDROID_PACKAGE_NAME",
      "AF_BRANDED_DOMAIN",
    ],
  },
  async (request) => {
    try {
      const email = String(request.data?.email ?? "").trim();
      if (!email) {
        return { success: false, error: "empty_email" };
      }

      const AWS_REGION = requireEnv("AWS_REGION");
      const SES_FROM = requireEnv("SES_FROM");
      const IOS_BUNDLE_ID = requireEnv("IOS_BUNDLE_ID");
      const ANDROID_PACKAGE_NAME = requireEnv("ANDROID_PACKAGE_NAME");
      const AF_BRANDED_DOMAIN = requireEnv("AF_BRANDED_DOMAIN");
      const PROJECT_ID = requireEnv("GCLOUD_PROJECT");

      /* ===== SES ===== */
      const ses = new SESClient({ region: AWS_REGION });
      await ses.send(new GetSendQuotaCommand({}));
      logger.info("SES getSendQuota success");

      /* ===== Firebase Auth link（内部用） ===== */
      const actionCodeSettings: admin.auth.ActionCodeSettings = {
        url: `https://${PROJECT_ID}.firebaseapp.com/__/auth/action`,
        handleCodeInApp: true,
        iOS: { bundleId: IOS_BUNDLE_ID },
        android: {
          packageName: ANDROID_PACKAGE_NAME,
          installApp: true,
          minimumVersion: "1",
        },
      };

      const authLink = await admin
        .auth()
        .generateSignInWithEmailLink(email, actionCodeSettings);

      /* ===== AppsFlyer OneLink（メールに貼る本体） ===== */
      const oneLinkUrl = new URL(`https://${AF_BRANDED_DOMAIN}/0TsM/3niirflt`);

      oneLinkUrl.searchParams.set("deep_link_value", "signin");
      oneLinkUrl.searchParams.set("af_sub1", email);

      // 🔴 authLink は URL なので必ず encode
      oneLinkUrl.searchParams.set("af_sub2", encodeURIComponent(authLink));

      const mailLink = oneLinkUrl.toString();

      /* ===== SES メール送信 ===== */
      await ses.send(
        new SendEmailCommand({
          Source: SES_FROM,
          Destination: { ToAddresses: [email] },
          Message: {
            Subject: {
              Data: "【これだけ日本史一問一答】メールアドレス認証のご案内",
              Charset: "UTF-8",
            },
            Body: {
              Html: {
                Charset: "UTF-8",
                Data: `
<p>以下のリンクをタップしてログインしてください。</p>
<p><a href="${mailLink}">ログインする</a></p>
<p>※ このリンクは24時間有効です。</p>
`,
              },
              Text: {
                Charset: "UTF-8",
                Data: `
以下のリンクを開いてログインしてください。

${mailLink}
`,
              },
            },
          },
        })
      );

      logger.info("Auth mail sent", { email });
      return { success: true };
    } catch (e) {
      logger.error("createAuthEmailLink error", e);
      return { success: false };
    }
  }
);
