local mock = require('luassert.mock')
local stub = require('luassert.stub')
local match = require("luassert.match")

describe("total netrw", function()
    local total = require('after/plugin/netrw')
    local _ = match._

    describe("file actions", function()
        before_each(function()
            vim.cmd.arga(table.concat({ '_', 'fileware' }, " "))
            local api = mock(vim.api, true)
            api.nvim_buf_get_var.returns('/my/test/file/path')
            stub(vim, "cmd")
        end)
        after_each(function()
            assert.stub(vim.cmd).was_called(3)
            assert.equals(#total.LEFT.selected_files, 1)
            assert.equals(total.LEFT.selected_files[1], 'fileware')
            assert.equals('LEFT', total.selected)

            -- mock.revert(api)
            vim.cmd:revert()
        end)

        it("move command correct", function()
            total.move_marked_files()
            assert.stub(vim.cmd).was_called_with("silent !Move-Item -Path 'fileware' -Destination '/my/test/file/path'")
        end)

        it("delete command correct", function()
            total.delete_marked_files()
            assert.stub(vim.cmd).was_called_with("silent !Remove-Item -Force -Recurse 'fileware'")
        end)

        it("copy command correct", function()
            total.copy_marked_files()
            assert.stub(vim.cmd).was_called_with(
            "silent !Copy-Item -Recurse -Path 'fileware' -Destination '/my/test/file/path'")
        end)
    end)
end)
