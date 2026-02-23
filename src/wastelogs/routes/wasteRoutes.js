const express = require("express");
const router = express.Router();

const { authenticate, authorize } = require("../../middlewares/authMiddleware");
const { createWasteLog, getWasteLogs, getWasteById } = require("../../wastelogs/controllers/wasteController");

// Only SME can log waste
router.post("/create-waste",authenticate, authorize("SME"), createWasteLog);

//get waste logs with optional filters
router.get("/view-waste", authenticate, getWasteLogs);
//get waste log by id
router.get("/view-waste/:id", authenticate, getWasteById);

module.exports = router;