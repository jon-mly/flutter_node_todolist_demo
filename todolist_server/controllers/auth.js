const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const authMiddleware = require("../middlewares/auth");
const User = require("../models/user");

const authTokenSecret = "THE_TOKEN_SECRET";

//
// Private token methods
//

const getToken = userId => {
  return jwt.sign({ userId: userId }, authTokenSecret, {
    expiresIn: "24h"
  });
};

const verifyToken = token => {
  try {
    const decoded = jwt.verify(token, authTokenSecret);
    return true;
  } catch (err) {
    console.log(err);
    return false;
  }
};

//
// Exported methods
//

exports.signup = (req, res, next) => {
  console.log(req.body);
  bcrypt
    .hash(req.body.password, 10)
    .then(hash => {
      const newUser = new User({
        username: req.body.username,
        password: hash
      });
      console.log(newUser);
      newUser
        .save()
        .then(() =>
          res.status(201).json({ ...newUser, token: getToken(newUser._id) })
        )
        .catch(error => res.status(400).json({ error }));
    })
    .catch(error => res.status(500).json({ error }));
};

exports.login = (req, res, next) => {
  User.findOne({ username: req.body.username })
    .then(user => {
      if (!user) {
        return res.status(401).json({ error: "User not found" });
      }
      bcrypt.compare(req.body.password, user.password).then(identical => {
        if (!identical) {
          return res.status(401).json({ error: "Invalid password" });
        }
        return res.status(200).json({
          ...user,
          token: getToken(user._id)
        });
      });
    })
    .catch(error => res.status(500).json({ error }));
};

exports.verify = (req, res, next) => {
  const tokenValid = verifyToken(authMiddleware.getToken(req));
  if (tokenValid) {
    return res.status(200).json({ message: "Token is valid" });
  }
  return res
    .status(401)
    .json({ message: "Token is invalid. Login / Signup is required" });
};
