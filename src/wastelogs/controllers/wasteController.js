const { classifyImage } = require("../../../src/utils/aiclient");

const { WasteLog } = require("../../../models");

//create waste log with estimated value and quantity range  
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

    // 1️⃣ Call AI API
    const predictionData = await classifyImage(imagePath);

    console.log("AI RESPONSE:", predictionData);

    const aiCategory = predictionData.prediction;
    const aiConfidence = predictionData.confidence;

    // 2️⃣ Convert volume to estimated KG (ONLY if volume is range text)
    // If volume is already numeric like "5", it will still work.

    let estimatedKg = 0;

    const volumeMap = {
      "1-5 kg": 3,
      "5-20 kg": 12.5,
      "20-100 kg": 60,
      "100+ kg": 120,
      "Low": 3,
      "Medium": 12.5,
      "High": 60,
    };

    if (volumeMap[volume]) {
      estimatedKg = volumeMap[volume];
    } else {
      // If user sends numeric value like "5"
      estimatedKg = parseFloat(volume) || 0;
    }

    // 3️⃣ Price per KG
    const pricePerKg = {
      plastic: 0.35,
      metal: 0.50,
      paper: 0.20,
      organic: 0.10,
    };

    const rate = pricePerKg[aiCategory.toLowerCase()] || 0.15;

    const estimatedValue = estimatedKg * rate;
    const quantityRange = volume; // Store original volume text as quantityRange
    // 4️⃣ Save to database (ADD estimatedValue column in DB if not yet added)
    const log = await WasteLog.create({
      wasteType,
      volume,
      quantityRange,
      lga: req.user.lga,
      userId: req.user.id,
      imageUrl: imagePath,
      aiPrediction: aiCategory,
      aiConfidence,
      estimatedValue,   // 👈 NEW FIELD
      status: "pending",
    });

    // 5️⃣ Refined Response
    return res.status(201).json({
      message: "Waste logged successfully!",
      info: "Your waste has been recorded. Companies can now see it for collection or reuse.",
      wasteDetails: {
        wasteType,
        volume,
        aiPrediction: aiCategory,
        estimatedValue: `$${estimatedValue.toFixed(2)}`
      },
      impact: {
        sdg: "SDG 14 – Life Below Water"
      },
      log
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