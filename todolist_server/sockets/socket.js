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
  connection.on("error", console.log);
};

//
// Connection listeners
//

const onConnection = socket => {
  console.log("New client connected : " + socket);
  addListenersToSocket(socket);
};

//
// Socket configuration
//

const addListenersToSocket = socket => {
  socket.on("disconnect", message => onDisconnect(socket, message));
  socket.on("auth", message => onAuthentified(socket, message));
};

//
// Socket listeners
//

const onAuthentified = (socket, message) => {
  try {
    const parsed = JSON.parse(message);
    const token = parsed.token;
    const userId = tokenController.extractUserId(token);
    console.log("Authenticed user id : " + userId);
    socketClientsList[userId] = socket;
    console.log("New socket id : " + socket.id);
    socket.emit("auth", JSON.stringify({ message: "Authentified" }));
    tasksController.emitTasks(userId);
  } catch (e) {
    console.log(e);
    socket.emit(
      "error",
      JSON.stringify({ message: "The token is invalid. Auth again." })
    );
  }
};

const onDisconnect = (socket, message) => {
  console.log("Client disconnected : " + socket);
  console.log("Socket to delete " + socket.id);
  console.log(socketClientsList);
  Object.entries(socketClientsList).forEach(([key, value]) => {
    if (value.id === socket.id) {
      delete socketClientsList[key];
    }
  });
  console.log(Object.keys(socketClientsList));
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
  console.log("Socket receiving tasks : " + socket.id);
  socket.emit("tasks", JSON.stringify(tasks));
};

//
// Exportation
//

exports.emitTasksToAll = emitTasksToAll;
exports.emitTasksToUser = emitTasksToUser;
exports.configureSocketConnection = configureSocketConnection;
