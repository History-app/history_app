import * as admin from "firebase-admin";
import { addMissingCards } from "./routes/cardRoutes";
import { addMissingCards4 } from "./routes/cardRoutesChapter4";
import { createAnonymousUserDoc } from "./routes/userRoutes";
import {
  seedSampleNotesToChapter1,
  seedNotesToChapter2,
  seedNotesToChapter3,
  seedNotesToChapter4,
  seedNotesToChapter5,
  seedNotesToChapter6,
} from "./routes/noteRoutes";

admin.initializeApp();

export {
  addMissingCards,
  addMissingCards4,
  createAnonymousUserDoc,
  seedSampleNotesToChapter1,
  seedNotesToChapter2,
  seedNotesToChapter3,
  seedNotesToChapter4,
  seedNotesToChapter5,
  seedNotesToChapter6,
};
