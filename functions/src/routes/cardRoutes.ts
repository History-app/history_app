import * as functions from "firebase-functions/v1";
import { addMissingCardsToUsers } from "../controllers/cardController";

export const addMissingCards = functions.https.onRequest(async (req, res) => {
  try {
    await addMissingCardsToUsers();
    res.status(200).send("All users updated.");
  } catch (err) {
    console.error(err);
    res.status(500).send("Error adding missing cards.");
  }
});
