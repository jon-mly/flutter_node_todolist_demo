const express = require('express');
const router = express.Router();

const taskController = require('../controllers/task');

router.post("/", taskController.addTask);
router.delete("/:id", taskController.deleteTask);
router.put("/:id", taskController.modifyTask);

module.exports = router;