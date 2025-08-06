import * as functions from "firebase-functions/v1";
import { addMissingCardsToUsers4 } from "../controllers/cardController4";

export const addMissingCards4 = functions
  .runWith({ timeoutSeconds: 540 })
  .https.onRequest(async (req, res) => {
    try {
      await addMissingCardsToUsers4();
      res.status(200).send("All users updated.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error adding missing cards.");
    }
  });
