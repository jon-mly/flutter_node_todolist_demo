
const tokenController = require('../controllers/token');

const getToken = req => req.headers.authorization.split(" ")[1];

const checkToken = (req, res, next) => {
  try {
    const token = getToken(req);
    const userId = tokenController.extractUserId(token);
    req.tokenUserId = userId;
    next();
  } catch (e) {
    console.log(e);
    res.status(401).json({ message: "Invalid token" });
  }
};

exports.getToken = getToken;
exports.checkToken = checkToken;
