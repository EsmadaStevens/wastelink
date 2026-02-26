const { PickupRequest, WasteLog, User } = require("../../../models");

// GET available jobs for collector
async function getAvailableJobs(req, res) { 
  try {
    // Only collectors allowed
    if (req.user.role !== "COLLECTOR") {
      return res.status(403).json({
        message: "Only collectors can view jobs",
        role: req.user.role
      });
    }

    // Find waste logs in same LGA
    const logs = await WasteLog.findAll({
      where: {
        lga: req.user.lga,
        status: "pending"
      }
    });

    res.json(logs);

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};

// Collector accepts a job
async function acceptJob(req, res) {
  try {
    if (req.user.role !== "COLLECTOR") {
      return res.status(403).json({
        message: "Only collectors can accept jobs",
        role: req.user.role
      });
    }

    const wasteLog = await WasteLog.findByPk(req.params.id);

    if (!wasteLog) {
      return res.status(404).json({ message: "Waste log not found" });
    }

    // 🔥 1️⃣ Prevent accepting already accepted job
    if (wasteLog.status === "accepted") {
      return res.status(400).json({
        message: "This job has already been accepted"
      });
    }

    // 🔥 2️⃣ Check if pickup request already exists
    const existingPickup = await PickupRequest.findOne({
      where: { WasteLogId: wasteLog.id }
    });

    if (existingPickup) {
      return res.status(400).json({
        message: "Pickup request already exists for this job"
      });
    }

    // ✅ Update waste log status
    wasteLog.status = "accepted";
    await wasteLog.save();

    // ✅ Create pickup request
    const pickup = await PickupRequest.create({
      WasteLogId: wasteLog.id,
      collectorId: req.user.id,
      status: "accepted"
    });

    return res.json({
      message: "Job accepted successfully",
      pickup
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Server error" });
  }
}

module.exports = { getAvailableJobs, acceptJob };