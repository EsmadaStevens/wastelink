const express = require('express');
const router = express.Router();
const { signupController, loginController, getAllUsersController } = require('../controllers/authController');

router.post('/signup', signupController);
router.get('/getsignup', getAllUsersController);
router.post('/login', loginController);

module.exports = router;
