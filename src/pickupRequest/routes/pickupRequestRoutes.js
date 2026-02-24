const express = require('express');
const router = express.Router();
const { authenticate } = require("../../middlewares/authMiddleware");
const {getAvailableJobs, acceptJob} = require("../../pickupRequest/controllers/pickupRequestController");

router.get("/available-waste", authenticate, getAvailableJobs);
router.patch("/accept-pickup/:id", authenticate, acceptJob);

module.exports = router;