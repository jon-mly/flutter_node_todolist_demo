const tasksController = require('../controllers/task');

var activeConnection;
var sockets = [];

//
// Configuration
//

const configureSocketConnection = connection => {
  console.log("Configuring Socket connection");

  activeConnection = connection;

  connection.on("connection", onConnection);
  connection.on("disconnect", onDisconnect);
  connection.on("error", console.log);
};

//
// Connection listeners
//

const onConnection = socket => {
  console.log("New client connected : " + socket);
  addListenersToSocket(socket);
  tasksController.emitTasks();
};

const onDisconnect = socket => {
  console.log("Client disconnected : " + socket);
  // TODO: perform actions needed
};

//
// Socket configuration
//

const addListenersToSocket = socket => {};

//
// Actions
//

const emitTasksToAll = tasks => {
  activeConnection.sockets.emit("tasks", JSON.stringify(tasks));
};

//
// Exportation
//

exports.emitTasksToAll = emitTasksToAll;
exports.configureSocketConnection = configureSocketConnection;
