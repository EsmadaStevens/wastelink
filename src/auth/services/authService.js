const bcrypt = require('bcryptjs');
const nodemailer = require('nodemailer');
const { sendOtpEmail } = require('../utils/emailService');
const { generateToken, verifyToken } = require('../utils/jwt');
const db = require("../../../models");
const { User } = db;

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});



// Signup function
// const signup = async (data) => {
//   const { name, email, password, role, lga } = data;
// const hashedPassword = await bcrypt.hash(password, 10);
//   const otp = Math.floor(100000 + Math.random() * 900000).toString();

//   const newUser = await User.create({
//     name,
//     email,
//     password: hashedPassword,
//     role,
//     lga,
//     isVerified: false,
//     otp: otp,
//     otpExpires: new Date(Date.now() + 10 * 60 * 1000) // 10 minutes
//   });

//   await sendOtpEmail(email, otp);

//   return newUser;
// };

const signup = async (data) => {
  const { name, email, password, role, lga } = data;
const hashedPassword = await bcrypt.hash(password, 10);

  const otp = Math.floor(100000 + Math.random() * 900000).toString();

  const newUser = await User.create({
    name,
    email,
    password: hashedPassword,
    role,
    lga,
    isVerified: false,
    otp: otp,
    otpExpires: new Date(Date.now() + 10 * 60 * 1000) // 10 minutes
  });

  await sendOtpEmail(email, otp);

  console.log("New User Created:", newUser);
  return {
  message: "Signup successful. OTP has been sent to your email."
};

};



// Verify OTP
const verifyOtp = async (email, otp) => {
  const user = await User.findOne({ where: { email } });

  if (!user) throw new Error("User not found");
  if (user.otp !== otp) throw new Error("Invalid OTP");
  if (user.otpExpires < new Date()) throw new Error("OTP expired");

  await user.update({ isVerified: true, otp: null, otpExpires: null });

  return { message: "Account verified successfully" };
};


//Resend OTP
const resendOtp = async (email) => {
  const user = await User.findOne({ where: { email } });

  if (!user) {
    throw new Error("User not found");
  }

  if (user.isVerified) {
    throw new Error("User already verified");
  }

  const newOtp = Math.floor(100000 + Math.random() * 900000).toString();

  await user.update({
    otp: newOtp,
    otpExpires: new Date(Date.now() + 10 * 60 * 1000)
  });

  await sendOtpEmail(user.email, newOtp);

  return { message: "New OTP sent successfully" };
};


// Login
async function login({ email, password }) {
  // 1. Find user by email
  const user = await User.findOne({ where: { email } });
  if (!user) throw new Error('User not found');

  // 2. Ensure account is verified
  if (!user.isVerified) throw new Error('Account not verified');

  // 3. Compare passwords
  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) throw new Error('Incorrect password');

  // 4. Generate JWT token
  const token = generateToken(user); // <-- use helper

  // 5. Return token + user info (for frontend / mobile app)
  return {
    token,
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      lga: user.lga,
      isVerified: user.isVerified
    }
  };
}

//getUser
async function getAllUsers() {
  try {
    const users = await User.findAll({
      attributes: { exclude: ['password'] } // optional: exclude sensitive data
    });
    return users;
  } catch (error) {
    console.error('Error fetching users:', error);
    throw error;
  }
}  
module.exports = { signup, verifyOtp, resendOtp, login, getAllUsers };