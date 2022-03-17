
import axios from "axios";
const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();
// // Create and Deploy Your First Cloud Functions
// // https
//://firebase.google.com/docs/functions/write-firebase-functions
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

 // install by running **npm install axios** inside your functions folder

export const serverRequest = functions.https.onCall(async (url, context)=> {
  const response = await axios.get(url as string).then(({data})=> data);
  return response;
});