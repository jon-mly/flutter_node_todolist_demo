const path = require("path");
const express = require("express");
const bodyParser = require("body-parser");

const headerConfig = require("./middlewares/cros");

const authRouter = require("./routes/auth");

//
// App configuration
//

const app = express();

app.use(headerConfig);

app.use(bodyParser.json());

app.use("/api/auth", authRouter);

app.use(express.static(path.join(__dirname, "public")));

//
// Exportation
//

module.exports = app;
