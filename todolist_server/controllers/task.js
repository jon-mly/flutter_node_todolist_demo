const Task = require("../models/task");
const socket = require("../sockets/socket");

exports.emitTasks = () => {
  Task.find().then(socket.emitTasksToAll);
};

exports.addTask = (req, res, next) => {
  const taskObject = req.body;
  const task = new Task({
    title: taskObject.title,
    creatorId: taskObject.creatorId,
    date: taskObject.date,
    done: taskObject.done
  });
  task
    .save()
    .then(() => {
      emitTasks();
      return res.status(201).json({ message: "Task created" });
    })
    .catch(error => res.status(400).json({ error }));
};

exports.deleteTask = (req, res, next) => {
  console.log(req);
  Task.deleteOne({ _id: req.params.id })
    .then(() => {
      emitTasks();
      return res.status(200).json({ message: "Task deleted" });
    })
    .catch(error => res.status(400).json({ error }));
};

exports.modifyTask = (req, res, next) => {
  Task.updateOne({ _id: req.params.id }, { ...req.body, _id: req.params.id })
    .then(() => {
      emitTasks();
      return res.status(200).json({ message: "Task updated" });
    })
    .catch(error => res.status(400).json({ error }));
};
