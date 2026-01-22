import { onCall } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

if (!admin.apps.length) {
  admin.initializeApp();
}

export const existsUserCheckWithEmail = onCall(
  { region: "asia-northeast1", invoker: "public" },
  async (request) => {
    const email = request.data as string;
    if (!email) return false;

    try {
      await admin.auth().getUserByEmail(email);
      return true;
    } catch (e: any) {
      if (e.code === "auth/user-not-found") {
        return false;
      }
      throw e;
    }
  }
);
