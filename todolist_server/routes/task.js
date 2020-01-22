const express = require('express');
const router = express.Router();

const taskController = require('../controllers/task');
const authMiddleware = require('../middlewares/auth');

router.post("/", authMiddleware.checkToken, taskController.addTask);
router.delete("/:id", authMiddleware.checkToken, taskController.deleteTask);
router.put("/:id", authMiddleware.checkToken, taskController.modifyTask);

module.exports = router;