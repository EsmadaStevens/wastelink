const express = require("express");
const router = express.Router();
const {authenticate, authorize} = require("../../src/middlewares/authMiddleware");

router.get("/protected", authenticate, (req, res) => {
  res.json({
    message: "You accessed a protected route!",
    user: req.user.email
  });
});

router.post(
  "/waste",
  authenticate,
  authorize("SME"),
  (req, res) => {
      role: req.user.role,
    res.json({ message: "Waste logged successfully", yourRole: req.user.role});
    
  }
);
//If a Collector tries → 403
// If SME tries → success

module.exports = router;
