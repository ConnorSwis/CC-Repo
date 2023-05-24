local gitUrl = "https://raw.githubusercontent.com/"

local Git = {}

Git.userRepo = "ConnorSwis/CC-Repo/master/"

---download file from gitlab and return contents
---@param repo string user/repo/branch
---@param fp string file path and location on git
---@return string | nil contents response or nil on failure
function Git.downloadFileFromGit(repo, fp)
    local url = gitUrl .. repo .. fp
    local response = http.get(url)
    if response then
        local contents = response.readAll()
        response.close()
        return contents
    else
        return nil
    end
end

---download file from git.
---@param repo string user/repo/branch
---@param fp string file with filepath to download
function Git.getFile(repo, fp)
    print("Downloading " .. fp)
    local response = Git.downloadFileFromGit(repo, fp)
    if response == nil then
        error("something went wrong whilst downloading " .. fp)
    end
    local fh = fs.open(fp, "w")
    fh.write(response)
    fh.close()
end

---check if file exists and if it doesnt download from file.
---@param repo string user/repo/branch
---@param fp string file with filepath to download
function Git.getFileIfNeeded(repo, fp)
    if type(fp) ~= "string" or type(repo) ~= "string" then
        error("failed to get file from git, invalid argument " .. fp, 1)
    end
    if fs.exists(fp) then
        return
    end
    Git.getFile(repo, fp)
end



return Git