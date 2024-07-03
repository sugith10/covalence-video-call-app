// Import the required modules
const express = require("express");
const { Server } = require("socket.io");
const cors = require("cors");
const cookieParser = require("cookie-parser");

// Create a new Socket.IO server
const io = new Server({
  cors: true,
});
// Create a new Express app
const app = express();
// Set the port number
const port = 3000;

// Use the cookie parser middleware
app.use(cookieParser());
// Use CORS middleware
app.use(cors({ origin: "*" }));

// Create a new Map to store the email to socket mapping
const emailToSocketMapping = new Map();
// Create a new Map to store the socket ID to email mapping
const socketIdToEmailMapping = new Map();

// Listen for a connection event on the Socket.IO server
io.on("connection", (socket) => {
  // Listen for a 'join-room' event
  socket.on("join-room", (data) => {
    // Get the email and room ID from the data
    const { email, roomId } = data;

    // Add the email to the email to socket mapping
    emailToSocketMapping.set(email, socket.id);
    // Add the socket ID to the socket ID to email mapping
    socketIdToEmailMapping.set(socket.id, email);

    // Join the room
    socket.join(roomId);

    // Emit a 'joined-room' event with the room ID
    socket.emit("joined-room", { roomId });

    // Emit a 'user-joined' event with the email to the room
    socket.broadcast.to(roomId).emit("user-joined", { email });
  });

  // Listen for a 'call-user' event
  socket.on("call-user", ({ email, offer }) => {
    // Get the email from the socket ID
    const from = socketIdToEmailMapping.get(socket.id);
    // Get the socket ID from the email
    const socketId = emailToSocketMapping.get(email);

    // Emit an 'incoming-call' event to the user with the email
    socket.to(socketId).emit("incoming-call", { from, offer });
  });

  // Listen for a 'call-accepted' event
  socket.on("call-accepted", ({ from, ans }) => {
    // Get the socket ID from the email
    const socketId = emailToSocketMapping.get(from);

    // Emit a 'call-accepted' event to the user with the email
    socket.to(socketId).emit("call-accepted", { ans });
  });

  // Log a message when a user connects
  console.log("a user connected");
});

// Get the root route and send a response
app.get("/", (req, res) => {
  res.send("Hello World!");
});

// Listen for the specified port and send a message when connected
app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});

// Listen for the specified port and send a message when connected
io.listen(3001);
