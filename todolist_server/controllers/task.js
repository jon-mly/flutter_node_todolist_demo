const Task = require("../models/task");
const socket = require("../sockets/socket");

const emitTasks = (userId) => {
  Task.find({ creatorId: userId })
    .then(tasks => socket.emitTasksToUser(tasks, userId))
    .catch(console.log);
};

exports.addTask = (req, res, next) => {
  const taskObject = req.body;
  const task = new Task({
    title: taskObject.title,
    creatorId: req.tokenUserId,
    date: taskObject.date,
    done: taskObject.done
  });
  task
    .save()
    .then(() => {
      emitTasks(req.tokenUserId);
      res.status(201).json({ message: "Task created" });
    })
    .catch(error => res.status(400).json({ error }));
};

exports.deleteTask = (req, res, next) => {
  console.log(req);
  Task.deleteOne({ _id: req.params.id })
    .then(() => {
      emitTasks(req.tokenUserId);
      res.status(200).json({ message: "Task deleted" });
    })
    .catch(error => res.status(400).json({ error }));
};

exports.modifyTask = (req, res, next) => {
  Task.updateOne({ _id: req.params.id }, { ...req.body, _id: req.params.id })
    .then(() => {
      emitTasks(req.tokenUserId);
      res.status(200).json({ message: "Task updated" });
    })
    .catch(error => res.status(400).json({ error }));
};

exports.emitTasks = emitTasks;