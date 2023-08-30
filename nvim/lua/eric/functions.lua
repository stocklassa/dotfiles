function Get_work_log_path()
    local current_date = os.date("%d.%m.%Y")
    local base_path = "~/zettelkasten-notes/Work Log/"
    local base_file_name = "Work Log "
    local extension = ".md"
    return base_path .. base_file_name .. current_date .. extension
end
