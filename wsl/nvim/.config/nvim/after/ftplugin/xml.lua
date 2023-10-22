local function isPom()
    ---@diagnostic disable-next-line: param-type-mismatch
    local fileHeader = table.concat(vim.fn.getline(1, 4), "")
    return string.match(fileHeader, "http://maven.apache.org/POM") ~= nil
end

-- Determine specific filetype
if isPom() then
    vim.opt.filetype = 'xml.xml-pom'
else
    -- It is common xml
end
