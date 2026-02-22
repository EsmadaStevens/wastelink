const express = require('express');
const router = express.Router();
const { signupController, verifyOtpController, resendOtpController, loginController, getAllUsersController } = require('../controllers/authController');

router.post('/signup', signupController);
router.post('/verify-otp', verifyOtpController);
router.post('/resend-otp', resendOtpController);
router.get('/getsignup', getAllUsersController);

//get

router.post('/login', loginController);

module.exports = router;
