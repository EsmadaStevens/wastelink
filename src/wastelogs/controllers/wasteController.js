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

module.exports = { createWasteLog };