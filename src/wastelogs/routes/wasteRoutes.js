const express = require("express");
const router = express.Router();

const { authenticate, authorize } = require("../../middlewares/authMiddleware");
const { createWasteLog, getWasteLogs, getWasteById } = require("../../wastelogs/controllers/wasteController");
const upload = require("../../middlewares/upload");


// Only SME can log waste
// router.post("/create-waste",authenticate, authorize("SME"), createWasteLog);
router.post("/create-waste", authenticate, authorize("sme"), upload.single("image"),  // must come BEFORE controller
  createWasteLog
);

//get waste logs with optional filters
router.get("/view-waste", authenticate, getWasteLogs);
//get waste log by id
router.get("/view-waste/:id", authenticate, getWasteById);


// THIS HANDLES IMAGE UPLOAD
// router.post("/", authenticate, authorize("sme"),upload.single("image"), createWasteLog);

module.exports = router;