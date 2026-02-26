const { signup, getAllUsers } = require('../services/authService');
const db = require("../../../models");
const { User } = db;

async function signupController(req, res) {
  try {
    const result = await signup(req.body);
    res.status(201).json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

// const verifyOtpController = async (req, res) => {
//   try {
//     const { email, otp } = req.body;

//     // Pass the email as a string, NOT as an object
//     const result = await verifyOtp(email, otp);

//     return res.status(200).json(result);
//   } catch (error) {
//     return res.status(400).json({ error: error.message });
//   }
// };

// Resend OTP
// const resendOtpController = async (req, res) => {
//   try {
//     const result = await resendOtp(req.body.email);
//     return res.status(200).json(result);
//   } catch (error) {
//     return res.status(400).json({ error: error.message });
//   }
// };

// async function loginController(req, res) {
//   try {
//     // Pass request body to login service
//     const result = await login(req.body);

//     // Send token + user info back
//     res.status(200).json(result);
//   } catch (err) {
//     res.status(400).json({ error: err.message });
//   }
// };

//getUser
async function loginController(req, res) {
  const { email, password } = req.body;

  const user = await User.findOne({ where: { email } });

  if (!user) {
    return res.status(404).json({ message: "User not found" });
  }

  const isMatch = await bcrypt.compare(password, user.password);

  if (!isMatch) {
    return res.status(401).json({ message: "Invalid credentials" });
  }

  const token = generateToken(user);

  res.json({
    message: "Login successful",
    token
  });
};
async function getAllUsersController(req, res) {
  try {
    const users = await getAllUsers();
    return res.status(200).json({
      status: 'success',
      results: users.length,
      data: users
    });
  } catch (error) {
    return res.status(500).json({
      status: 'error',
      message: 'Failed to fetch users',
      error: error.message
    });
  }
}
module.exports = { signupController, loginController, getAllUsersController };
