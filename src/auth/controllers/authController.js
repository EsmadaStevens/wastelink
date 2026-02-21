const { signup, verifyOtp, resendOtp, login } = require('../services/authService');


async function signupController(req, res) {
  try {
    const result = await signup(req.body);
    res.status(201).json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

const verifyOtpController = async (req, res) => {
  try {
    const { email, otp } = req.body;

    // Pass the email as a string, NOT as an object
    const result = await verifyOtp(email, otp);

    return res.status(200).json(result);
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
};

// Resend OTP
const resendOtpController = async (req, res) => {
  try {
    const result = await resendOtp(req.body.email);
    return res.status(200).json(result);
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
};

async function loginController(req, res) {
  try {
    // Pass request body to login service
    const result = await login(req.body);

    // Send token + user info back
    res.status(200).json(result);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

module.exports = { signupController, verifyOtpController, resendOtpController, loginController };
