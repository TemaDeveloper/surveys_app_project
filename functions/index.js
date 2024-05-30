const functions = require("firebase-functions/v2");
const admin = require("firebase-admin");
admin.initializeApp();

// Scheduled function to check survey completion and send notifications
exports.checkSurveyCompletion = functions.pubsub.schedule("every day 00:00")
    .timeZone("Your/Timezone").onRun(async (context) => {
      const usersRef = admin.firestore().collection("users");
      const usersSnapshot = await usersRef.get();

      usersSnapshot.forEach(async (doc) => {
        const userData = doc.data();
        const surveyCompleted = userData.survey_completed || false;

        if (!surveyCompleted) {
          const message = {
            notification: {
              title: "Survey Reminder",
              body: "Please complete your survey for today.",
            },
            token: userData.fcm_token, // Ensure you save FCM token in Firestore
          };

          await admin.messaging().send(message);
        }
      });

      return null;
    });
