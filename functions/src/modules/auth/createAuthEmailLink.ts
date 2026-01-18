import { onCall } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import * as admin from "firebase-admin";
import {
  SESClient,
  SendEmailCommand,
  GetSendQuotaCommand,
} from "@aws-sdk/client-ses";
import {
  PACKAGE_NAME,
  ANDROID_PACKAGE_NAME,
  AF_BRANDED_DOMAIN,
} from "../../constants";

if (!admin.apps.length) {
  admin.initializeApp();
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
    ],
  },
  async (request) => {
    try {
      const email = String(request.data?.email ?? "").trim();
      if (!email) {
        return { success: false, error: "empty_email" };
      }

      /** AWS SES Client */
      const ses = new SESClient({
        region: process.env.AWS_REGION ?? "ap-northeast-1",
        credentials: {
          accessKeyId: process.env.AWS_ACCESS_KEY_ID!,
          secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY!,
        },
      });

      /** 🔍 SES 認証チェック */
      const quota = await ses.send(new GetSendQuotaCommand({}));
      logger.info("SES getSendQuota success", quota);

      /** Firebase Auth 認証リンク */
      const actionCodeSettings: admin.auth.ActionCodeSettings = {
        url: `https://${AF_BRANDED_DOMAIN}/0TsM/3niirflt`,
        handleCodeInApp: true,
        iOS: { bundleId: PACKAGE_NAME },
        android: {
          packageName: ANDROID_PACKAGE_NAME,
          installApp: true,
          minimumVersion: "1",
        },
      };

      const authLink = await admin
        .auth()
        .generateSignInWithEmailLink(email, actionCodeSettings);

      /** AppsFlyer OneLink */
      const oneLinkUrl = new URL(`https://${AF_BRANDED_DOMAIN}/0TsM/3niirflt`);
      oneLinkUrl.searchParams.set("deep_link_value", "signin");
      oneLinkUrl.searchParams.set("af_sub1", email);
      oneLinkUrl.searchParams.set("af_sub2", encodeURIComponent(authLink));

      /** SES メール送信 */
      await ses.send(
        new SendEmailCommand({
          Source: process.env.SES_FROM!,
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
<p><a href="${oneLinkUrl.toString()}">ログインする</a></p>
<p>※ このリンクは24時間有効です。</p>
`,
              },
              Text: {
                Charset: "UTF-8",
                Data: `
以下のリンクを開いてログインしてください。

${oneLinkUrl.toString()}
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
