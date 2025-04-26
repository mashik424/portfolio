/* eslint-disable max-len */
import { onCall, onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as nodemailer from "nodemailer";
import * as admin from "firebase-admin";
import { defineString } from "firebase-functions/params";
import corsLib from "cors";
import * as functions from "firebase-functions/v1";

admin.initializeApp();
const pass = defineString("PASS");
const user = defineString("USER");
const host1 = defineString("HOST1");
const host2 = defineString("HOST2");

const corsOptions = {
  origin: [host1.value(), host2.value()],
  // origin: true,
  methods: ["GET", "POST", "OPTIONS"],
  credentials: true,
};

const cors = corsLib(corsOptions);

export const sendMessage = onCall(async (request) => {
  const { message, email } = request.data;

  if (!message || !email) {
    throw new Error("Message and email are required.");
  }

  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: user.value(),
      pass: pass.value(),
    },
  });

  const mailOptions = {
    from: email,
    to: user.value(),
    subject: "New Message from Portfolio",
    text: `${email}: ${message}`,
  };

  try {
    transporter.sendMail(mailOptions);
    // const replyMailOptions = {
    //   from: user,
    //   to: email,
    //   subject: "Thank you for your message",
    //   text: "We have received your message and will get back to you shortly.",
    // };

    // await transporter.sendMail(replyMailOptions);

    return { success: true, message: "Email sent successfully." };
  } catch (error) {
    logger.error("Error sending email:", error);
    throw new Error("Failed to send email.");
  }
});

export const updateSkillOrder = onRequest(async (request, response) => {
  cors(request, response, async () => {
    if (request.method === "OPTIONS") {
      response.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
      response.set("Access-Control-Allow-Headers", "Content-Type");
      response.status(204).send("");
      return;
    }
    const { skillId, newOrder } = request.body;

    if (!skillId || newOrder === undefined) {
      throw new Error("Skill ID and new order are required.");
    }

    const db = admin.firestore();
    const skillsCollection = db.collection("skills");
    const skillRef = skillsCollection.doc(skillId);

    try {
      const skillDoc = await skillRef.get();

      if (!skillDoc.exists) {
        throw new Error("Skill not found.");
      }

      const batch = db.batch();

      // Get all skills to adjust their order
      const skillsSnapshot = await skillsCollection.orderBy("order").get();

      // Remove the skill being updated and collect other skills
      const otherSkills = skillsSnapshot.docs.filter(
        (doc) => doc.id !== skillId,
      );

      // Reassign orders sequentially
      let order = 0;
      for (const doc of otherSkills) {
        if (order === newOrder) order++;
        batch.update(doc.ref, { order: order });
        order++;
      }

      // Set the new order for the updated skill
      batch.update(skillRef, { order: newOrder });

      await batch.commit();
      response.status(200).send("Skill order updated successfully.");
    } catch (error) {
      logger.error("Error updating skill order:", error);
      response.status(500).send("Failed to update skill order.");
    }
    return;
  });
});
exports.onSkillAdded = functions.firestore
  .document("skills/{skillId}")
  .onCreate(async (snapshot, context) => {
    const skillData = snapshot.data();
    const skillId = context.params.skillId;

    if (!skillData) {
      logger.error("No skill data found for the created document.");
      return;
    }

    const db = admin.firestore();
    const skillsCollection = db.collection("skills");
    const lastSkillOrderCollection = db.collection("last_skill_order");

    try {
      const skillsSnapshot = await skillsCollection
        .orderBy("order", "desc")
        .limit(1)
        .get();
      const highestOrder = skillsSnapshot.empty
        ? 0
        : skillsSnapshot.docs[0].data().order;

      // Set the new skill's order to the next highest value
      await skillsCollection.doc(skillId).update({ order: highestOrder + 1 });
      // Update the first document in the last_skill_order collection with the new highest order
      const lastOrderDoc = await lastSkillOrderCollection.limit(1).get();
      if (!lastOrderDoc.empty) {
        const docId = lastOrderDoc.docs[0].id;
        await lastSkillOrderCollection
          .doc(docId)
          .set({ order: highestOrder + 1 });
      } else {
        await lastSkillOrderCollection.add({ order: highestOrder + 1 });
      }

      logger.info(`Skill ${skillId} added with order ${highestOrder + 1}.`);
    } catch (error) {
      logger.error("Error setting order for new skill:", error);
    }
  });

exports.onSkillDeleted = functions.firestore
  .document("skills/{skillId}")
  .onDelete(async (snapshot, context) => {
    const skillId = context.params.skillId;

    const db = admin.firestore();
    const skillsCollection = db.collection("skills");

    try {
      // Get all skills ordered by their current order
      const skillsSnapshot = await skillsCollection.orderBy("order").get();

      // Filter out the deleted skill and reassign orders sequentially
      const batch = db.batch();
      let order = 0;

      for (const doc of skillsSnapshot.docs) {
        if (doc.id !== skillId) {
          batch.update(doc.ref, { order: order });
          order++;
        }
      }
      // Update the first document in the last_skill_order collection with the new highest order
      const lastSkillOrderCollection = db.collection("last_skill_order");
      const lastOrderDoc = await lastSkillOrderCollection.limit(1).get();
      if (!lastOrderDoc.empty) {
        const docId = lastOrderDoc.docs[0].id;
        await lastSkillOrderCollection.doc(docId).set({ order: order });
      } else {
        await lastSkillOrderCollection.add({ order: order - 1 });
      }
      await batch.commit();
      logger.info(`Skill ${skillId} deleted and orders updated successfully.`);
    } catch (error) {
      logger.error("Error updating skill orders after deletion:", error);
    }
  });
