vim.api.nvim_create_user_command('Picker', function(opt)

    require('picker').open(opt.fargs)

end, {nargs = '*'})
