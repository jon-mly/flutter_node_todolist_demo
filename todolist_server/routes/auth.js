const express = require("express");
const router = express.Router();

const authController = require("../controllers/auth");

router.get("/verify", authController.verify);
router.post("/signup", authController.signup);
router.post("/login", authController.login);

module.exports = router;
