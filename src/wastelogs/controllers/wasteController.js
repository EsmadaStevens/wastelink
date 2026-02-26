const { classifyImage } = require("../../../src/utils/aiclient");

const { WasteLog } = require("../../../models");

// const ALLOWED_CATEGORIES = [
//   "Plastic",
//   "Organic",
//   "Metal",
//   "Glass",
//   "Electronic"
// ];


// const ALLOWED_VOLUMES = [
//   "Small",
//   "Medium",
//   "Large",
//   "Extra Large"
// ];


// const createWasteLog = async (req, res) => {
//   try {
//     const { category, volume, location, lga } = req.body;

//     // Validate category
//     if (!ALLOWED_CATEGORIES.includes(category)) {
//       return res.status(400).json({
//         success: false,
//         message: "Validation error",
//         reason: `Category must be one of: ${ALLOWED_CATEGORIES.join(", ")}`
//       });
//     }

//     // Validate volume
//     if (!ALLOWED_VOLUMES.includes(volume)) {
//       return res.status(400).json({
//         success: false,
//         message: "Validation error",
//         reason: `Volume must be one of: ${ALLOWED_VOLUMES.join(", ")}`
//       });
//     }

//     const wasteLog = await WasteLog.create({
//       category,
//       volume,
//       location,
//       lga: req.user.lga,
//       userId: req.user.id // attach authenticated user
//     });

//     return res.status(201).json({
//       success: true,
//       message: "Waste logged successfully",
//       data: wasteLog,
//       loggedBy: req.user.role
//     });

//   } catch (error) {
//     return res.status(500).json({
//       success: false,
//       message: "Server error",
//       reason: error.message
//     });
//   }
// };


// const createWasteLog = async (req, res) => {
//   try {
//     const { wasteType, volume } = req.body;
//     // Save image locally
//     const imagePath = req.file.path;
//     // THIS IS WHERE WE CALL AI
//     const formData = new FormData();
//     formData.append("image", fs.createReadStream(imagePath));
//     // THIS URL COMES FROM DATA SCIENCE TEAM
//     const aiResponse = await axios.post(
//         // "http://127.0.0.1:8000/predict",
//       process.env.AI_SERVICE_URL,
//       formData,
//       { headers: formData.getHeaders() }
//     );

//     const prediction = aiResponse.data.predicted_class;
//     const confidence = aiResponse.data.confidence;

//     // END AI CALL
//     const log = await WasteLog.create({
//       wasteType,
//       volume,
//       lga: req.user.lga,
//       userId: req.user.id,
//       imageUrl: imagePath,
//       aiPrediction: prediction,
//       aiConfidence: confidence,
//       status: "pending",
//     });

//     res.json({
//       message: "Waste log created successfully",
//       log,
//     });

//   } catch (error) {
//     res.status(500).json({ message: "Error creating waste log" });
//   }
// };

// createWasteLog
// const createWasteLog = async (req, res) => {
//   try {
//     console.log("BODY:", req.body);
//     console.log("FILE:", req.file);

//     if (!req.body) {
//       return res.status(400).json({
//         message: "No body received. Make sure you are using form-data."
//       });
//     }

//     const { wasteType, volume } = req.body;
//     const imagePath = req.file.path;

//     // =====================
//     // Call HF AI classifier
//     // =====================
//     const predictionData = await classifyImage(imagePath);

//     // Pick top label
//     let top = predictionData[0];
//     for (let i = 1; i < predictionData.length; i++) {
//       if (predictionData[i].score > top.score) top = predictionData[i];
//     }

//     const label = top.label.toLowerCase();

//     let aiCategory = "General";
//     if (label.includes("plastic")) aiCategory = "Plastic";
//     else if (label.includes("metal")) aiCategory = "Metal";
//     else if (label.includes("paper")) aiCategory = "Paper";
//     else if (label.includes("organic") || label.includes("food")) aiCategory = "Organic";

//     const log = await WasteLog.create({
//       wasteType,
//       volume,
//       lga: req.user.lga,
//       userId: req.user.id,
//       imageUrl: imagePath,
//       aiPrediction: aiCategory,
//       aiConfidence: top.score,
//       status: "pending",
//     });

//     res.json({
//       message: "Waste log created successfully",
//       log,
//     });

//   } catch (error) {
//     res.status(500).json({ message: "Error creating waste log", error: error.message });
//   }
// };

const createWasteLog = async (req, res) => {
  try {
    console.log("BODY:", req.body);
    console.log("FILE:", req.file);

    // Validate request
    if (!req.body || !req.file) {
      return res.status(400).json({
        message: "Missing wasteType, volume or image. Use form-data."
      });
    }

    const { wasteType, volume } = req.body;
    const imagePath = req.file.path;

    // 1️⃣ Call Data Science AI API
    const predictionData = await classifyImage(imagePath);

    console.log("AI RESPONSE:", predictionData);

    // 2️⃣ Extract prediction
    const aiCategory = predictionData.prediction;
    const aiConfidence = predictionData.confidence;

    // 3️⃣ Save to database
    const log = await WasteLog.create({
      wasteType,
      volume,
      lga: req.user.lga,
      userId: req.user.id,
      imageUrl: imagePath,
      aiPrediction: aiCategory,        // "metal"
      aiConfidence: aiConfidence,      // 0.7089...
      status: "pending",
    });

    return res.status(201).json({
      message: "Waste log created successfully",
      log,
    });

  } catch (error) {
    console.error("CREATE WASTE ERROR:", error);
    return res.status(500).json({
      message: "Error creating waste log",
      error: error.message,
    });
  }
};
//getWasteLogs
const getWasteLogs = async (req, res) => {
  try {
    const { category, volume, lga } = req.query;

    let whereClause = {};

    // Role-based filtering
    if (req.user.role === "SME") {
      whereClause.userId = req.user.id;
    }

    // Optional filters
    if (category) {
      whereClause.category = category;
    }

    if (volume) {
      whereClause.volume = volume;
    }

    if (lga) {
      whereClause.lga = lga;
    }

    const logs = await WasteLog.findAll({ where: whereClause });

    return res.status(200).json({
      success: true,
      count: logs.length,
      data: logs
    });

  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Server error",
      reason: error.message
    });
  }
};

//getWasteLogById
const getWasteById = async (req, res) => {
  try {
    const { id } = req.params;

    const waste = await WasteLog.findByPk(id);

    if (!waste) {
      return res.status(404).json({
        success: false,
        message: "Waste log not found"
      });
    }

    // SME can only view their own log
    if (req.user.role === "SME" && waste.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: "Access denied",
        reason: "You can only access your own waste logs"
      });
    }

    return res.status(200).json({
      success: true,
      data: waste
    });

  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Server error",
      reason: error.message
    });
  }
};

module.exports = { createWasteLog, getWasteLogs, getWasteById };