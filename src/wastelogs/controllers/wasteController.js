const { WasteLog } = require("../../../models");

const ALLOWED_CATEGORIES = [
  "Plastic",
  "Organic",
  "Metal",
  "Glass",
  "Electronic"
];


const ALLOWED_VOLUMES = [
  "Small",
  "Medium",
  "Large",
  "Extra Large"
];


const createWasteLog = async (req, res) => {
  try {
    const { category, volume, location } = req.body;

    // Validate category
    if (!ALLOWED_CATEGORIES.includes(category)) {
      return res.status(400).json({
        success: false,
        message: "Validation error",
        reason: `Category must be one of: ${ALLOWED_CATEGORIES.join(", ")}`
      });
    }

    // Validate volume
    if (!ALLOWED_VOLUMES.includes(volume)) {
      return res.status(400).json({
        success: false,
        message: "Validation error",
        reason: `Volume must be one of: ${ALLOWED_VOLUMES.join(", ")}`
      });
    }

    const wasteLog = await WasteLog.create({
      category,
      volume,
      location,
      userId: req.user.id // attach authenticated user
    });

    return res.status(201).json({
      success: true,
      message: "Waste logged successfully",
      data: wasteLog,
      loggedBy: req.user.role
    });

  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Server error",
      reason: error.message
    });
  }
};

//getWasteLogs
const getWasteLogs = async (req, res) => {
  try {
    const { category, volume } = req.query;

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