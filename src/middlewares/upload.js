const multer = require("multer");
const path = require("path");
const fs = require("fs");

// Ensure uploads directory exists
const uploadPath = "/uploads";

if (!fs.existsSync(uploadPath)) {
  fs.mkdirSync(uploadPath, { recursive: true });
  }

  const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, uploadPath); // ✅ absolute path
          },
            filename: function (req, file, cb) {
                cb(null, Date.now() + "-" + file.originalname);
                  }
                  });

                  const upload = multer({ storage });
 module.exports = upload;