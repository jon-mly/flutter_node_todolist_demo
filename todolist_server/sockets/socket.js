//
// Configuration
//

const configureSocketConnection = connection => {
  console.log("Configuring Socket connection");

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
  // TODO: perform actions needed
};

//
// Socket configuration
//

const addListenersToSocket = socket => {};

//
// Exportation
//

exports.configureSocketConnection = configureSocketConnection;
