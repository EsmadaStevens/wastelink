const jwt = require("jsonwebtoken");
const { User } = require("../../models");
require("dotenv").config();

const authenticate = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      return res.status(401).json({ message: "No token provided" });
    }

    const token = authHeader.split(" ")[1]; // Bearer TOKEN

    if (!token) {
      return res.status(401).json({ message: "Invalid token format" });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    const user = await User.findByPk(decoded.id);

    if (!user) {
      return res.status(401).json({ message: "User not found" });
    }

    req.user = user; // attach user to request

    next();
  } catch (error) {
    return res.status(401).json({ message: "Unauthorized" });
  }
};


const authorize = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: "Access denied",
        reason: `Role '${req.user.role}' is not allowed to access this resource`,
        yourRole: req.user.role,
        allowedRoles: roles
      });
    }
    next();
  };
};

module.exports = { authenticate, authorize };


