const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const fcm = admin.messaging();

exports.sendNotification = functions.https.onCall(async (data, context) => {
  const title = data.title;
  const body = data.body;
  const image = data.image;
  const token = data.token;

  try {
    const payload = {
      token: token,
      notification: {
        title: title,
        body: body,
        image: image,
      },
      data: {
        body: body,
      },
    };
    return fcm
        .send(payload)
        .then((res) => {
          return {success: true, response: "Successfully sent message: " + res};
        })
        .catch((error) => {
          return {error: error};
        });
  } catch (error) {
    throw new functions.https.HttpsError("invalid-argument", "error: " + error);
  }
});
