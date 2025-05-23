import * as functions from "firebase-functions/v1";
import { handleAnonymousUserCreation } from "../controllers/userController";

export const createAnonymousUserDoc = functions.auth
  .user()
  .onCreate(handleAnonymousUserCreation);
