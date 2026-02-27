const express = require('express');
const router = express.Router();
const { authenticate } = require("../../middlewares/authMiddleware");
const {getAvailableJobs, acceptJob, requestPickup} = require("../../pickupRequest/controllers/pickupRequestController");

router.get("/available-waste", authenticate, getAvailableJobs);
router.patch("/accept-pickup/:id", authenticate, acceptJob);
router.post("/wastelog/:id/request-pickup", authenticate, requestPickup);
router.get("/collector/jobs", authenticate, getAvailableJobs);
router.post("/collector/jobs/:id/accept", authenticate, acceptJob);

module.exports = router;
