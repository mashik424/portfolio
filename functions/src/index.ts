/* eslint-disable max-len */
import {onCall, onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as nodemailer from "nodemailer";
import * as admin from "firebase-admin";
import {defineString} from "firebase-functions/params";
import corsLib from "cors";

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
  const {message, email} = request.data;

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

    return {success: true, message: "Email sent successfully."};
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
    const {skillId, newOrder} = request.body;

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
      const otherSkills = skillsSnapshot.docs.filter((doc) => doc.id !== skillId);

      // Reassign orders sequentially
      let order = 0;
      for (const doc of otherSkills) {
        if (order === newOrder) order++;
        batch.update(doc.ref, {order: order});
        order++;
      }

      // Set the new order for the updated skill
      batch.update(skillRef, {order: newOrder});

      await batch.commit();
      response.status(200).send("Skill order updated successfully.");
    } catch (error) {
      logger.error("Error updating skill order:", error);
      response.status(500).send("Failed to update skill order.");
    }
    return;
  });
});
