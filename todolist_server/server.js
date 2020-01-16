const http = require("http");
const app = require("./app");
const io = require("socket.io");

const socketConfig = require("./sockets/socket");

//
// Actions
//

const port = normalizePort(process.env.PORT || "8080");
app.set("port", port);

const server = http.createServer(app);

server.on("error", errorHandler);
server.on("listening", listeningHandler);

const socketConnection = io(server);
socketConfig.configureSocketConnection(socketConnection);

server.listen(port);

//
// Events handlers
//

const errorHandler = error => {
  if (error.syscall != "listen") {
    throw error;
  }
  const bind = getBind();
  switch (error.code) {
    case "EACCES":
      console.error(bind + " required elevated privileges");
      break;
    case "EADDRINUSE":
      console.error(bind + " is already in use");
      break;
    default:
      throw error;
  }
};

const listeningHandler = () => {
  const bind = getBind();
  console.log("Listening on " + bind);
};

//
// Helpers
//

const normalizePort = value => {
  const port = parseInt(value, 10);
  if (isNaN(port)) {
    return value;
  }
  if (port >= 0) {
    return port;
  }
  return false;
};

const getBind = () => {
  const address = server.address();
  const bind =
    typeof address === "string" ? "pipe " + address : "port: " + address;
  return bind;
};
