local serverPort = 8765 -- Replace with the desired server port number

-- Start the server
local function startServer()
  print("Server listening on port", serverPort)

  while true do
    local event, param1, param2, param3, param4, param5 = os.pullEvent()
    if event == "http" then
      local requestID = param1
      local requestURL = param2
      local requestMethod = param3
      local requestData = param4

      -- Process POST request
      if requestMethod == "GET" then
        -- local data = requestData.readAll()
        -- requestData.close()

        -- Process the received data
        print("Received data:")

        -- -- Send a response back to the client
        -- http.request(requestURL, data)
      else
        -- Return a 404 error for all other requests
        http.request(requestURL, "Not Found", { ["Content-Type"] = "text/plain" }, "404")
      end
    end
  end
end

-- Main program
parallel.waitForAll(
  function()
    -- Start the server
    startServer()
  end,
  function()
    -- Other tasks you may have in your program
  end
)
