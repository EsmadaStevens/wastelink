const express = require('express');
const router = express.Router();
const { signupController, verifyOtpController, resendOtpController, loginController } = require('../controllers/authController');

router.post('/signup', signupController);
router.post('/verify-otp', verifyOtpController);
router.post('/resend-otp', resendOtpController);

router.post('/login', loginController);

module.exports = router;
