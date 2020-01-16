const http = require("http");
const app = require("./app");
const io = require("socket.io");

const socketConfig = require("./sockets/socket");

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

const port = normalizePort(process.env.PORT || "8079");
app.set("port", port);

const getBind = () => {
  const address = server.address();
  const bind =
    typeof address === "string" ? "pipe " + address : "port: " + port;
  return bind;
};

const server = http.createServer(app);

server.on("error", errorHandler);
server.on("listening", listeningHandler);

server.listen(port);

const socketConnection = io(server);
socketConfig.configureSocketConnection(socketConnection);