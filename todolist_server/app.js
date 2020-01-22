const path = require("path");
const express = require("express");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");

const headerConfig = require("./middlewares/cros");

const authRouter = require("./routes/auth");
const taskRouter = require("./routes/task");

//
// MongoDB configuration
//

mongoose.Promise = require("bluebird");

mongoose
  .connect(
    "mongodb://admin:admin@cluster0-shard-00-00-e5jo9.mongodb.net:27017,cluster0-shard-00-01-e5jo9.mongodb.net:27017,cluster0-shard-00-02-e5jo9.mongodb.net:27017/test?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority",
    { useNewUrlParser: true, useUnifiedTopology: true }
  )
  .then(() => console.log("Connected to MongoDB"))
  .catch(e => console.log("Failed to connect to MongoDB : " + e));

//
// App configuration
//

const app = express();

app.use(headerConfig.addResponseHeader);

app.use(bodyParser.json());

app.use("/api/auth", authRouter);
app.use("/api/task", taskRouter);

app.use(express.static(path.join(__dirname, "public")));

app.use((req, res, next) => res.status(404).json({ message: "Route not found" }));

//
// Exportation
//

module.exports = app;
