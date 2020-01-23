const jwt = require("jsonwebtoken");

const authTokenSecret = "THE_TOKEN_SECRET";

const extractUserId = token => {
  return jwt.verify(token, "THE_TOKEN_SECRET").userId;
};

exports.extractUserId = extractUserId;
