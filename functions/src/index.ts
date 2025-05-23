import * as admin from "firebase-admin";

import { addMissingCards } from "./routes/cardRoutes";
import { createAnonymousUserDoc } from "./routes/userRoutes";
import {
  seedSampleNotesToChapter1,
  seedNotesToChapter3,
} from "./routes/noteRoutes";

admin.initializeApp();

export {
  addMissingCards,
  createAnonymousUserDoc,
  seedSampleNotesToChapter1,
  seedNotesToChapter3,
};
