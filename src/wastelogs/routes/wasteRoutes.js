const express = require("express");
const router = express.Router();

const { authenticate, authorize } = require("../../middlewares/authMiddleware");
const { createWasteLog } = require("../../wastelogs/controllers/wasteController");

// Only SME can log waste
router.post("/",authenticate, authorize("SME"), createWasteLog);

module.exports = router;