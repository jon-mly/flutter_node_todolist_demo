const tasksController = require("../controllers/task");
const tokenController = require("../controllers/token");

var activeConnection;
var socketClientsList = {};

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
};

const onDisconnect = socket => {
  console.log("Client disconnected : " + socket);
  // TODO: remove socket from clients list
};

//
// Socket configuration
//

const addListenersToSocket = socket => {
  socket.on("auth", message => {
    onAuthentified(socket, message);
  });
};

//
// Socket listeners
//

const onAuthentified = (socket, message) => {
  try {
    const parsed = JSON.parse(message);
    const token = parsed.token;
    const userId = tokenController.extractUserId(token);
    socketClientsList[userId] = socket;
    tasksController.emitTasks();
  } catch (e) {
    console.log(e);
    socket.emit(
      "error",
      JSON.stringify({ message: "The token is invalid. Auth again." })
    );
  }
};

//
// Actions
//

const emitTasksToAll = tasks => {
  activeConnection.sockets.emit("tasks", JSON.stringify(tasks));
};

const emitTasksToUser = (tasks, userId) => {
  const socket = socketClientsList[userId];
  if (!socket) {
    return;
  }
  socket.emit("tasks", JSON.stringify(tasks));
};

//
// Exportation
//

exports.emitTasksToAll = emitTasksToAll;
exports.emitTasksToUser = emitTasksToUser;
exports.configureSocketConnection = configureSocketConnection;
