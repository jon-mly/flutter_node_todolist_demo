const mongoose = require("mongoose");

const taskSchema = mongoose.Schema({
  creatorId: { type: String, required: true },
  date: { type: Number, required: true },
  title: { type: String, required: true },
  done: { type: Boolean, required: true }
});

module.exports = mongoose.model("Task", taskSchema);
