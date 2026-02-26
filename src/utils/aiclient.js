// const axios = require("axios");
// const fs = require("fs");
// require("dotenv").config();

// // You can change model later if needed
// // const HF_MODEL = "nateraw/vit-base-beans";

// async function classifyImage(imagePath) {
//   try {
//     const imageData = fs.readFileSync(imagePath);

//     const response = await axios.post(
//       `https://router.huggingface.co/models/${HF_MODEL}`,
//       imageData,
//       {
//         headers: {
//           Authorization: `Bearer ${process.env.HF_API_KEY}`,
//           "Content-Type": "application/octet-stream",
//         },
//       }
//     );

//     return response.data;

//   } catch (error) {
//   console.log("FULL HF ERROR:");
//   console.log(error.response?.data);
//   console.log(error.response?.status);
//   console.log(error.message);

//   throw error; // temporarily throw real error
// }
// }

// module.exports = { classifyImage };


const axios = require("axios");
const fs = require("fs");
const FormData = require("form-data");

async function classifyImage(imagePath) {
  try {
    const form = new FormData();
    form.append("image", fs.createReadStream(imagePath));

    const response = await axios.post(
      "https://validation-p2m5.onrender.com/predict",
      form,
      {
        headers: form.getHeaders(),
      }
    );

    console.log("AI RESPONSE:", response.data);

    return response.data;

  } catch (error) {
    console.error("AI ERROR:", error.response?.data || error.message);
    throw new Error("AI classification failed");
  }
}

module.exports = { classifyImage };