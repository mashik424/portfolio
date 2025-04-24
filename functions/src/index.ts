/* eslint-disable max-len */
import {onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as nodemailer from "nodemailer";
const functions = require('firebase-functions');

const pass = functions.config().nodemailer.pass;
const user = functions.config().nodemailer.user;


export const sendMessage = onCall(async (request) => {
  const {message, email} = request.data;

  if (!message || !email) {
    throw new Error("Message and email are required.");
  }

  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: user,
      pass: pass,
    },
  });

  const mailOptions = {
    from: email,
    to: user,
    subject: "New Message from Portfolio",
    text: `${email}: ${message}`,
  };

  try {
    await transporter.sendMail(mailOptions);
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
