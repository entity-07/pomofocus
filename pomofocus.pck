GDPC                �                                                                         T   res://.godot/exported/133200997/export-21612f452b92f3f0782bfa67dc105248-pomodoro.scn�     $      �o�񩚴ɸZY8�R�    `   res://.godot/exported/133200997/export-42ac1302a55dcdd76f56209c51ab9e5a-BreakLengthSelector.scn P�     �	      ��&ӏ��OYPXے��    h   res://.godot/exported/133200997/export-f7b9d321128aa45d8e597ab45c825991-ActiveSessionLengthSelector.scn P�     �      ���6hr8�$U�<�    T   res://.godot/exported/133200997/export-f98e2c43719a3e9fac5e2b9801a9be33-timer.scn   ��     o
      ��;4,�A7��W        res://.godot/extension_list.cfg @�     5       q�Y��C�)�$    ,   res://.godot/global_script_class_cache.cfg  ��            ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�           ：Qt�E�cO���    D   res://.godot/imported/icon.svg-5744b51718b6a64145ec5798797f7631.ctex�     �_      ����]�ڽ���иո       res://.godot/uid_cache.bin  ��     �      �2G62g|D��p%�       res://Globals.gd��     R       &~0qL��O��R*���    4   res://addons/godot-git-plugin/git_plugin.gdextension        �      k��$f�0o�`r�b    $   res://addons/godot-vim/godot-vim.gd �      G     2X˥AX�:8\8���    (   res://addons/godot-vim/icon.svg.import  �z     �       T�E`���f����       res://addons/timer/timer.gd �{     I      5��~�l�B#5��9    $   res://addons/timer/timer.tscn.remap ��     b       8�f��$�3!�rSQs       res://icon.svg  ��     �      k����X3Y���f       res://icon.svg.import    �     �       ��$Yf;zG�_��<�       res://project.binary��     �      İ_��Y#]�qZ��m�    4   res://scenes/ActiveSessionLengthSelector.tscn.remap @�     x       ��ⅦԇK!���zZ    ,   res://scenes/BreakLengthSelector.tscn.remap ��     p       �_�	�ۜ���WE��        res://scenes/pomodoro.tscn.remap0�     e       C�G���Ȃؒ���(O    ,   res://scripts/ActiveSessionLengthSelector.gd �     �      ��R2��s��B�g�    $   res://scripts/BreakLengthSelector.gdа     �      ���t�pݱ[��n�       res://scripts/pomodoro.gd   ��     �      <�s��fB�r� ��        [configuration]

entry_symbol = "git_plugin_init"
compatibility_minimum = "4.1.0"

[libraries]

macos.editor = "macos/libgit_plugin.macos.editor.universal.dylib"
windows.editor.x86_64 = "win64/libgit_plugin.windows.editor.x86_64.dll"
linux.editor.x86_64 = "linux/libgit_plugin.linux.editor.x86_64.so"
linux.editor.arm64 = "linux/libgit_plugin.linux.editor.arm64.so"
linux.editor.rv64 = ""
           @tool
extends EditorPlugin


const INF_COL : int = 99999
const DEBUGGING : int = 0 # Change to 1 for debugging
const CODE_MACRO_PLAY_END : int = 10000

const BREAKERS : Dictionary = { '!': 1, '"': 1, '#': 1, '$': 1, '%': 1, '&': 1, '(': 1, ')': 1, '*': 1, '+': 1, ',': 1, '-': 1, '.': 1, '/': 1, ':': 1, ';': 1, '<': 1, '=': 1, '>': 1, '?': 1, '@': 1, '[': 1, '\\': 1, ']': 1, '^': 1, '`': 1, '\'': 1, '{': 1, '|': 1, '}': 1, '~': 1 }
const WHITESPACE: Dictionary = { ' ': 1, '	': 1, '\n' : 1 }
const ALPHANUMERIC: Dictionary = { 'a': 1, 'b': 1, 'c': 1, 'd': 1, 'e': 1, 'f': 1, 'g': 1, 'h': 1, 'i': 1, 'j': 1, 'k': 1, 'l': 1, 'm': 1, 'n': 1, 'o': 1, 'p': 1, 'q': 1, 'r': 1, 's': 1, 't': 1, 'u': 1, 'v': 1, 'w': 1, 'x': 1, 'y': 1, 'z': 1, 'A': 1, 'B': 1, 'C': 1, 'D': 1, 'E': 1, 'F': 1, 'G': 1, 'H': 1, 'I': 1, 'J': 1, 'K': 1, 'L': 1, 'M': 1, 'N': 1, 'O': 1, 'P': 1, 'Q': 1, 'R': 1, 'S': 1, 'T': 1, 'U': 1, 'V': 1, 'W': 1, 'X': 1, 'Y': 1, 'Z': 1, '0': 1, '1': 1, '2': 1, '3': 1, '4': 1, '5': 1, '6': 1, '7': 1, '8': 1, '9': 1, '_': 1 }
const LOWER_ALPHA: Dictionary = { 'a': 1, 'b': 1, 'c': 1, 'd': 1, 'e': 1, 'f': 1, 'g': 1, 'h': 1, 'i': 1, 'j': 1, 'k': 1, 'l': 1, 'm': 1, 'n': 1, 'o': 1, 'p': 1, 'q': 1, 'r': 1, 's': 1, 't': 1, 'u': 1, 'v': 1, 'w': 1, 'x': 1, 'y': 1, 'z': 1 }
const SYMBOLS = { "(": ")", ")": "(", "[": "]", "]": "[", "{": "}", "}": "{", "<": ">", ">": "<", '"': '"', "'": "'" }


enum {
    MOTION,
    OPERATOR,
    OPERATOR_MOTION,
    ACTION,
}


enum Context {
    NORMAL,
    VISUAL,
}


var the_key_map : Array[Dictionary] = [
    # Move
    { "keys": ["H"],                            "type": MOTION, "motion": "move_by_characters", "motion_args": { "forward": false } },
    { "keys": ["L"],                            "type": MOTION, "motion": "move_by_characters", "motion_args": { "forward": true } },
    { "keys": ["J"],                            "type": MOTION, "motion": "move_by_lines", "motion_args": { "forward": true, "line_wise": true } },
    { "keys": ["K"],                            "type": MOTION, "motion": "move_by_lines", "motion_args": { "forward": false, "line_wise": true } },
    { "keys": ["Shift+Equal"],                  "type": MOTION, "motion": "move_by_lines", "motion_args": { "forward": true, "to_first_char": true } },
    { "keys": ["Minus"],                        "type": MOTION, "motion": "move_by_lines", "motion_args": { "forward": false, "to_first_char": true } },
    { "keys": ["Shift+4"],                      "type": MOTION, "motion": "move_to_end_of_line", "motion_args": { "inclusive": true } },
    { "keys": ["Shift+6"],                      "type": MOTION, "motion": "move_to_first_non_white_space_character" },
    { "keys": ["0"],                            "type": MOTION, "motion": "move_to_start_of_line" },
    { "keys": ["Shift+H"],                      "type": MOTION, "motion": "move_to_top_line", "motion_args": { "to_jump_list": true } },
    { "keys": ["Shift+L"],                      "type": MOTION, "motion": "move_to_bottom_line", "motion_args": { "to_jump_list": true } },
    { "keys": ["Shift+M"],                      "type": MOTION, "motion": "move_to_middle_line", "motion_args": { "to_jump_list": true } },
    { "keys": ["G", "G"],                       "type": MOTION, "motion": "move_to_line_or_edge_of_document", "motion_args": { "forward": false, "to_jump_list": true } },
    { "keys": ["Shift+G"],                      "type": MOTION, "motion": "move_to_line_or_edge_of_document", "motion_args": { "forward": true, "to_jump_list": true } },
    { "keys": ["Ctrl+F"],                       "type": MOTION, "motion": "move_by_page", "motion_args": { "forward": true } },
    { "keys": ["Ctrl+B"],                       "type": MOTION, "motion": "move_by_page", "motion_args": { "forward": false } },
    { "keys": ["Ctrl+D"],                       "type": MOTION, "motion": "move_by_scroll", "motion_args": { "forward": true } },
    { "keys": ["Ctrl+U"],                       "type": MOTION, "motion": "move_by_scroll", "motion_args": { "forward": false } },
    { "keys": ["Shift+BackSlash"],              "type": MOTION, "motion": "move_to_column" },
    { "keys": ["W"],                            "type": MOTION, "motion": "move_by_words", "motion_args": { "forward": true, "word_end": false, "big_word": false } },
    { "keys": ["Shift+W"],                      "type": MOTION, "motion": "move_by_words", "motion_args": { "forward": true, "word_end": false, "big_word": true } },
    { "keys": ["E"],                            "type": MOTION, "motion": "move_by_words", "motion_args": { "forward": true, "word_end": true, "big_word": false, "inclusive": true } },
    { "keys": ["Shift+E"],                      "type": MOTION, "motion": "move_by_words", "motion_args": { "forward": true, "word_end": true, "big_word": true, "inclusive": true } },
    { "keys": ["B"],                            "type": MOTION, "motion": "move_by_words", "motion_args": { "forward": false, "word_end": false, "big_word": false } },
    { "keys": ["Shift+B"],                      "type": MOTION, "motion": "move_by_words", "motion_args": { "forward": false, "word_end": false, "big_word": true } },
    { "keys": ["G", "E"],                       "type": MOTION, "motion": "move_by_words", "motion_args": { "forward": false, "word_end": true, "big_word": false } },
    { "keys": ["G", "Shift+E"],                 "type": MOTION, "motion": "move_by_words", "motion_args": { "forward": false, "word_end": true, "big_word": true } },
    { "keys": ["Shift+5"],                      "type": MOTION, "motion": "move_to_matched_symbol", "motion_args": { "inclusive": true, "to_jump_list": true } },
    { "keys": ["F", "{char}"],                  "type": MOTION, "motion": "move_to_next_char", "motion_args": { "forward": true, "inclusive": true } },
    { "keys": ["Shift+F", "{char}"],            "type": MOTION, "motion": "move_to_next_char", "motion_args": { "forward": false } },
    { "keys": ["T", "{char}"],                  "type": MOTION, "motion": "move_to_next_char", "motion_args": { "forward": true, "stop_before": true, "inclusive": true } },
    { "keys": ["Shift+T", "{char}"],            "type": MOTION, "motion": "move_to_next_char", "motion_args": { "forward": false, "stop_before": true } },
    { "keys": ["Semicolon"],                    "type": MOTION, "motion": "repeat_last_char_search", "motion_args": {} },
    { "keys": ["Shift+8"],                      "type": MOTION, "motion": "find_word_under_caret", "motion_args": { "forward": true, "to_jump_list": true } },
    { "keys": ["Shift+3"],                      "type": MOTION, "motion": "find_word_under_caret", "motion_args": { "forward": false, "to_jump_list": true } },
    { "keys": ["N"],                            "type": MOTION, "motion": "find_again", "motion_args": { "forward": true, "to_jump_list": true } },
    { "keys": ["Shift+N"],                      "type": MOTION, "motion": "find_again", "motion_args": { "forward": false, "to_jump_list": true } },
    { "keys": ["A", "Shift+9"],                 "type": MOTION, "motion": "text_object", "motion_args": { "inner": false, "object":"(" } },
    { "keys": ["A", "Shift+0"],                 "type": MOTION, "motion": "text_object", "motion_args": { "inner": false, "object":"(" } },
    { "keys": ["A", "B"],                       "type": MOTION, "motion": "text_object", "motion_args": { "inner": false, "object":"(" } },
    { "keys": ["A", "BracketLeft"],             "type": MOTION, "motion": "text_object", "motion_args": { "inner": false, "object":"[" } },
    { "keys": ["A", "BracketRight"],            "type": MOTION, "motion": "text_object", "motion_args": { "inner": false, "object":"[" } },
    { "keys": ["A", "Shift+BracketLeft"],       "type": MOTION, "motion": "text_object", "motion_args": { "inner": false, "object":"{" } },
    { "keys": ["A", "Shift+BracketRight"],      "type": MOTION, "motion": "text_object", "motion_args": { "inner": false, "object":"{" } },
    { "keys": ["A", "Shift+B"],                 "type": MOTION, "motion": "text_object", "motion_args": { "inner": false, "object":"{" } },
    { "keys": ["A", "Apostrophe"],              "type": MOTION, "motion": "text_object", "motion_args": { "inner": false, "object":"'" } },
    { "keys": ["A", 'Shift+Apostrophe'],        "type": MOTION, "motion": "text_object", "motion_args": { "inner": false, "object":'"' } },
    { "keys": ["I", "Shift+9"],                 "type": MOTION, "motion": "text_object", "motion_args": { "inner": true, "object":"(" } },
    { "keys": ["I", "Shift+0"],                 "type": MOTION, "motion": "text_object", "motion_args": { "inner": true, "object":"(" } },
    { "keys": ["I", "B"],                       "type": MOTION, "motion": "text_object", "motion_args": { "inner": true, "object":"(" } },
    { "keys": ["I", "BracketLeft"],             "type": MOTION, "motion": "text_object", "motion_args": { "inner": true, "object":"[" } },
    { "keys": ["I", "BracketRight"],            "type": MOTION, "motion": "text_object", "motion_args": { "inner": true, "object":"[" } },
    { "keys": ["I", "Shift+BracketLeft"],       "type": MOTION, "motion": "text_object", "motion_args": { "inner": true, "object":"{" } },
    { "keys": ["I", "Shift+BracketRight"],      "type": MOTION, "motion": "text_object", "motion_args": { "inner": true, "object":"{" } },
    { "keys": ["I", "Shift+B"],                 "type": MOTION, "motion": "text_object", "motion_args": { "inner": true, "object":"{" } },
    { "keys": ["I", "Apostrophe"],              "type": MOTION, "motion": "text_object", "motion_args": { "inner": true, "object":"'" } },
    { "keys": ["I", 'Shift+Apostrophe'],        "type": MOTION, "motion": "text_object", "motion_args": { "inner": true, "object":'"' } },
    { "keys": ["I", "W"],                       "type": MOTION, "motion": "text_object", "motion_args": { "inner": true, "object":"w" } },
    { "keys": ["D"],                            "type": OPERATOR, "operator": "delete" },
    { "keys": ["Shift+D"],                      "type": OPERATOR_MOTION, "operator": "delete", "motion": "move_to_end_of_line", "motion_args": { "inclusive": true } },
    { "keys": ["Y"],                            "type": OPERATOR, "operator": "yank" },
    { "keys": ["Shift+Y"],                      "type": OPERATOR_MOTION, "operator": "yank", "motion": "move_to_end_of_line", "motion_args": { "inclusive": true } },
    { "keys": ["C"],                            "type": OPERATOR, "operator": "change" },
    { "keys": ["Shift+C"],                      "type": OPERATOR_MOTION, "operator": "change", "motion": "move_to_end_of_line", "motion_args": { "inclusive": true } },
    { "keys": ["X"],                            "type": OPERATOR_MOTION, "operator": "delete", "motion": "move_by_characters", "motion_args": { "forward": true, "one_line": true }, "context": Context.NORMAL },
    { "keys": ["X"],                            "type": OPERATOR, "operator": "delete", "context": Context.VISUAL },
    { "keys": ["Shift+X"],                      "type": OPERATOR_MOTION, "operator": "delete", "motion": "move_by_characters", "motion_args": { "forward": false } },
    { "keys": ["U"],                            "type": OPERATOR, "operator": "change_case", "operator_args": { "lower": true }, "context": Context.VISUAL },
    { "keys": ["Shift+U"],                      "type": OPERATOR, "operator": "change_case", "operator_args": { "lower": false }, "context": Context.VISUAL },
    { "keys": ["Shift+QuoteLeft"],              "type": OPERATOR, "operator": "toggle_case", "operator_args": {}, "context": Context.VISUAL },
    { "keys": ["Shift+QuoteLeft"],              "type": OPERATOR_MOTION, "operator": "toggle_case", "motion": "move_by_characters", "motion_args": { "forward": true }, "context": Context.NORMAL },
    { "keys": ["P"],                            "type": ACTION, "action": "paste", "action_args": { "after": true } },
    { "keys": ["Shift+P"],                      "type": ACTION, "action": "paste", "action_args": { "after": false } },
    { "keys": ["U"],                            "type": ACTION, "action": "undo", "action_args": {}, "context": Context.NORMAL },
    { "keys": ["Ctrl+R"],                       "type": ACTION, "action": "redo", "action_args": {} },
    { "keys": ["R", "{char}"],                  "type": ACTION, "action": "replace", "action_args": {} },
    { "keys": ["Period"],                       "type": ACTION, "action": "repeat_last_edit", "action_args": {} },
    { "keys": ["I"],                            "type": ACTION, "action": "enter_insert_mode", "action_args": { "insert_at": "inplace" }, "context": Context.NORMAL },
    { "keys": ["Shift+I"],                      "type": ACTION, "action": "enter_insert_mode", "action_args": { "insert_at": "bol" } },
    { "keys": ["A"],                            "type": ACTION, "action": "enter_insert_mode", "action_args": { "insert_at": "after" }, "context": Context.NORMAL },
    { "keys": ["Shift+A"],                      "type": ACTION, "action": "enter_insert_mode", "action_args": { "insert_at": "eol" } },
    { "keys": ["O"],                            "type": ACTION, "action": "enter_insert_mode", "action_args": { "insert_at": "new_line_below" } },
    { "keys": ["Shift+O"],                      "type": ACTION, "action": "enter_insert_mode", "action_args": { "insert_at": "new_line_above" } },
    { "keys": ["V"],                            "type": ACTION, "action": "enter_visual_mode", "action_args": { "line_wise": false } },
    { "keys": ["Shift+V"],                      "type": ACTION, "action": "enter_visual_mode", "action_args": { "line_wise": true } },
    { "keys": ["Slash"],                        "type": ACTION, "action": "search", "action_args": {} },
    { "keys": ["Ctrl+O"],                       "type": ACTION, "action": "jump_list_walk", "action_args": { "forward": false } },
    { "keys": ["Ctrl+I"],                       "type": ACTION, "action": "jump_list_walk", "action_args": { "forward": true } },
    { "keys": ["Z", "A"],                       "type": ACTION, "action": "toggle_folding", },
    { "keys": ["Z", "Shift+M"],                 "type": ACTION, "action": "fold_all", },
    { "keys": ["Z", "Shift+R"],                 "type": ACTION, "action": "unfold_all", },
    { "keys": ["Q", "{char}"],                  "type": ACTION, "action": "record_macro", "when_not": "is_recording" },
    { "keys": ["Q"],                            "type": ACTION, "action": "stop_record_macro", "when": "is_recording" },
    { "keys": ["Shift+2", "{char}"],            "type": ACTION, "action": "play_macro", },
    { "keys": ["Shift+Comma"],                  "type": ACTION, "action": "indent", "action_args": { "forward" = false} },
    { "keys": ["Shift+Period"],                 "type": ACTION, "action": "indent", "action_args": {  "forward" = true } },
    { "keys": ["Shift+J"],                      "type": ACTION, "action": "join_lines", "action_args": {} },
    { "keys": ["M", "{char}"],                  "type": ACTION, "action": "set_bookmark", "action_args": {} },
    { "keys": ["Apostrophe", "{char}"],         "type": MOTION, "motion": "go_to_bookmark", "motion_args": {} },
]


# The list of command keys we handle (other command keys will be handled by Godot)
var command_keys_white_list : Dictionary = {
    "Escape": 1,
    "Enter": 1,
    # "Ctrl+F": 1,  # Uncomment if you would like move-forward by page function instead of search on slash
    "Ctrl+B": 1,
    "Ctrl+U": 1,
    "Ctrl+D": 1,
    "Ctrl+O": 1,
    "Ctrl+I": 1,
    "Ctrl+R": 1
}


var editor_interface : EditorInterface
var the_ed := EditorAdaptor.new() # The current editor adaptor
var the_vim := Vim.new()
var the_dispatcher := CommandDispatcher.new(the_key_map) # The command dispatcher


func _enter_tree() -> void:
    editor_interface = get_editor_interface()

    var script_editor = editor_interface.get_script_editor()
    script_editor.editor_script_changed.connect(on_script_changed)
    script_editor.script_close.connect(on_script_closed)
    on_script_changed(script_editor.get_current_script())

    var settings = editor_interface.get_editor_settings()
    settings.settings_changed.connect(on_settings_changed)
    on_settings_changed()

    var find_bar = find_first_node_of_type(script_editor, 'FindReplaceBar')
    var find_bar_line_edit : LineEdit = find_first_node_of_type(find_bar, 'LineEdit')
    find_bar_line_edit.text_changed.connect(on_search_text_changed)


func _input(event) -> void:
    var key = event as InputEventKey

    # Don't process when not a key action
    if key == null or !key.is_pressed() or not the_ed.has_focus():
        return

    if key.get_keycode_with_modifiers() == KEY_NONE and key.unicode == CODE_MACRO_PLAY_END:
        the_vim.macro_manager.on_macro_finished(the_ed)
        get_viewport().set_input_as_handled()
        return

    # Check to not block some reserved keys (we only handle unicode keys and the white list)
    var key_code = key.as_text_keycode()
    if DEBUGGING:
        print("Key: %s Buffer: %s" % [key_code, the_vim.current.input_state.key_codes()])

    # We only process keys in the white list or it is ASCII char or SHIFT+ASCII char
    if key.get_keycode_with_modifiers() & (~KEY_MASK_SHIFT) > 128 and key_code not in command_keys_white_list:
        return

    if the_dispatcher.dispatch(key, the_vim, the_ed):
        get_viewport().set_input_as_handled()


func on_script_changed(s: Script) -> void:
    the_vim.set_current_session(s, the_ed)

    var script_editor = editor_interface.get_script_editor()
    var scrpit_editor_base := script_editor.get_current_editor()
    if scrpit_editor_base:
        var code_editor := scrpit_editor_base.get_base_editor() as CodeEdit
        the_ed.set_code_editor(code_editor)
        the_ed.set_block_caret(true)

        if not code_editor.is_connected("caret_changed", on_caret_changed):
            code_editor.caret_changed.connect(on_caret_changed)
        if not code_editor.is_connected("lines_edited_from", on_lines_edited_from):
            code_editor.lines_edited_from.connect(on_lines_edited_from)


func on_script_closed(s: Script) -> void:
    the_vim.remove_session(s)


func on_settings_changed() -> void:
    var settings := editor_interface.get_editor_settings()
    the_ed.notify_settings_changed(settings)


func on_caret_changed()-> void:
    the_ed.set_block_caret(not the_vim.current.insert_mode)


func on_lines_edited_from(from: int, to: int) -> void:
    the_vim.current.jump_list.on_lines_edited(from, to)
    the_vim.current.text_change_number += 1
    the_vim.current.bookmark_manager.on_lines_edited(from, to)


func on_search_text_changed(new_search_text: String) -> void:
    the_vim.search_buffer = new_search_text


static func find_first_node_of_type(p: Node, type: String) -> Node:
    if p.get_class() == type:
        return p
    for c in p.get_children():
        var t := find_first_node_of_type(c, type)
        if t:
            return t
    return null


class Command:

    ###  MOTIONS

    static func move_by_characters(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        var one_line = args.get('one_line', false)
        var col : int = cur.column + args.repeat * (1 if args.forward else -1)
        var line := cur.line
        if col > ed.last_column(line):
            if one_line:
                col = ed.last_column(line) + 1
            else:
                line += 1
                col = 0
        elif col < 0:
            if one_line:
                col = 0
            else:
                line -= 1
                col = ed.last_column(line)
        return Position.new(line, col)

    static func move_by_scroll(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        var count = ed.get_visible_line_count(ed.first_visible_line(), ed.last_visible_line())
        return Position.new(ed.next_unfolded_line(cur.line, count / 2, args.forward), cur.column)

    static func move_by_page(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        var count = ed.get_visible_line_count(ed.first_visible_line(), ed.last_visible_line())
        return Position.new(ed.next_unfolded_line(cur.line, count, args.forward), cur.column)

    static func move_to_column(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        return Position.new(cur.line, args.repeat - 1)

    static func move_by_lines(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        # Depending what our last motion was, we may want to do different things.
        # If our last motion was moving vertically, we want to preserve the column from our
        # last horizontal move.  If our last motion was going to the end of a line,
        # moving vertically we should go to the end of the line, etc.
        var col : int = cur.column
        match vim.current.last_motion:
            "move_by_lines", "move_by_scroll", "move_by_page", "move_to_end_of_line", "move_to_column":
                col = vim.current.last_h_pos
            _:
                vim.current.last_h_pos = col

        var line = ed.next_unfolded_line(cur.line, args.repeat, args.forward)
        if args.get("to_first_char", false):
            col = ed.find_first_non_white_space_character(line)

        return Position.new(line, col)

    static func move_to_first_non_white_space_character(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        var i := ed.find_first_non_white_space_character(ed.curr_line())
        return Position.new(cur.line, i)

    static func move_to_start_of_line(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        return Position.new(cur.line, 0)

    static func move_to_end_of_line(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        var line = cur.line
        if args.repeat > 1:
            line = ed.next_unfolded_line(line, args.repeat - 1)
        vim.current.last_h_pos = INF_COL
        return Position.new(line, ed.last_column(line))

    static func move_to_top_line(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        return Position.new(ed.first_visible_line(), cur.column)

    static func move_to_bottom_line(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        return Position.new(ed.last_visible_line(), cur.column)

    static func move_to_middle_line(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        var first := ed.first_visible_line()
        var count = ed.get_visible_line_count(first, ed.last_visible_line())
        return Position.new(ed.next_unfolded_line(first, count / 2), cur.column)

    static func move_to_line_or_edge_of_document(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        var line = ed.last_line() if args.forward else ed.first_line()
        if args.repeat_is_explicit:
            line = args.repeat + ed.first_line() - 1
        return Position.new(line, ed.find_first_non_white_space_character(line))

    static func move_by_words(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        var start_line := cur.line
        var start_col := cur.column
        var start_pos := cur.duplicate()

        # If we are beyond line end, move it to line end
        if start_col > 0 and start_col == ed.last_column(start_line) + 1:
            cur = Position.new(start_line, start_col-1)

        var forward : bool = args.forward
        var word_end : bool = args.word_end
        var big_word : bool = args.big_word
        var repeat : int = args.repeat
        var empty_line_is_word := not (forward and word_end) # For 'e', empty lines are not considered words
        var one_line := not vim.current.input_state.operator.is_empty() # if there is an operator pending, let it not beyond the line end each time

        if (forward and !word_end) or (not forward and word_end): # w or ge
            repeat += 1

        var words : Array[TextRange] = []
        for i in range(repeat):
            var word = _find_word(cur, ed, forward, big_word, empty_line_is_word, one_line)
            if word != null:
                words.append(word)
                cur = Position.new(word.from.line, word.to.column-1 if forward else word.from.column)
            else: # eof
                words.append(TextRange.new(ed.last_pos(), ed.last_pos()) if forward else TextRange.zero)
                break

        var short_circuit : bool = len(words) != repeat
        var first_word := words[0]
        var last_word : TextRange = words.pop_back()
        if forward and not word_end: # w
            if vim.current.input_state.operator == "change":  # cw need special treatment to not cover whitespaces
                if not short_circuit:
                    last_word = words.pop_back()
                return last_word.to
            if not short_circuit and not start_pos.equals(first_word.from):
                last_word = words.pop_back() # We did not start in the middle of a word. Discard the extra word at the end.
            return last_word.from
        elif forward and word_end: # e
            return last_word.to.left()
        elif not forward and word_end: # ge
            if not short_circuit and not start_pos.equals(first_word.to.left()):
                last_word = words.pop_back() # We did not start in the middle of a word. Discard the extra word at the end.
            return last_word.to.left()
        else: # b
            return last_word.from

    static func move_to_matched_symbol(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        # Get the symbol to match
        var symbol := ed.find_forward(cur.line, cur.column, func(c): return c.char in "()[]{}", true)
        if symbol == null: # No symbol found in this line after or under caret
            return null

        var counter_part : String = SYMBOLS[symbol.char]

        # Two attemps to find the symbol pair: from line start or doc start
        for from in [Position.new(symbol.line, 0), Position.new(0, 0)]:
            var parser = GDScriptParser.new(ed, from)
            if not parser.parse_until(symbol):
               continue

            if symbol.char in ")]}":
                parser.stack.reverse()
                for p in parser.stack:
                    if p.char == counter_part:
                        return p
                continue
            else:
                parser.parse_one_char()
                return parser.find_matching()
        return null

    static func move_to_next_char(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        vim.last_char_search = args

        var forward : bool = args.forward
        var stop_before : bool = args.get("stop_before", false)
        var to_find = args.selected_character
        var repeat : int = args.repeat

        var old_pos := cur.duplicate()
        for ch in ed.chars(cur.line, cur.column + (1 if forward else -1), forward, true):
            if ch.char == to_find:
                repeat -= 1
                if repeat == 0:
                    return old_pos if stop_before else Position.new(ch.line, ch.column)
            old_pos = Position.new(ch.line, ch.column)
        return null

    static func repeat_last_char_search(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        var last_char_search := vim.last_char_search
        if last_char_search.is_empty():
            return null
        args.forward = last_char_search.forward
        args.selected_character = last_char_search.selected_character
        args.stop_before = last_char_search.get("stop_before", false)
        args.inclusive = last_char_search.get("inclusive", false)
        return move_to_next_char(cur, args, ed, vim)

    static func expand_to_line(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        return Position.new(cur.line + args.repeat - 1, INF_COL)

    static func find_word_under_caret(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        var forward : bool = args.forward
        var range := ed.get_word_at_pos(cur.line, cur.column)
        var text := ed.range_text(range)
        var pos := ed.search(text, cur.line, cur.column + (1 if forward else -1), false, true, forward)
        vim.last_search_command = "*" if forward else "#"
        vim.search_buffer = text
        return pos

    static func find_again(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        var forward : bool = args.forward
        forward = forward == (vim.last_search_command != "#")
        var case_sensitive := vim.last_search_command in "*#"
        var whole_word := vim.last_search_command in "*#"
        cur = cur.next(ed) if forward else cur.prev(ed)
        return ed.search(vim.search_buffer, cur.line, cur.column, case_sensitive, whole_word, forward)

    static func text_object(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Variant:
        var inner : bool = args.inner
        var obj : String = args.object

        if obj == "w" and inner:
            return ed.get_word_at_pos(cur.line, cur.column)

        if obj in "([{\"'":
            var counter_part : String = SYMBOLS[obj]
            for from in [Position.new(cur.line, 0), Position.new(0, 0)]: # Two attemps: from line beginning doc beginning
                var parser = GDScriptParser.new(ed, from)
                if not parser.parse_until(cur):
                    continue

                var range = TextRange.zero
                if parser.stack_top_char == obj:
                    range.from = parser.stack.back()
                    range.to = parser.find_matching()
                elif ed.char_at(cur.line, cur.column) == obj:
                    parser.parse_one_char()
                    range.from = parser.pos
                    range.to = parser.find_matching()
                else:
                    continue

                if range.from == null or range.to == null:
                    continue

                if inner:
                    range.from = range.from.next(ed)
                else:
                    range.to = range.to.next(ed)
                return range

        return null


###  OPERATORS

    static func delete(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var text := ed.selected_text()
        vim.register.set_text(text, args.get("line_wise", false))
        ed.delete_selection()
        var line := ed.curr_line()
        var col := ed.curr_column()
        if col > ed.last_column(line): # If after deletion we are beyond the end, move left
            ed.set_curr_column(ed.last_column(line))

    static func yank(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var text := ed.selected_text()
        ed.deselect()
        vim.register.set_text(text, args.get("line_wise", false))

    static func change(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var text := ed.selected_text()
        vim.register.set_text(text, args.get("line_wise", false))

        vim.current.enter_insert_mode();
        ed.delete_selection()

    static func change_case(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var lower_case : bool = args.get("lower", false)
        var text := ed.selected_text()
        ed.replace_selection(text.to_lower() if lower_case else text.to_upper())

    static func toggle_case(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var text := ed.selected_text()
        var s := PackedStringArray()
        for c in text:
            s.append(c.to_lower() if c == c.to_upper() else c.to_upper())
        ed.replace_selection(''.join(s))


    ###  ACTIONS

    static func paste(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var after : bool = args.after
        var line_wise := vim.register.line_wise
        var clipboard_text := vim.register.text

        var text : String = ""
        for i in range(args.repeat):
            text += clipboard_text

        var line := ed.curr_line()
        var col := ed.curr_column()

        if line_wise:
            if after:
                text = "\n" + text.substr(0, len(text)-1)
                col = len(ed.line_text(line))
            else:
                col = 0
        else:
            col += 1 if after else 0

        ed.set_curr_column(col)
        ed.insert_text(text)

    static func undo(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        for i in range(args.repeat):
            ed.undo()
        ed.deselect()

    static func redo(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        for i in range(args.repeat):
            ed.redo()
        ed.deselect()

    static func replace(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var to_replace = args.selected_character
        var line := ed.curr_line()
        var col := ed.curr_column()
        ed.select(line, col, line, col+1)
        ed.replace_selection(to_replace)

    static func enter_insert_mode(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var insert_at : String = args.insert_at
        var line = ed.curr_line()
        var col = ed.curr_column()

        vim.current.enter_insert_mode()

        match insert_at:
            "inplace":
                pass
            "after":
                ed.set_curr_column(col + 1)
            "bol":
                ed.set_curr_column(ed.find_first_non_white_space_character(line))
            "eol":
                ed.set_curr_column(INF_COL)
            "new_line_below":
                ed.set_curr_column(INF_COL)
                ed.simulate_press(KEY_ENTER)
            "new_line_above":
                ed.set_curr_column(0)
                if line == ed.first_line():
                    ed.insert_text("\n")
                    ed.jump_to(0, 0)
                else:
                    ed.jump_to(line - 1, INF_COL)
                    ed.simulate_press(KEY_ENTER)

    static func enter_visual_mode(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var line_wise : bool = args.get('line_wise', false)
        vim.current.enter_visual_mode(line_wise)

    static func search(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        if OS.get_name() == "macOS":
            ed.simulate_press(KEY_F, 0, false, false, false, true)
        else:
            ed.simulate_press(KEY_F, 0, true, false, false, false)
        vim.last_search_command = "/"

    static func jump_list_walk(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var offset : int = args.repeat * (1 if args.forward else -1)
        var pos : Position = vim.current.jump_list.move(offset)
        if pos != null:
            if not args.forward:
                vim.current.jump_list.set_next(ed.curr_position())
            ed.jump_to(pos.line, pos.column)

    static func toggle_folding(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        ed.toggle_folding(ed.curr_line())

    static func fold_all(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        ed.fold_all()

    static func unfold_all(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        ed.unfold_all()

    static func repeat_last_edit(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var repeat : int = args.repeat
        vim.macro_manager.play_macro(repeat, ".", ed)
        
    static func record_macro(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var name = args.selected_character
        if name in ALPHANUMERIC:
            vim.macro_manager.start_record_macro(name)

    static func stop_record_macro(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        vim.macro_manager.stop_record_macro()

    static func play_macro(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var name = args.selected_character
        var repeat : int = args.repeat
        if name in ALPHANUMERIC:
            vim.macro_manager.play_macro(repeat, name, ed)

    static func is_recording(ed: EditorAdaptor, vim: Vim) -> bool:
        return vim.macro_manager.is_recording()

    static func indent(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var repeat : int = args.repeat
        var forward : bool = args.get("forward", false)
        var range = ed.selection()

        if not range.is_single_line() and range.to.column == 0: # Don't select the last empty line
            ed.select(range.from.line, range.from.column, range.to.line-1, INF_COL)

        ed.begin_complex_operation()
        for i in range(repeat):
            if forward:
                ed.indent()
            else:
                ed.unindent()
        ed.end_complex_operation()

    static func join_lines(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        if vim.current.normal_mode:
            var line := ed.curr_line()
            ed.select(line, 0, line + args.repeat, INF_COL)

        var range := ed.selection()
        ed.select(range.from.line, 0, range.to.line, INF_COL)
        var s := PackedStringArray()
        s.append(ed.line_text(range.from.line))
        for line in range(range.from.line + 1, range.to.line + 1):
            s.append(ed.line_text(line).lstrip(' \t\n'))
        ed.replace_selection(' '.join(s))

    static func set_bookmark(args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        var name = args.selected_character
        if name in LOWER_ALPHA:
            vim.current.bookmark_manager.set_bookmark(name, ed.curr_line())

    static func go_to_bookmark(cur: Position, args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Position:
        var name = args.selected_character
        var line := vim.current.bookmark_manager.get_bookmark(name)
        if line < 0:
            return null
        return Position.new(line, 0)


    ###  HELPER FUNCTIONS

    ## Returns the boundaries of the next word. If the cursor in the middle of the word, then returns the boundaries of the current word, starting at the cursor.
    ## If the cursor is at the start/end of a word, and we are going forward/backward, respectively, find the boundaries of the next word.
    static func _find_word(cur: Position, ed: EditorAdaptor, forward: bool, big_word: bool, empty_line_is_word: bool, one_line: bool) -> TextRange:
        var char_tests := [ func(c): return c in ALPHANUMERIC or c in BREAKERS ] if big_word else [ func(c): return c in ALPHANUMERIC, func(c): return c in BREAKERS ]

        for p in ed.chars(cur.line, cur.column, forward):
            if one_line and p.char == '\n': # If we only allow search in one line and we met the line end
                return TextRange.from_num3(p.line, p.column, INF_COL)

            if p.line != cur.line and empty_line_is_word and p.line_text.strip_edges() == '':
                return TextRange.from_num3(p.line, 0, 0)

            for char_test in char_tests:
                if char_test.call(p.char):
                    var word_start := p.column
                    var word_end := word_start
                    for q in ed.chars(p.line, p.column, forward, true): # Advance to end of word.
                        if not char_test.call(q.char):
                            break
                        word_end = q.column

                    if p.line == cur.line and word_start == cur.column and word_end == word_start:
                        continue # We started at the end of a word. Find the next one.
                    else:
                        return TextRange.from_num3(p.line, min(word_start, word_end), max(word_start + 1, word_end + 1))
        return null


class Position:
    var line: int
    var column: int

    static var zero :Position:
        get:
            return Position.new(0, 0)

    func _init(l: int, c: int):
        line = l
        column = c

    func _to_string() -> String:
        return "(%s, %s)" % [line, column]

    func equals(other: Position) -> bool:
        return line == other.line and column == other.column

    func compares_to(other: Position) -> int:
        if line < other.line: return -1
        if line > other.line: return 1
        if column < other.column: return -1
        if column > other.column: return 1
        return 0

    func duplicate() -> Position: return Position.new(line, column)
    func up() -> Position: return Position.new(line-1, column)
    func down() -> Position: return Position.new(line+1, column)
    func left() -> Position: return Position.new(line, column-1)
    func right() -> Position: return Position.new(line, column+1)
    func next(ed: EditorAdaptor) -> Position: return ed.offset_pos(self, 1)
    func prev(ed: EditorAdaptor) -> Position: return ed.offset_pos(self, -1)


class TextRange:
    var from: Position
    var to: Position

    static var zero : TextRange:
        get:
            return TextRange.new(Position.zero, Position.zero)

    static func from_num4(from_line: int, from_column: int, to_line: int, to_column: int):
        return TextRange.new(Position.new(from_line, from_column), Position.new(to_line, to_column))

    static func from_num3(line: int, from_column: int, to_column: int):
        return from_num4(line, from_column, line, to_column)

    func _init(f: Position, t: Position):
        from = f
        to = t

    func _to_string() -> String:
        return "[%s - %s]" % [from, to]

    func is_single_line() -> bool:
        return from.line == to.line

    func is_empty() -> bool:
        return from.line == to.line and from.column == to.column


class CharPos extends Position:
    var line_text : String

    var char: String:
        get:
            return line_text[column] if column < len(line_text) else '\n'

    func _init(line_text: String, line: int, col: int):
        super(line, col)
        self.line_text = line_text


class JumpList:
    var buffer: Array[Position]
    var pointer: int = 0

    func _init(capacity: int = 20):
        buffer = []
        buffer.resize(capacity)

    func add(old_pos: Position, new_pos: Position) -> void:
        var current : Position = buffer[pointer]
        if current == null or not current.equals(old_pos):
            pointer = (pointer + 1) % len(buffer)
            buffer[pointer] = old_pos
        pointer = (pointer + 1) % len(buffer)
        buffer[pointer] = new_pos

    func set_next(pos: Position) -> void:
        buffer[(pointer + 1) % len(buffer)] = pos # This overrides next forward position (TODO: an insert might be better)

    func move(offset: int) -> Position:
        var t := (pointer + offset) % len(buffer)
        var r : Position = buffer[t]
        if r != null:
            pointer = t
        return r

    func on_lines_edited(from: int, to: int) -> void:
        for pos in buffer:
            if pos != null and pos.line > from: # Unfortunately we don't know which column changed
                pos.line += to - from


class InputState:
    var prefix_repeat: String
    var motion_repeat: String
    var operator: String
    var operator_args: Dictionary
    var buffer: Array[InputEventKey] = []

    func push_key(key: InputEventKey) -> void:
        buffer.append(key)

    func push_repeat_digit(d: String) -> void:
        if operator.is_empty():
            prefix_repeat += d
        else:
            motion_repeat += d

    func get_repeat() -> int:
        var repeat : int = 0
        if prefix_repeat:
            repeat = max(repeat, 1) * int(prefix_repeat)
        if motion_repeat:
            repeat = max(repeat, 1) * int(motion_repeat)
        return repeat

    func key_codes() -> Array[String]:
        var r : Array[String] = []
        for k in buffer:
            r.append(k.as_text_keycode())
        return r

    func clear() -> void:
        prefix_repeat = ""
        motion_repeat = ""
        operator = ""
        buffer.clear()


class GDScriptParser:
    const open_symbol := { "(": ")", "[": "]", "{": "}", "'": "'", '"': '"' }
    const close_symbol := { ")": "(", "]": "[", "}": "{", }

    var stack : Array[CharPos]
    var in_comment := false
    var escape_count := 0
    var valid: bool = true
    var eof : bool = false
    var pos: Position

    var stack_top_char : String:
        get:
            return "" if stack.is_empty() else stack.back().char

    var _it: CharIterator
    var _ed : EditorAdaptor

    func _init(ed: EditorAdaptor, from: Position):
        _ed = ed
        _it = ed.chars(from.line, from.column)
        if not _it._iter_init(null):
            eof = true

    func parse_until(to: Position) -> bool:
        while valid and not eof:
            parse_one_char()
            if _it.line == to.line and _it.column == to.column:
                break
        return valid and not eof


    func find_matching() -> Position:
        var depth := len(stack)
        while valid and not eof:
            parse_one_char()
            if len(stack) < depth:
                return pos
        return null

    func parse_one_char() -> String: # ChatGPT got credit here
        if eof or not valid:
            return ""

        var p := _it._iter_get(null)
        pos = p

        if not _it._iter_next(null):
            eof = true

        var char := p.char
        var top: String = '' if stack.is_empty() else stack.back().char
        if top in "'\"": # in string
            if char == top and escape_count % 2 == 0:
                stack.pop_back()
                escape_count = 0
                return char
            escape_count = escape_count + 1 if char == "\\" else 0
        elif in_comment:
            if char == "\n":
                in_comment = false
        elif char == "#":
            in_comment = true
        elif char in open_symbol:
            stack.append(p)
            return char
        elif char in close_symbol:
            if top == close_symbol[char]:
                stack.pop_back()
                return char
            else:
                valid = false
        return ""


class Register:
    var line_wise : bool = false
    var text : String:
        get:
            return DisplayServer.clipboard_get()

    func set_text(value: String, line_wise: bool) -> void:
        self.line_wise = line_wise
        DisplayServer.clipboard_set(value)


class BookmarkManager:
    var bookmarks : Dictionary

    func on_lines_edited(from: int, to: int) -> void:
        for b in bookmarks:
            var line : int = bookmarks[b]
            if line > from:
                bookmarks[b] += to - from

    func set_bookmark(name: String, line: int) -> void:
        bookmarks[name] = line

    func get_bookmark(name: String) -> int:
        return bookmarks.get(name, -1)


class CommandMatchResult:
    var full: Array[Dictionary] = []
    var partial: Array[Dictionary] = []


class VimSession:
    var ed : EditorAdaptor

    ## Mode         insert_mode | visual_mode | visual_line
    ## Insert       true        | false       | false
    ## Normal       false       | false       | false
    ## Visual       false       | true        | false
    ## Visual Line  false       | true        | true
    var insert_mode : bool = false
    var visual_mode : bool = false
    var visual_line : bool = false

    var normal_mode: bool:
        get:
            return not insert_mode and not visual_mode

    ## Pending input
    var input_state := InputState.new()

    ## The last motion occurred
    var last_motion : String

    ## When using jk for navigation, if you move from a longer line to a shorter line, the cursor may clip to the end of the shorter line.
    ## If j is pressed again and cursor goes to the next line, the cursor should go back to its horizontal position on the longer
    ## line if it can. This is to keep track of the horizontal position.
    var last_h_pos : int = 0

    ## How many times text are changed
    var text_change_number : int

    ## List of positions for C-I and C-O
    var jump_list := JumpList.new()

    ## The bookmark manager of the session
    var bookmark_manager := BookmarkManager.new()

    ## The start position of visual mode
    var visual_start_pos := Position.zero

    func enter_normal_mode() -> void:
        if insert_mode:
            ed.end_complex_operation() # Wrap up the undo operation when we get out of insert mode

        insert_mode = false
        visual_mode = false
        visual_line = false
        ed.set_block_caret(true)

    func enter_insert_mode() -> void:
        insert_mode = true
        visual_mode = false
        visual_line = false
        ed.set_block_caret(false)
        ed.begin_complex_operation()

    func enter_visual_mode(line_wise: bool) -> void:
        insert_mode = false
        visual_mode = true
        visual_line = line_wise
        ed.set_block_caret(true)

        visual_start_pos = ed.curr_position()
        if line_wise:
            ed.select(visual_start_pos.line, 0, visual_start_pos.line + 1, 0)
        else:
            ed.select_by_pos2(visual_start_pos, visual_start_pos.right())


class Macro:
    var keys : Array[InputEventKey] = []
    var enabled := false

    func _to_string() -> String:
        var s := PackedStringArray()
        for key in keys:
            s.append(key.as_text_keycode())
        return ",".join(s)

    func play(ed: EditorAdaptor) -> void:
        for key in keys:
            ed.simulate_press_key(key)
        ed.simulate_press(KEY_ESCAPE)


class MacroManager:
    var vim : Vim
    var macros : Dictionary = {}
    var recording_name : String
    var playing_names : Array[String] = []
    var command_buffer: Array[InputEventKey]

    func _init(vim: Vim):
        self.vim = vim

    func start_record_macro(name: String):
        print('Recording macro "%s"...' % name )
        macros[name] = Macro.new()
        recording_name = name

    func stop_record_macro() -> void:
        print('Stop recording macro "%s"' % recording_name)
        macros[recording_name].enabled = true
        recording_name = ""

    func is_recording() -> bool:
        return recording_name != ""

    func play_macro(n: int, name: String, ed: EditorAdaptor) -> void:
        var macro : Macro = macros.get(name, null)
        if (macro == null or not macro.enabled):
            return
        if name in playing_names:
            return # to avoid recursion

        playing_names.append(name)
        if len(playing_names) == 1:
            ed.begin_complex_operation()

        if DEBUGGING:
            print("Playing macro %s: %s" % [name, macro])

        for i in range(n):
            macro.play(ed)

        ed.simulate_press(KEY_NONE, CODE_MACRO_PLAY_END)  # This special marks the end of macro play
        
    func on_macro_finished(ed: EditorAdaptor):
        var name : String = playing_names.pop_back()
        if playing_names.is_empty():
            ed.end_complex_operation()

    func push_key(key: InputEventKey) -> void:
        command_buffer.append(key)
        if recording_name:
            macros[recording_name].keys.append(key)

    func on_command_processed(command: Dictionary, is_edit: bool) -> void:
        if is_edit and command.get('action', '') != "repeat_last_edit":
            var macro := Macro.new()
            macro.keys = command_buffer.duplicate()
            macro.enabled = true
            macros["."] = macro
        command_buffer.clear()


## Global VIM state; has multiple sessions
class Vim:
    var sessions : Dictionary
    var current: VimSession
    var register: Register = Register.new()
    var last_char_search: Dictionary = {}  # { selected_character, stop_before, forward, inclusive }
    var last_search_command: String
    var search_buffer: String
    var macro_manager := MacroManager.new(self)

    func set_current_session(s: Script, ed: EditorAdaptor):
        var session : VimSession = sessions.get(s)
        if not session:
            session = VimSession.new()
            session.ed = ed
            sessions[s] = session
        current = session

    func remove_session(s: Script):
        sessions.erase(s)


class CharIterator:
    var ed : EditorAdaptor
    var line : int
    var column : int
    var forward : bool
    var one_line : bool
    var line_text : String

    func _init(ed: EditorAdaptor, line: int, col: int, forward: bool, one_line: bool):
        self.ed = ed
        self.line = line
        self.column = col
        self.forward = forward
        self.one_line = one_line

    func _ensure_column_valid() -> bool:
        if column < 0 or column > len(line_text):
            line += 1 if forward else -1
            if one_line or line < 0 or line > ed.last_line():
                return false
            line_text  = ed.line_text(line)
            column = 0 if forward else len(line_text)
        return true

    func _iter_init(arg) -> bool:
        if line < 0 or line > ed.last_line():
            return false
        line_text = ed.line_text(line)
        return _ensure_column_valid()

    func _iter_next(arg) -> bool:
        column += 1 if forward else -1
        return _ensure_column_valid()

    func _iter_get(arg) -> CharPos:
        return CharPos.new(line_text, line, column)


class EditorAdaptor:
    var code_editor: CodeEdit
    var tab_width : int = 4
    var complex_ops : int = 0

    func set_code_editor(new_editor: CodeEdit) -> void:
        self.code_editor = new_editor

    func notify_settings_changed(settings: EditorSettings) -> void:
        tab_width = settings.get_setting("text_editor/behavior/indent/size") as int

    func curr_position() -> Position:
        return Position.new(code_editor.get_caret_line(), code_editor.get_caret_column())

    func curr_line() -> int:
        return code_editor.get_caret_line()

    func curr_column() -> int:
        return code_editor.get_caret_column()

    func set_curr_column(col: int) -> void:
        code_editor.set_caret_column(col)

    func jump_to(line: int, col: int) -> void:
        code_editor.unfold_line(line)

        if line < first_visible_line():
            code_editor.set_line_as_first_visible(max(0, line-8))
        elif line > last_visible_line():
            code_editor.set_line_as_last_visible(min(last_line(), line+8))
        code_editor.set_caret_line(line)
        code_editor.set_caret_column(col)


    func first_line() -> int:
        return 0

    func last_line() -> int :
        return code_editor.get_line_count() - 1

    func first_visible_line() -> int:
        return code_editor.get_first_visible_line()

    func last_visible_line() -> int:
        return code_editor.get_last_full_visible_line()

    func get_visible_line_count(from_line: int, to_line: int) -> int:
        return code_editor.get_visible_line_count_in_range(from_line, to_line)

    func next_unfolded_line(line: int, offset: int = 1, forward: bool = true) -> int:
        var step : int = 1 if forward else -1
        if line + step > last_line() or line + step  < first_line():
            return line
        var count := code_editor.get_next_visible_line_offset_from(line + step, offset * step)
        return line + count * (1 if forward else -1)

    func last_column(line: int = -1) -> int:
        if line == -1:
            line = curr_line()
        return len(line_text(line)) - 1

    func last_pos() -> Position:
        var line = last_line()
        return Position.new(line, last_column(line))

    func line_text(line: int) -> String:
        return code_editor.get_line(line)

    func range_text(range: TextRange) -> String:
        var s := PackedStringArray()
        for p in chars(range.from.line, range.from.column):
            if p.equals(range.to):
                break
            s.append(p.char)
        return "".join(s)

    func char_at(line: int, col: int) -> String:
        var s := line_text(line)
        return s[col] if col >= 0 and col < len(s) else ''

    func set_block_caret(block: bool) -> void:
        if block:
            if curr_column() == last_column() + 1:
                code_editor.caret_type = TextEdit.CARET_TYPE_LINE
                code_editor.add_theme_constant_override("caret_width", 8)
            else:
                code_editor.caret_type = TextEdit.CARET_TYPE_BLOCK
                code_editor.add_theme_constant_override("caret_width", 1)
        else:
            code_editor.add_theme_constant_override("caret_width", 1)
            code_editor.caret_type = TextEdit.CARET_TYPE_LINE

    func deselect() -> void:
        code_editor.deselect()

    func select_range(r: TextRange) -> void:
        select(r.from.line, r.from.column, r.to.line, r.to.column)

    func select_by_pos2(from: Position, to: Position) -> void:
        select(from.line, from.column, to.line, to.column)

    func select(from_line: int, from_col: int, to_line: int, to_col: int) -> void:
        if to_line > last_line(): # If we try to select pass the last line, select till the last char
            to_line = last_line()
            to_col = INF_COL

        code_editor.select(from_line, from_col, to_line, to_col)

    func delete_selection() -> void:
        code_editor.delete_selection()

    func selected_text() -> String:
        return code_editor.get_selected_text()

    func selection() -> TextRange:
        var from := Position.new(code_editor.get_selection_from_line(), code_editor.get_selection_from_column())
        var to := Position.new(code_editor.get_selection_to_line(), code_editor.get_selection_to_column())
        return TextRange.new(from, to)

    func replace_selection(text: String) -> void:
        var col := curr_column()
        begin_complex_operation()
        delete_selection()
        insert_text(text)
        end_complex_operation()
        set_curr_column(col)

    func toggle_folding(line_or_above: int) -> void:
        if code_editor.is_line_folded(line_or_above):
            code_editor.unfold_line(line_or_above)
        else:
            while line_or_above >= 0:
                if code_editor.can_fold_line(line_or_above):
                    code_editor.fold_line(line_or_above)
                    break
                line_or_above -= 1

    func fold_all() -> void:
        code_editor.fold_all_lines()

    func unfold_all() -> void:
        code_editor.unfold_all_lines()

    func insert_text(text: String) -> void:
        code_editor.insert_text_at_caret(text)

    func offset_pos(pos: Position, offset: int) -> Position:
        var count : int = abs(offset) + 1
        for p in chars(pos.line, pos.column, offset > 0):
            count -= 1
            if count == 0:
                return p
        return null

    func undo() -> void:
        code_editor.undo()

    func redo() -> void:
        code_editor.redo()

    func indent() -> void:
        code_editor.indent_lines()

    func unindent() -> void:
        code_editor.unindent_lines()

    func simulate_press_key(key: InputEventKey):
        for pressed in [true, false]:
            var key2 := key.duplicate()
            key2.pressed = pressed
            Input.parse_input_event(key2)

    func simulate_press(keycode: Key, unicode: int=0, ctrl=false, alt=false, shift=false, meta=false) -> void:
        var k = InputEventKey.new()
        if ctrl:
            k.ctrl_pressed = true
        if shift:
            k.shift_pressed = true
        if alt:
            k.alt_pressed = true
        if meta:
            k.meta_pressed = true
        k.keycode = keycode
        k.key_label = keycode
        k.unicode = unicode
        simulate_press_key(k)

    func begin_complex_operation() -> void:
        complex_ops += 1
        if complex_ops == 1:
            if DEBUGGING:
                print("Complex operation begins")
            code_editor.begin_complex_operation()

    func end_complex_operation() -> void:
        complex_ops -= 1
        if complex_ops == 0:
            if DEBUGGING:
                print("Complex operation ends")
            code_editor.end_complex_operation()

    ## Return the index of the first non whtie space character in string
    func find_first_non_white_space_character(line: int) -> int:
        var s := line_text(line)
        return len(s) - len(s.lstrip(" \t\r\n"))

    ## Return the next (or previous) char from current position and update current position according. Return "" if not more char available
    func chars(line: int, col: int, forward: bool = true, one_line: bool = false) -> CharIterator:
        return CharIterator.new(self, line, col, forward, one_line)

    func find_forward(line: int, col: int, condition: Callable, one_line: bool = false) -> CharPos:
        for p in chars(line, col, true, one_line):
            if condition.call(p):
                return p
        return null

    func find_backforward(line: int, col: int, condition: Callable, one_line: bool = false) -> CharPos:
        for p in chars(line, col, false, one_line):
            if condition.call(p):
                return p
        return null

    func get_word_at_pos(line: int, col: int) -> TextRange:
        var end := find_forward(line, col, func(p): return p.char not in ALPHANUMERIC, true);
        var start := find_backforward(line, col, func(p): return p.char not in ALPHANUMERIC, true);
        return TextRange.new(start.right(), end)

    func search(text: String, line: int, col: int, match_case: bool, whole_word: bool, forward: bool) -> Position:
        var flags : int = 0
        if match_case: flags |= TextEdit.SEARCH_MATCH_CASE
        if whole_word: flags |= TextEdit.SEARCH_WHOLE_WORDS
        if not forward: flags |= TextEdit.SEARCH_BACKWARDS
        var result = code_editor.search(text, flags, line, col)
        if result.x < 0 or result. y < 0:
            return null

        code_editor.set_search_text(text)
        return Position.new(result.y, result.x)

    func has_focus() -> bool:
        return code_editor.has_focus()


class CommandDispatcher:
    var key_map : Array[Dictionary]

    func _init(km: Array[Dictionary]):
        self.key_map = km

    func dispatch(key: InputEventKey, vim: Vim, ed: EditorAdaptor) -> bool:
        var key_code := key.as_text_keycode()
        var input_state := vim.current.input_state

        vim.macro_manager.push_key(key)

        if key_code == "Escape":
            input_state.clear()
            vim.macro_manager.on_command_processed({}, vim.current.insert_mode)  # From insert mode to normal mode, this marks the end of an edit command
            vim.current.enter_normal_mode()
            return false # Let godot get the Esc as well to dispose code completion pops, etc

        if vim.current.insert_mode: # We are in insert mode
            return false # Let Godot CodeEdit handle it

        if key_code not in ["Shift", "Ctrl", "Alt", "Escape"]: # Don't add these to input buffer
            # Handle digits
            if key_code.is_valid_int() and input_state.buffer.is_empty():
                input_state.push_repeat_digit(key_code)
                if input_state.get_repeat() > 0: # No more handding if it is only repeat digit
                    return true

            # Save key to buffer
            input_state.push_key(key)

            # Match the command
            var context = Context.VISUAL if vim.current.visual_mode else Context.NORMAL
            var result = match_commands(context, vim.current.input_state, ed, vim)
            if not result.full.is_empty():
                var command = result.full[0]
                var change_num := vim.current.text_change_number
                if process_command(command, ed, vim):
                    input_state.clear()
                    if vim.current.normal_mode:
                        vim.macro_manager.on_command_processed(command, vim.current.text_change_number > change_num)  # Notify macro manager about the finished command
            elif result.partial.is_empty():
                input_state.clear()

        return true # We handled the input

    func match_commands(context: Context, input_state: InputState, ed: EditorAdaptor, vim: Vim) -> CommandMatchResult:
        # Partial matches are not applied. They inform the key handler
        # that the current key sequence is a subsequence of a valid key
        # sequence, so that the key buffer is not cleared.
        var result := CommandMatchResult.new()
        var pressed := input_state.key_codes()

        for command in key_map:
            if not is_command_available(command, context, ed, vim):
                continue

            var mapped : Array = command.keys
            if mapped[-1] == "{char}":
                if pressed.slice(0, -1) == mapped.slice(0, -1) and len(pressed) == len(mapped):
                    result.full.append(command)
                elif mapped.slice(0, len(pressed)-1) == pressed.slice(0, -1):
                    result.partial.append(command)
                else:
                    continue
            else:
                if pressed == mapped:
                    result.full.append(command)
                elif mapped.slice(0, len(pressed)) == pressed:
                    result.partial.append(command)
                else:
                    continue

        return result

    func is_command_available(command: Dictionary, context: Context, ed: EditorAdaptor, vim: Vim) -> bool:
            if command.get("context") not in [null, context]:
                return false

            var when : String = command.get("when", '')
            if when and not Callable(Command, when).call(ed, vim):
                return false

            var when_not: String = command.get("when_not", '')
            if when_not and Callable(Command, when_not).call(ed, vim):
                return false

            return true

    func process_command(command: Dictionary, ed: EditorAdaptor, vim: Vim) -> bool:
        var vim_session := vim.current
        var input_state := vim_session.input_state
        var start := Position.new(ed.curr_line(), ed.curr_column())

        # If there is an operator pending, then we do need a motion or operator (for linewise operation)
        if not input_state.operator.is_empty() and (command.type != MOTION and command.type != OPERATOR):
            return false

        if command.type == ACTION:
            var action_args = command.get("action_args", {})
            if command.keys[-1] == "{char}":
                action_args.selected_character = char(input_state.buffer.back().unicode)
            process_action(command.action, action_args, ed, vim)
            return true
        elif command.type == MOTION or command.type == OPERATOR_MOTION:
            var motion_args = command.get("motion_args", {})

            if command.type == OPERATOR_MOTION:
                var operator_args = command.get("operator_args", {})
                input_state.operator = command.operator
                input_state.operator_args = operator_args

            if command.keys[-1] == "{char}":
                motion_args.selected_character = char(input_state.buffer.back().unicode)

            var new_pos = process_motion(command.motion, motion_args, ed, vim)
            if new_pos == null:
                return true

            if vim_session.visual_mode:  # Visual mode
                start = vim_session.visual_start_pos
                if new_pos is TextRange:
                    start = new_pos.from # In some cases (text object), we need to override the start position
                    new_pos = new_pos.to
                ed.jump_to(new_pos.line, new_pos.column)
                if start.compares_to(new_pos) > 0: # swap
                    start = new_pos
                    new_pos = vim_session.visual_start_pos
                if vim_session.visual_line:
                    ed.select(start.line, 0, new_pos.line + 1, 0)
                else:
                    ed.select_by_pos2(start, new_pos.right())
            elif input_state.operator.is_empty():  # Normal mode motion only
                ed.jump_to(new_pos.line, new_pos.column)
            else:  # Normal mode operator motion
                if new_pos is TextRange:
                    start = new_pos.from # In some cases (text object), we need to override the start position
                    new_pos = new_pos.to
                var inclusive : bool = motion_args.get("inclusive", false)
                ed.select_by_pos2(start, new_pos.right() if inclusive else new_pos)
                process_operator(input_state.operator, input_state.operator_args, ed, vim)
            return true
        elif command.type == OPERATOR:
            var operator_args = command.get("operator_args", {})
            if vim.current.visual_mode:
                operator_args.line_wise = vim.current.visual_line
                process_operator(command.operator, operator_args, ed, vim)
                vim.current.enter_normal_mode()
                return true
            elif input_state.operator.is_empty(): # We are not fully done yet, need to wait for the motion
                input_state.operator = command.operator
                input_state.operator_args = operator_args
                input_state.buffer.clear()
                return false
            else:
                if input_state.operator == command.operator: # Line wise operation
                    operator_args.line_wise = true
                    var new_pos : Position = process_motion("expand_to_line", {}, ed, vim)
                    if new_pos.compares_to(start) > 0:
                        ed.select(start.line, 0, new_pos.line + 1, 0)
                    else:
                        ed.select(new_pos.line, 0, start.line + 1, 0)
                    process_operator(command.operator, operator_args, ed, vim)
                return true
        
        return false

    func process_action(action: String, action_args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        if DEBUGGING:
            print("  Action: %s %s" % [action, action_args])

        action_args.repeat = max(1, vim.current.input_state.get_repeat())
        Callable(Command, action).call(action_args, ed, vim)

        if vim.current.visual_mode and action != "enter_visual_mode":
            vim.current.enter_normal_mode()

    func process_operator(operator: String, operator_args: Dictionary, ed: EditorAdaptor, vim: Vim) -> void:
        if DEBUGGING:
            print("  Operator %s %s on %s" % [operator, operator_args, ed.selection()])

        # Perform operation
        Callable(Command, operator).call(operator_args, ed, vim)


    func process_motion(motion: String, motion_args: Dictionary, ed: EditorAdaptor, vim: Vim) -> Variant:
        # Get current position
        var cur := Position.new(ed.curr_line(), ed.curr_column())

        # Prepare motion args
        var user_repeat = vim.current.input_state.get_repeat()
        if user_repeat > 0:
            motion_args.repeat = user_repeat
            motion_args.repeat_is_explicit = true
        else:
            motion_args.repeat = 1
            motion_args.repeat_is_explicit = false

        # Calculate new position
        var result = Callable(Command, motion).call(cur, motion_args, ed, vim)
        if result is Position:
            var new_pos : Position = result
            if new_pos.column == INF_COL: # INF_COL means the last column
                new_pos.column = ed.last_column(new_pos.line)

            if motion_args.get('to_jump_list', false):
                vim.current.jump_list.add(cur, new_pos)

        # Save last motion
        vim.current.last_motion = motion

        if DEBUGGING:
            print("  Motion: %s %s to %s" % [motion, motion_args, result])

        return result

         GST2   �  (     ����               �(       �_  RIFF�_  WEBPVP8L�_  /����(h�FJZ��w/��� ��=�w��-�[a0����U�K�5I�G8�g��k�ɩ��������Nv��x��۶m۶=[�iW}_���N�m�j���O�ʿ�Kߠ��I�Q��ض�����A76���g)7۶eO�.�W�<�����>�;�l %��ï'#�m#Q����O�-�v�ֶm��#�
�
�~h��xD��J] � �Ur�H�$���,�2U�;Γ�`l$I�$ɲ�#a��L���@m�1��fg7��ll��6�mǶ��Q�ڎU�A�Ա��g>��$Yn��b���"���߶M�m�:�˸k�A�����3��H���x6j�Uu�Zݝ�(A�mW���G�U�#Y�0�A@2�V�� ٶ�XU�q0c�9+<
Զo��M9�m۶���;�m�k۶m�cU���Ip�H�$Ezgr�z6"���m�T��_˺������N�$�m�4P���P,�58 v�P�o�|sf}W�m�NZ����t.E�X0D�`�OFDP�8�mm*�~�j�H!eH�P����K�l�n�E�ub$��?���E*�i=�Z����'� N8]�l9��6^ُ�<6�,{<e�=��Wj��{��[ �ٞ����Q���'-��WT�����䙻
�����?!Th�i᧖�1(�G�,{�!��V����y+'Ȏ��r�D; <�5���ye�Bا�T���a<ss���+� N���Yu�����hv8�.J���JZv=��!����J?�h��,��ݣ���N�q*d���ǹ�2!l�]K�8|�r!��B�J��o��[���rh�}xke2�h��e �~;��P�A�0�?�=��I>4��_d����L�#�7/C�TL*�G' |\���MɌf3KK~x�i_<<8��YNWp*�@�xS�C�PU����L�E[��< /}� !C�Y��RI�~D�UL��8n	���!�w��%Ӳ�X�،��a��b�?F�	o����O��� 2��jJ=�!t��	M�����.�1��'�Q2�7ϗL	ũʫG�!t�d���F��:���f)�'�=��9!���Y���DW�b��,3�GE��z>R�K�/����'�$A�#����s��X3j:�s�]淪�84��������R���|5��df�=.a&�4e?���+�3�S����0�������8�i�i(����//�N*-��}�$��SKf?��Ș�{m6�f��̈́�ۛ�|�RG�r�9���ʊ��=�@����1J���wj����nVOc�
�C��׆�� 2H?�&|Ȑ'^�Y����e�5Z1#�sPZf�(�>hT({�h53�ߺ��'�-#3�"����bF?j��v�o�91�]ax����筌2�?nW���G�/��w�x��B��K�P�!|���o>tO�t? H���@E�8��׭���C����  ��~j����B��I���F�7q���G�RQY�Q(Pҏ`�4��Z��cG A1�O-%�/;4�|G�=w���y����{�r�%�4�1h������噻�!@���=���B\v�́pP�
��1(.(J)�/;��C�8�fx��Q��DI|���Q��F1�!@��@�1�Y(N��h�\<ȧ	��˄
p� �3�O��_�H��[C�hGh�Q�S��A�A��ӗIp� `�f�vu������H$~P��A��aVo�}|�~U���[v~D:KK�G�oI �y�}V�=
e���j����Q����BQ���վ�`��A
�(��Y<��a�g ��44�oC���|3�7h�a@Pk�<r{�wl���3��P,��;��M��㐽'��M���S��OM�O�풧��il秦��r������oF�e)=Î>r���U�:��@�l9�;��N�T(xu�� ��I؏�P��6Q�Tcpn��v؞�r�Y#���aoF8xw��xY����\�Q�����k�a��)���\	��3��=<������)�̈�x6kt���u���Y�Y����->1 @ι�t f%^�+;z�hh�yQ���kfuY}p�`K��:%��Wϝx>_��;��s'�'��	�G{���|���s'n��d<ـsg�W\H��O�|���[�Û�O�S�e?�S �=sp�yIN��ì(x��gN���7)u](���)*xu]&x0���3�ެn-�Yv���q��0#��V�xek�V�/��|��q�(|�_�ΜQ���d���奡�U
��E儴e?�y���$P�¹3�Έ��L�����I����p��W|5��hf`	^T-�|��ɞ��������)M4�G�	6�ʎB�Bp����@�1V����r/<��1W�p��v���wj�����/�FA�אޔ	q�%Ѧ@���2ii�q�t�=/���9�:%����i�_^�%��_&����!o1^O
I�Qf䯂4�"�/�ۥ5��!x��#��D+ a:�B���sP��y��f�4Fk�#HL��aJI�"h-�/�xk��NM��5C�RpP6`�j�P�5
A�S[��/�i���A3�ޯ�I���d��������޲�K����!L+e�*+�����^�+r1��VF+Pn��艼4��1W�~��vAm��߆e?�o?4C��mI�ab��b��8|i{�\���bd@إlx^Η�C���A�C༘ ��m�|���솞G �Ԃ,�v�A���'$1��)ԥWwb87�p�)Yȃ�:eGm�a#�[�cq�Ҡ2h��xGQ:m\[����G-�vs�!��3���;�&F��Axڭ{��y?�.I0>�^k�a�)�����s��Ϙ�k�`������g��ۼm@:���u��OB���k�d9�x�|(Iv�v�W�m*/w9�ܭ� ����s1ۣ!���}�cv~j�	 �BWj�4P���;$h*��'/�Ӡ���Lٳʊ����J�ʢ����]�?�lZ:*{Ԥ�����Y���-{���&�q�O=���F��������me�ʆ����2|E����z��eOET���������y�1*��n���%S.�,e�K8���y�J0������֡HZޯ���M�����W�7����SȣHP,�8��14%�š��"�������x�ۻ�X��;?Ҩ= ��P*m$-�W�Ë��4y�筬�sN�)_��*ȸb�<��j�}�m��]�41e��A��[���d��k���������K��ye@]������Ð����6�t`34m�`�&uB� �^�R^3����+��� L:��sCZ�����登��N_L��r�U�S[����·ͤQVL��zE]��z"qN�H���@´��bf��8��gJ�v�aI[2��Z�[:��|�}������=Y��!�X3�������~��HC��k�#�.Kt�*��&�r�Iy}�/md���|�ޛ��@B�`�YǶ�����ᭁ��0�`��ߟjmmFPQu��z�]((Y����e?d��A��!tR˨���a ځG���()VB���U\(�����p�)����F��Z�ZS�!\��Ԛ�-m�B;2���_P*-7��>�%� jB��5V~�fY$���&��I=ڜ����GT����+!\u�6�m���H?��:��� P�������'�����p�S���H,�x��jbS!\�`|ۀ��˫�T]��ڃ<�o?��7�@Y8����T�� _Ҡ�.�fZ�A^0��X�!܀��m���=/3m��WSȺ �f�����i�(����geI/
�����*7!�4���,��jw�m�?e&�����y+��� :�*ƚu]�~Z�F��nl&���� �Vdvu<��&U@g�8	�|]��-7#x5�f h�~��p;�wH�� �A'�8����R��_�ސ�em�Z;TxG@��o��(�vC�%�N� ���7%��W%�xW�E�*Q�A�-�W���.�ʼ+ G�\i�]�3M�C"E��{��$���Y#Ⱥ#P!=��A��J{K�
�#��`�� ���G����I��ہB�����Ą�ޤDA	Ԯ{NBy�#��/|5E���4T"	_"ڔ[q�N5u]�@C�R?�ʎ�2H u]Z�666��w@\6@F&��Kb�ɦ��gd���M��%*������4�뒋5�V�� f��6��uy��̺��l��>��'	~��s��RM]�WŮ�k�_k������9��/�WL]�7���F^}��9_�{�@CC��ڣmSQ	��.�}���홻
:s�/��U�/|����gn��R ~�/:��LN�ɯs���Zq�)[R���WP���IiT�qա_�%)����G�r�8_�osȾ�P��'Y�C���}V��lQ��5'������u�4$����W�x^�2u]>/-�J)����&QTHS��i�)�X3ȸڨK����=r�q�Զ�Ȳۮ�+(���E�P�廐`�([}�)�1��u����(K��W�ET!M]���ݞ��ܶ��3���ߟj�����㾯��ܢ�߁�� fN�߿?�6u]z�Lh��P�U�R�a��PץO�r�!HL]�n�R�\��~�Q3Vs�է��ߤ�T�L��֖LkN5�f�e��.�:����^�����8�p�(����p��l����=�냇�>ɔ�>������m��s���D�b^�;+y<�Ku�O1V��u���ʖ��j���JC�K8*k�Τ)~����pT��>P����w�z�'{w J�/��۳�B7W��G�EoT�w��rC�V|޸����h��iQ�|���(-��Q�����4+/�6��w�@u��Ӵ����*�_�#�#W�yp3(+'e��[��q)�r��rf�Oӻ\����",s�2bw��s��h��]�5˗^i��}S�p���e��Ȇ�\F�g�"/��.ze%+Ú��D�����+qF�(s����X8�i��TU��ᇣ@xG���q#��!Q�5��p/���-��2�*���F�ȂQ3��F��»,��g��ij6����/p�{V�Q:�9(��#)|�TsY?mъֿ>JQ�R x����t�������,A�F�`�L�k��5(;��P��2�JO��P �1�9h�7*pk�Tr��$'����kw s�(d %�=�����5�-{5� ��(1Ik���G�M�=I�I7[E��bq�0�F�D�J�ȓq;�
i!]�>�I��\��ey��n%2�W���Sź�|�H!� !BUa�O[�fdfpsTQ���
�M�H(n �"�D�2��p;e���%d(B�C��H�X��]D���}��Ĕ8��ZuO�:�-�'� +�4���%�!�#��y�P���Fi1(�Y��F��	�����l�Y���)�h�xPQ���q{+�WVVZGW�2B�'u��0Q���$�*�kE!z�R]�~"�_�%Ŭ���a�I�H�H���'���tFm*��S���b�J��CU�f�mtQ �g�{I�>&� P��M��0<Dr(�������UJ���=6���������ւ�iL��d�J~�i�kZ���Dv���@ FQk��Lr)��$��|��2�[�M@n$u$���\���=���K|��X����Z���#;���-@��=>?f!l�n�2��%L�!��:�W<N� T�S��;#�������	��+@���\�% y��V��H?���!�[cf���%RG���A]�#l�_Ϟ���	w���_Swz/���Xo�Q��.Ú�{V3��ԑ<�FP-ޣ��ݑ��Nd�q���Ti �b�L��4�qڲ���H��'}��>� �BQ푃��ڟ���:��k�E��<��TsQ ,�'�ґ�Tg�'Wq�7����Wu~G�5��X��,���l��:}�;�����#O$x�P��u����h�!܋5�d\��ecp}`�@r�I�}	y�(V�����J��-���H�W'�X=���?	ڢM��{�C��n6u|�P�I��R�����a�#�����o}�7�S��И	���N2���P�#�x��yG��w�K��^�s��?hw��Iϒ,�#�Λ� DG"���͍��5ϛ���Ñ{^S���A�F�ad.�R�z��p�Ϧ�('PT�^rq>h|D������/�e<�S|G���dP����9�1x�D�*I1�˵e&�)^$P<K2h
�r�9i`Q�5$�;IڤX[����Vō$���E.:&��#Q\C& �-��F���X��"���A��&������ɽd����Kƶ��v H|��^r�{��!H� Z�DW H���>Qi�Bp\KR��5m��=?SFH"Xa�#>䷅�H���^�-����ֻI���u#D4�p�<C�x��o~�����x�D�
	�\"*+y��Da(L���n(~#p&��C"��#�@�E��}���ѝ28��h&`��J6�x/����@N�_�fhs@=�^G� �j�%sU*% ��>(�>㽴���Q���L�+�u#Dt���+�	 8��Tb1W����b A [�c"*]�Z���u��6G�"��%�mB�%��~�9�|d�g�K�5����V{��;��?:Q!���]:$��:����]�i�7͆ўc�~H��L�>,mB`����j�0U��H��	�z�qADŁ1LU �$gC�u~'#F��lr��=d��������������3���^��іѕᢜ�j�PV;�ˉ�ѹ$���	p�H0d{!�Q)1����e����(��-���Ѧg�i3��a��5#'D�9�2�A�"���L@(&w;"�MDtf��z�OHn> ��aKD%E����U ~����ڋ�ofZ�V�s�MʊÐ�IN� CC��ǘ(�"Z�Y��
�	���M�����j�6�%oB�#�x��
���*h}���с����H�& �en[�f�˨��"��� �%���Dj�"�c��F�e)S�HT+�����mODT��h��K�-r	ղ��%S�12hVf�h�=E^d�6N�^R��I ��b��ѻ ��<H�L�>7��LD���F�� Eĭ$�;�J �/p�ߑ�j�D��#�r����dpD0�Tr��$��"�WP�<~����d���X5���j�^�l�A��L�mxw�F!�y6nDTz@T�1�&:�	h��M�
�!Ghi�yb��:"j��JCk?�t�w�н�'��8�����DT� ����Q2��!_ $o'o � "_$�
���=\;Fs%��GD-��;F���aH�=��yy�X�����gٷ:Qm7%���\��uCDe���u3��HE�4DTc��)����Q9 �͎m��8�J��R��s��x��ѕ(%��@D����%^����-뾉�D�pK*��W��3"f�z*rAL���7���4��"*U H��������s%��V��Jc�j.#�K��^��ѕ(%�4:��WG�P�:�+qF��F���pT�fS꼷����x�n��(բ�E�+û#.�W�)��Q\ս�]�O�}�i�W���,�w"JD���+��3�v.���5(���A�̇���k�,zBeA�S�����Λ�Q��q|qq�|5��ᨴ;�^Y"*@8���%�Qj�#Qq�ڨ�Ǹ���q�v%����г�|ǈ��ڽC��9�iҌ(y-e	��CB�
��I7�^�ٔ{���7��ѥEU꼉(%�Zv�,�Z��;��pT�d��ݍ}p�e:x:�E4�]����e��"%�j.����9��2�B��;׬���Et�tN6W����r�x�C��R��̆9�$�!�]�j.���Z[��1����w�F��_�쌚�֖Lk����C���hF���O�m:Q���d�,6�x!�D4۞�Qq�}�F7�Y�DD��F���~��e5i:��޸��8W���y�w�i����b��wS(.(x���H�����_{�U��'�&�t���l�o�z_^O�61&kS��=������AcE��OF�&���k�%طH��T�����[F����������u���e���f�<�&N{������܏�t����B��ȶf?�m���j����n��O4�=}���Η�
�	���u]��2 �� l��0s�ܝ�E��q�`�Im�E�+~�����ϸ��L/���ڼ+d�'���1�;y{���^���u]�F`��P���܇����kuU?��R��Rl�-8�pO):1�e3���=��=3;7%�T�,н�;|����ΨXĺ��#0H�A��������ig>M����e�:�������ɬ�?̆ɱvg��w��kϲ���B�na��(.Qו6�T�"/��r�L������I��*��o}���(�}F�ZkKA�S���߶s�������J�~�M�׫�+}�2a�+�n���$�':������l�Y�3����M֠��>wƳ�g���מ�0�d�m���+�]����������.w-Q�{F�l��}:�#/*��+k �ei1Mҭ��k^�A.L]W� R�
$p�R�����X�wO���+w i�2��WF�B����+o i��eO�Or�~
Du]�0H��4���'��Uu]�0H���ƅ0[c$�y܎o���������o�e۷ײ��i"���gj�n��(4���k����%����������������)9��'���uX�~�ڸ.�R��g�}��X�����K�ꔨ�@��D%���(��9����}e��׳�h��G�����]H�y����m��h����O�������_5 ӊ�|���
���I�#v�<~}����YV
D�p���\�>s�û���Q3	3i����G@��lƊ�+�i�0Gg������S^/WDZBO��l�����s_M�@����o������N��%�T��^!��^���=GS:���
Buz�y�����[V�T�f��$�����S?�2(�n.�D4��茚U?��=�1�IrϦt������*֬ӆ�)@�?�f�����o��;��s������<�+}�����`K5�x�>�+�t�n�_����/�9?����̺ɶ'�3��]�=��]���a���
DȨr{ly�df��,��ѵ���ΐmOf��d �@�A�,��AJ�[��"&�����l{�� 
 ��j.�����AL�#�3��j.� o ��W
i�����)6G�B��b��@� Dv�� ZFWl��'&�ck_ ���Y�!**p� �y�̤"�D�f�]ZTm/��
�Z/"��%����H��O�g����� o��C*Ԑ���Du�{!�����JE�� g���0���:�@���y�tF� �����4�o���K��O��}�Y�#dި�Ʋ�?=���i�Q).(x���š.-΀�K�l5�i�i)K KY���gT�Ĉ��=�?d�\0y6% t��(�i_P����������Xԓ�nS ̆��w���������zO�b)Ɗ��3B���3�'���i�u��D����OǽT�0��;@l�UC��d��\���w���	R�Q�g���x�O��o~!��*����W�ɠ�D@������E%�,��~G蕡2�H�;���;e@DQ�_������f-�`U�����#]c��;�L3I�k.� k�U��������)�zR��ah� ̓�ȋ�˫���p�tP����D��n��'sx��k��:��4kQ ���sx�rH5L�Y�=\f�x=qy�ߺcm�C@��N�ʻ�J���8�8����-.�*������V�0���;$Úq�3���F�B�u�/  ;���e��$�Ի�Dz�Q���S�Ң�4����]�J�Bo�xʖ��_(�J�n�V.e��.�ʞe�1i���9��w���7Ú���kz�6���Q����_&�dXs~�k�缮)�wL���i8*�v�R�la��F?��:����l�l�1T���G��m���������g���;�5��ߨY���K���b��k/�k�gY���6ts�o��c��J�F�uU��f<�5�{ZCTC2��y�CϢ�7�a{���;Cr��^�؇И[�����ך[R�������Kz�����b�@��a�>>�l^�tNTe�^6^]��"Ņ���+���޼�"\:$�;ϦL���{r�5����xX�sb�W_�[7�L�k��:������i��5 P��f
�zw�z��@�ț��t�����F��:�^�Iً�(���G�r{"L05�����Q�=����T��r���TA�r�Y�훁��EL�Oܱ���J0� �ih\]�ހ�!l���ܷ2Ĵq�QD�1��o{n��ܵP�@�W'1u�j|�y-��E���ź��l�-B�j.��'��~��!x)p�S�Z�/֍`�yټ�BX�;�?Qa냯�3�(����MD��Ȍa��l�D89���>ۗP@f������aA�CD��"2� ��� 2�f���':�\����T"V��� �;Fb����%�l�Z�3j��b�M��I�g�zxyo�at$F��d�Sqg�v_��etu���q,���3�1�+}����"h_��������w}��j'�/��-�4b�o����;p6?$�A�"�'S�e���±"J��G�O��?Z�W׬�_G�bn����2?�Dނw�j."����D���y{�=���ZBO�$T2Je�J�͇�ʇ�p2#@h+�B�dD��1�A8pD��\�쩸=V�}}�p�n��9�?�t-�v/A�����[_j��C����@���^��<��g�=�����[���r����eOc%J���C��=��u#�cx�(�kVc*j*ݾ�8���Yݷ>����>[=�;e~8�J^T�EI��D�J�g�V���>��E���=���[��U�}Q��՘�= 2j1_[�b�λ�?��b���\�+ݾ�k���[��q1�d�y�s	��n��ϥ����++NFe���x�}�<ܝK��ǳI��_��N���9���]�w_�m�n�4����<s{���=x'+"�B5ڌgn�X
��p욂���4٨b9��Mה�Rl�fb��I���m��ȍK��|�|�|�!�z���:+V8��.#k�H���Iܗ���L]��Q}p5Q�![�����=oet�Z�cTyJ��.�m�+�Y
į$��������)l�f��W�4�H꺌/-��(6^G�m8�����((JP�]E�.TIS�����CP��!eG���r�Y�?>��M߇��d\Apy�k���6u]��B�=�����/�eٳ�	H]����0�ܫ����KXB��.��`����k���܏<u]�T^�D���nͮ6��u9Vy��2��jN3f��u9Zy)�:+.\5�i��6�0G��.�+�Ml�WSeG��_Z�_z���u9by���k��W���]�4��S���m������^AE��=s�S�娥m(1^+P`���-O]��[A�6.^)p���m36���.G..�r�Ͳ�z��:�}�=w��4�癛W���Q�.���De�/��|�TZB�7���r��622��;�B`�YG������ڭ�{@�ׇ���3����7Z����

6K���Um��+���xRP���$��flJ���]B��I(V2%�G���_J�6_O��^ٯ��j��JF�d|�xu]�X
y˦l�E��t=��<��u�{ٌ�-z��*[yW�ȞD���S2^]�?���(SZ��kA������G���_�l\liJ�`�|{�/U]e����b^]�?=�ַ46� d?\�k@��ATT��|���O��6��(��]�G}_��4�0�J�S�ҸX��b��j�}^�;�R2%Ә�yu]N!ҭ6��ekO��~Ao���Q��W�/輺.��L����eS6��:�2H�1�J-��S����Ք�r^]�Sɐn�9�(K���-أz����a�ޯ�.����+^_GC��z��B��ٴ�U]������yu]����Jh"T��s����P�F%
^]��jŊ  z�m��������X��oK����˹E���S�M���p|^���~; �5�����]zx�%��&6 B�I[����+uOwe
��W�Og �M�t��l����\�y�<�/$����x��W��T����+K_�d��$NW�K�#� ���H�s�{�����f�(�q�	�Y=��[P�ك�hzl{4���BT�嬣��8q���A��e��,�{(8��>�-m�] � ����(!��r���d�G({�(#]�l����E��V��\	� �����u�A�p�S��D�Nm��ר v� ���>;?5)Hُ�a	IT�e��Ǟ��w�w��P�4�/m"������!��s?�� B{���~dQ]��T��=;�.}&��l�[���J�ڇp��Y�l6�+�����~$v~$Q]�i%��ф�ymϫ쇿^�S��-ʖо��g����bN7q�D���%p?���������xa{^ɲ�~ؠ������hm��(��O��?�V�B��_��A (�pq%|�]�;��/,������F��]��Z�I�*���W*?�Wh�kt>ɐl�}�ϸ�v��.�m{^��zI�Ȗ�e��į��U��S�G���v�78�8:��Wخ�Y�t�^��**( 4�����y!��2����/���d����ĆH 6�[$ ��5�]���A�9�;�x���-�����Z��6��-��;��.$!� ed(�!��|��u��=��)���Xa�X��F�GH�	hC����M�AY��ze��i��Ds�"�\y ��S�W ���8*��Û�J6Oi��87���������!(Bc��Ѿ���/Eu].G�e#[66��+ܔ��R���2��ؐ�!���hb�N@�z�>������28��v�	G �IN)M�͐�S,����({��:�.l�mS�1�}��c�6ؠx����ik�e���y�J�Tc����E�[v�l ���h!�wU�y%jp�̒G�����Q]�K���nJ�&��2��C4��6BB SH�
�24@���S��
24JT�P���~���ڞ�;�.���[�R������E���Tܔ��Du].j�=3��%����)��#��6�5sD3ߦ�f�h�1Ȩ� ��q��&�0TgP��!@�LI��䉸$�%	RoqL}��@�dA�|� D&A�[c!	@�%$A~Ib� w%H��A?8@��\q	Bt��Ϻ�s� x:2~�����_56��F��R�d�wn�cIL�sf�����֕0sP���I�E��=nM��I��6�.����;<1#1�����g]gZO-K,�|�������
�; �"zܘ���~��� q��r�[�ߵ�'���g]���9������YkG�3gn�*��^js|�"\���᳭3K�~� �@�Yl<H���x ���VlO�fl���֤�Y���[k�Zk��ojsW=�'+&# �}A�a?q7�2�c^�l?�/���5~l��ZxRχ�s%�[;�p�#%�{�!�k1v� �+��a.�����k�d��gջ�YWǟu����u�����?�J|1���Q!J�;�ߚnr�r�2&f�h"JT0Ú����X���S6 v���P5(c`�y�:�\�
��� �ы�G�jxY~[;�*��ӡJ8u�K�.�������,���4���Py������t���Ы���M׻�W)l���m�T���cr��H#	"-� ���oo��7W��7�}H�?���ğ�9�E�sz�`ѷi0���V6=�O�MάO�h>0����$����f�p��w欺�/��~�h{|�T��.ɥ��bxn�t��P�Bw�Y1�'!���YP`ȨDW�X9)�#�҆ጋ ���x>�b2���(��PO��E_-K����n�{z�"�<��ѝS'�\������J���%�h>T����\�><�7,B�!������>� �o)+'cG�n����n�-�Fr�0Cm������i�~q�`�WO*����y˞��[%q��Z8�+���]��g�>�R!���7G6WO4����h��H������؜U���"��L��M������ġ' ޔN��m���ϼEOa�}}.BI�;{D�Ǥ��W�����'P&�K��ԝ��H�>3�����/�پ�Jiz܊�
�A� ��SuN���1�$��9���ް��2a_<�%����w�\#�}\5�����_��f&Ԡ"���hJ�Y�e����6|Z��� |c�\((�JS�*/FI��*���6�9#��J�W `�j�߁VL�\��xQ��������zܘ�W#wV�!\,����"�yv%u���BX`�7�W�����a�ҙ�Е"��zRY�<1��d��ѿ�z_��;�5��x�W�!
<'��_OV6�:�D,m��Q��*�Z"f��S��SoJ.B.�
?��\1��5v�l��И������/Z���2z�����[�lB�g^��\�\��?37]��_�s'���n����a@�*a��s��*}t��8i�(R�&[�V48.�6f^��\�\>�K37]/*o�sgn���5 �!$>��|����ᇝ�C� �R�*V1��15��q8���"�2�+��sO�/�s篏�����_��D�}H|:*Y�_��+�@}�Z2�l�D��3�+��E�e$W�_w=:~�tu2��	x����
�/�e,��=�JS��2c삭r���3Ϫ��Eȥ��Y�n��v�?w��l�O��qh� ?��3��ά\���O�[�1VA�j�`���;rri$���nT������x :F $���L#�XY3���(��c��ݢգ�x��?���\�\I���E7..���?M��-��XБ�9+S���bL�Q�7������W�"d3o9��^������u��WD!�&��C��ɍ�g�7y� ����p�t��5��������H�k�]�����}��<p�GK��~\+��iJ��cL��Ek�������{*_Kf�����a����-�gaHD1�_�8����H��'է	��� ��`�+Z�<!^��.�=���50E'{����O�|� �adDQ����t�V�V_&�jj(�|�����ѺaA���]�{rK�k�dy�):���6��b87�؏�w-�^FI�h�_��՘�� �{�w��n�ݒ�Z=G�7�s�+o�}�$ᢘ����\�U^&���$�#��($�F���r�������":�\�Ͻ,�}��x WX�!H/e�f�.e]iB'��1
	A&<!Z?������_���4��vwW�s��_?|���:��#DLVKi�AB�̩��S����ʵ�K2_�����Μ�m�����n���'��1ȂgD�S�߁�ڕ�K2_�;������]�맏	&E�$�@t56���<����͍K�s2_�V������_�;$����8k��.�0�/��S��_͍��S2_��6���!���{� �cݚQ�	�_�A8�2�^�q�ј
��ˢ��q������sq��7���q�?7�/����aYf�Bȳ���r�ը�y�:{s,�ש�Cj�d�?�����?q�fwk9� %���ݧ6fĵ�[gn��|]�R�![�tT��57���n-Cc�$�%�ܟώ>l�����J�-�Փ�"�ù��M�v�ҭ�ߍe�R�NT��wN���u��-Xԓ���"��J��="�Ң�
�
��m�%�Y^x�P�hKF�:~�w��/��ݳk4�7�+�.B=��Yv��>H��+��
;����P>m�ω[';G﷉|=�=�9���\�Ep�I���e <���2�oU�7�*�(O�!��7#^�j�~�&����2{����"����`�'�� #lE�:����f��'���9q������M"_/�/��]C�����Z� x��F���N8g@)'��8��`2,�1��A�d�A��0������0�݄0�,�q�'\w�P>��}f[oN|:s{�Ws��׫�G���}��EpIX2�� x�M�Qp�h�"����l'�,�N�� ǭnB��`s·c9��w�6(m� _Du��hs�����O�k׻���t�#K �	��� 5�$(���������� �(p�2܄a�
�fy�.(m�_��w�ģ�7G�Z�D�>��^�^�>�疿�u�)����d�|q`9(8� >+�Mx,�m� ��[���D��ߠt� *�7���q���ɞ�*���|i�&����?78.t�	�����qk��J���ZX���� a�N�, @H\
Q~`�PИ�t�T?��^&�5�+��v=���ϭOt��CY��.��n+�&��tf��4 �(������9�4 �iq�:�-�t�)0N"i�;M�R �`H�7݇�52� ����E;�����ٮ�<���\��{T{�[?��Ɔo�B�r)���Zƪq�E(�~�'�� 2e�u��㍝+�g��7�}Hi��Q�4|)�td�����/�ԓJ�Fr�٫u
�C�����c`�ozNC���2���gvvě+����e�EȦ�T��]�O��6�d��P9l�$pw��}���Q�+|�		(��i������Y
�� ��
��7���u����p���GGW���04� M��N�?^s��b��͑?B��'��W[{����M=	�W]wNo����z�)��_�Z8��Ȳ֙&������-Y�<���}H�o��V��}�hK�6�<��}����ˡ����-�iB݂p��@�仯��G%{`+^ƴ��-O�]����ˋ̓E�EȦ�T�zn\\��m����3��C�p�I�%�/~ZJ����!�
d�I�E/����N�R�d݇���+��o�S�u5	�����\;ù�W�[j��hu��,�+7.�6�gq!�F�-{�^]���j/��g���:�` ��em����_R�3P:��l�z)�N�ؽ|Vy��ˌ��Z��]͋�[^�K�B����u��f�`w��x}���^��� � d �H4篏��`s�;����K�vk�o�#��sH�m/�v�v�s��ݧ�2�:�ؓ� pw`�.���$��>�Z?��]�|������<�L�e�@�,��ҢjO/Koʗ�|��&�����nBg�I�X1���TR��.B�]?��>��tR7Ϯ\�\[:O�2[��n�ݭ}.%h�l��ݞ�留��:9dA�L�O�����V^�?��� ���v��	�L.B=	sV}�N�JSs�=�$�yv���+MuRq�JS�'%�'��H<���x�i/�wOoV��D	Z69z�U�&�j��A�l�� e��5��beo{En�� � �$�kӑ�+���؟�\Ԗ̆�s!׮\������ó�󕜬�B�3a���^/�ޭO�.B>�������sG�w&�� ����K�'�գ��`���qF�������Z�n�_	�U�3��Q=8���$�fT8���;�؛���\t��
���=�̝��qM��p�B�$� �FRie��$5KZ�CO[[�s����݊I/A��hwg�?w��`�N�#��	͠�;q�l�\+;;�	!bPދP�X9sZ���Mc�6��	kO�'�x	�b�`�������M�m 8}#��F�>0��?���7���|�� n�1�tk�AxX���/Z�'�'9��Z����5����y|���e/A;��hK�?w�~4��N��0("+Q�8"��G�OV?I���AH�&�2�$�2{�K�����f[o�m����0�2�ד�"d����6��s��3~��0<�
_�o�g����
�� +
jYbո����iiIX<�������� ^�6W���	�ܵ�Y� c#*�W2���Kf���I�C�4�Vn�ߴ2o�_2R!�Z�K���� ��l���b�P��m48�(�_�4$ႨJ�r�@���ؽ�ɽ�~H���@GP0qW���#;�F�GT�ʶ�a�`�^��B�wۨ����͗?M�)�,�~ ����؏��^ 6E�`mAG���:�2}�.i.������{1�_��k��@�v��L����sv���&���)Q<YНf�z�23iW'݄���$��޴2ù����ʵ4{g��b<J}m����).���K�x6���O��n�M����]i�m��D1�e��� $���`�_MK=}$�V�uU���ֶ��ǩ�����K��P���%Z8���ߣ�o�[@L��,�Z����.��գBGF�N�a�ܼ����zRy[�ʲ��s���Q [�3����be�������P�����E�_e�T_��j0�T	��T�7v�4�0aW#�@��WH��
��Խ�;7ί���4�)˾�j3��8����]i*�jYb�|�� ��)i���lX^�_]�?�5������e�_e�U޾�n�&���T��ԇ�%�˚�}� ~Nס��8u[�"�X9�e�,���E�����,O{��ӷFn�]I�V�([b��j{.�~����񮽨�}��$�Qy�D�w���E���e�&!Ѥ�U��36&�k�ԕ���Wl�/|u��,:��P���E��-��nQ~�h����ˬu�w�U���6 �P��#�箏�ԓ 3@��WH��FzP{0q��琲#�>���8z��s�d��k�E0"9I ��,���s�?.������� ���J��������3�Iס�8;���E0�a8ՙ&����"����@=���#O�/A����5s�{W�r\�w���>� I*FT&0����d6�"��`n��
:�Զތ5�$@^ڄ�,�q8c��Q�3M	�.<�2xI�Lo�_F����Y�6���Wߦ�M��?�;7샴�%�wR�ruae$W�%$�Bˊ���d�k�	�C�!m��g���9��H{
��>�\#���`h;�C����{Y~s\���_��I��=��T���<~�i$+�'�W�i����/~\;����qE�	������8��4p��w��֌�+|I
 �������{Vys\����oo����B����ͿC��+����>9���.ؐ���`�,��F�Ud��j&�t8"�}nX�Y%�EmK�J37���O�W���@<�K�?�z{����l"A��WȄ�ꋉ�7٪���;�$\�:�q��L�$�)������E02s�%N��틑\�����"���J���Ɓg!3T�@wqz�_�,g�� $����W�[\�k2��xP	��#��^Fj(�YּӶ�L�P�b(߶�'��u��Ǉs��M�,t�d�*�&;i0cf���Ɠ�+�K6�]�zi�1�%'8w�gL�HF@����Eܯ�Y���CF�*�6D=	��]7.n���]"xr����L���+�Jr��$TM�d�II#�6�w�/�DA��g
z�Sw��lU��$�6/��t:�Y�vE#	sW=�./��={�#�w�D�ҁ!�b�DcO��:�$0Z����E0q�~Kz3J�霜��	I��r�5,*�e�5����5��^�b޲�R���h�G�,|�JVz=�JS�:f�|�v��}�����Z��{-\f �~{�plL�։O�!:��Z�D�/���<�ь����`�w����h��G�A��ِ'�(�X�����$�B�� 
$�����D��5 wK~��㖍�'rV� $�z@n���݆�fQ��g��v\��T��jYx�+(��<i��?�\+GvdI� $�ss�"��;�9/18&#�u��ƶޜ�Ua���Ƚk�l�E02m۠Y��������-��/��� �A��$�c2�67����L�<,��5�=�)��N�~���"���I|��i�]�z��̚ԗ��ChK,9���t:"K	�UCU��3r(R���,�pJ�C�4Xg�zU�01�+��RP� l�����ʛ�
G ��*CRf�p�bdo{Er��S�fX5;��R��`�A�P� W�+�7$�
O�'\$�����"��tu"ux?!��5��xu����w��ttp�D7{��"��M��툵�{[K����1�I�ԮL�,Ǯc�3?~vH��Ei�q�ݿ�lLGj��^�J4u��"����M|��i�9���۳."]iB��m��3;�K��Uゴ
��!T
T�bY܆�?V^�>d�A���b�B)8-�7���"_4P�W�����)o���@d���3����1r��ӻO����¶����\�CY{`?4��`(���r��o����'\&�����"��~q%=_C0 _I������6d������y�{�:�Y��î����Tq��NS���Y��}Y������E3oi����ac�hB.�� �$��H������Opqx@�;��ad8W	��m�}핵�	�ܦ��p8
��P�� �c�p�b�E�E�i��M$�,���RW��1iW
���$W����-u8�>wB&�I�u��ȅ�3I	���6�ߏ�ƅ�G�Z�	hQU�,�E�!����R�!{�P�1��Ƀ, ���o��KW'9Ax^�3���jq�,����&��<nN��,H+Bt�H�ԯ\����S�DA�
z�#;6���d��z���ˊ�\)��\�v�%jw{)/�
��';��G��,I�@!t��2��4��}��+O�/���Q�H�!!����?�4 W�'g��$TNFi�_xR}1r��&�Em��=Z2�y�}��	���)�Qu�29B��\+ۻs��m�x��3�j�w� ��'eM8�سq��Dz�IG�$��.����)I����������@=��.������I����%��r�-��9�E'� ����;6���dC��A�m�x%Z<ҭ*��a�`����i��V�~y1�7���Lͤ�9C���*�H�N�չV���!=	T�by�0���9��P0F����E0QO�$��M�;�E��ݓ��,*���^�]��c�����5��FW&Cr�3MlΘ�4��L�Wp3(���S�)�A����;M���..�p_@�;��]���"���`��=p��a����Q�Ep�7v�lk�n�5� HG=�=�����==��M����3�#�n��pDN/�6�y}�����$�+?|���am�����]C����"��ۓ~�$\Q��@i�?.���'7ҽ�7�$P��U}<*������������M.�٫�H��Q���Ef�}��ҿ�������Կy�WET-p�̠��3�'��k��,	��$���`��;�6��ɸ�_��jA$��'��,j;�U���ga�_M�m ���&d�I�Y�͌�o ��v� ��$:}{`�xcOz
����ҽ��z�`JF�N�;<�h6�"�_wI��m��ŏ�M�M��Ep.]�L�6I[�mU��.Vn�]�2�I5!�a�騔�Sp�h-�L�ָ6�m�'�^�qw��(3��.x_������}��L/60%����%�z��afp\�d5,MwL���-z\��J��@1T4 ����y����Sp�N�7�X6�OG%#�'�,j�3�/�mr~����⋟&P ��FP
NI��)~Xi$���L�D��9�����$�m�8��q~ecggI�lO�;�R����r�LG�J����J}����'�E�q~��O�4,��r�r	��>Ԝ�|��C��V,��C���"���FR�����	��'%W{����Em�*37���E�}v�	gXQ����;f����P � #�t9,X�&�IENwA-�p�X<rL�,tf�8���B.�����	��Xm��*��ܝ�;�E�wr��w��GT=Pa
�ؽ�����0!D�7�'6�^^H>�` ^�<������[\5��~~��"�8�	��ZZ�zR����8�q\���;]n`[DM �"����\+��g��L|!b
4 rZ1��Y�2VC|��� !�p�d㧏?�M�
wk)/�
�!��i$�ٛ�k�.������ۯ&i�iM"ޑYw�����ـ��0B�`vA-c�l���L��H�@Ӱ�b��=cA.QP������cr#~Yz3���]H��֥���˞K������EZ�j�/�݇�p�de$W�f�	<��xh��at�~f��ٍ��0	ڦ��$�g<E��_�5I��D��w��`d_kE�� �qв噿�;ws�"��+o�}�I#���m�:B�2�\+�nN>�#{!34�D�'�S~�Ѿ��D�B6�>j<E�mr�)|��o`�x�����E�3>�Z���Sw.�������i xbM#��Yw���̼e�8� �DX �h�t�E�1u[�^J #ŗ�>��&>�:�>���#�ȣ�#�_]iDv�4��C��w\�U�KG'<N���4B=	�{[W�q��!�,�W�.l<�=tR1?�g�'�{��f��͑�"�$��@G�d��E0r��ӻOŀ�la�C�<n�.��Om=�Y��X,�]VL�\+��"]�� h�5�vt�99}�������b�!@�C����#K�NY���7�l]VNF6���駏 �3�4��Efݍ�+{�#KtRjYbdc�%2�����6��j�L��:���(�C<����~_�r����}���|$�J� @ά��eY=.�m���/��^�6�h��I5.���ůץ��67z��?��k�WF^����c��3�/
��,��ޜ��՗ų����Wpsh$m2a�i$�H=	A��di��������"|����֡3�
�4���U��_H�0N�����}��T��\2�eD��p�v�uO��W�{b�QP��!Ӧl��Yբl�Om��������:eB5��˩���C>����	�����Z���W�iF��1�E�(�p��H�R8��zZ��ߋ��p2Z�����������'|	�N���3��!�՘���|A��d߹q~�Ņ�3�]�B�+[�q!���:�`qDPRrT�U��K��	�BK�����y�x� �>|C5�G��;�%08.�$
`��A��]���,,��`j�@����h��ǠjD��$���>!�����Y�yKr�ie����9��sҾ�#T	�L����C�Y�t��
\PБ1{�u��"�.��:������}��"��y�y��I}s���E��{����V��ӆ�c$W�����P=T39�o����m�dL~@P`�t��}&�d
�{b@�ʛ��-���j�.�LS���LӜ�Њ9���;ӑF\�zR����P+TS�@�``i~¸�����|A�4ziEP�5X�2�t�`�l��T\�z�-zdo��n���].�; ��ߒ�CP6L,	�<
T��� � kF.���t:p���b�`Ѭ����T,�D�?4�Ф��R��!��!Y
��s!ā��})�S����(�J��������E�_����Z4m�l`$W��E�Z� 8M"j6 ^-��C���C% ��Bm�H�P^���#�8S
�2T���H��Zi$���+/�j#	KfC�G�ED̈́��B~I@n��������<�Y0�!DQ�p,�r��U������"�<g�ưK�#4/p h����_��/�Dm`:"�^8mbj�|�` *��#dC��$�*|-5��*�N�3j�vuS�5Q���A�f�Z�
W�QU�6�h���F������{W���vA`p�i�$@�f��E�:_[�;S�s!�I�B���Q�?�Fc�        [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://csnpssscw5cbs"
path="res://.godot/imported/icon.svg-5744b51718b6a64145ec5798797f7631.ctex"
metadata={
"vram_texture": false
}
                @tool

extends EditorPlugin

const main_panel = preload("res://addons/timer/timer.tscn")
const time_file_path = "res://addons/timer/time.txt"
const save_interval : int = 60 # Save interval in seconds

# Nodes
var main_panel_instance : Control
var progress_bar : ProgressBar
var main_button : Button

var time_file : FileAccess

var time : float = 0.0
var save_completed := true

#region Plugin Boilerplate

func _has_main_screen():
	return false


func _get_plugin_name():
	return "Timer Plugin"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Timer", "EditorIcons")

#endregion

func _ready():
	# Place timer in title bar
	var title_bar = EditorInterface.get_base_control().get_child(0).get_child(0)
	main_panel_instance = main_panel.instantiate()
	title_bar.add_child(main_panel_instance)
	title_bar.move_child(main_panel_instance, 1) # Reorder after the explorer menu (Scene Project, etc...)
	
	# Find essential nodes
	main_button = main_panel_instance # The button is the scene root node
	progress_bar = main_panel_instance.find_child("ProgressBar")
	
	# Create time file if needed on first run
	if !FileAccess.file_exists(time_file_path):
		_log("Creating time file")
		_save_time()
	
	# Load last time
	time_file = FileAccess.open(time_file_path, FileAccess.READ)
	if time_file.get_error() != 0:
		_log("Failed to read time from time file")
		time = 0.0
	else:
		time = float(time_file.get_as_text())
		time_file.close()
		_log("Loaded time from time file: " + _get_time_string(int(time)))


func _get_time_string(seconds: int):
	return (
		(str(seconds / 86400) + # Days
		":" if seconds / 86400 > 0 else "") + # Only if days > 0
		str(seconds / 3600 % 24).pad_zeros(2) + # Hours
		":" +
		str(seconds / 60 % 60).pad_zeros(2) + # Minutes
		":" +
		str(seconds % 60).pad_zeros(2) # Seconds
	)


func _save_time():
	time_file = FileAccess.open(time_file_path, FileAccess.WRITE)
	if time_file.get_error() != 0:
		_log("Failed to save time to time file")
	else:
		time_file.store_string(str(round(time)))
		time_file.close()


func _process(delta):
	var paused = main_button.button_pressed
	var last_second = int(time) # Save the second before delta time is added to run code only when the second changes
	time += delta * int(!paused) # Only add to time if not paused
	var current_second = int(time)
	
	# Save time after every save interval
	if last_second != current_second and current_second % save_interval == 0:
		_save_time()
	
	# Update timer text
	var time_string = "  " + ("PAUSED: " if paused else "Timer: ") + _get_time_string(current_second) + "  "
	main_button.text = time_string
	
	# Update tooltip (hover text) for main button
	var total_hours = round((current_second / 3600.0) * 10) / 10
	main_button.tooltip_text = str(total_hours) + " hours\nTimer Plugin by TheSpoingle"
	
	# Show progress for current day
	progress_bar.value = current_second % 86400 / 86400.0


# Logging is put into a function to append text before each log message
func _log(message: String):
	print("Timer Plugin: " + message)


func _exit_tree():
	_save_time()
	if main_panel_instance:
		main_panel_instance.queue_free()
       RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom    script 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size 	   _bundled           local://StyleBoxEmpty_oc57v �         local://StyleBoxFlat_u58mf          local://StyleBoxFlat_shpal =         local://StyleBoxEmpty_r6usd r         local://StyleBoxEmpty_auut4 �         local://PackedScene_v22je �         StyleBoxEmpty             StyleBoxFlat            �?  �?  �?��p>         StyleBoxFlat            �?        ��>         StyleBoxEmpty             StyleBoxEmpty             PackedScene          	         names "         MainButton    custom_minimum_size    anchor_top    anchor_bottom    offset_right    grow_vertical    size_flags_vertical    tooltip_text !   theme_override_colors/font_color )   theme_override_colors/font_pressed_color '   theme_override_colors/font_hover_color    theme_override_styles/normal    theme_override_styles/hover    theme_override_styles/pressed    theme_override_styles/disabled    theme_override_styles/focus    toggle_mode    Button    ProgressBar    self_modulate    layout_mode    anchors_preset    anchor_right    grow_horizontal    mouse_filter 
   max_value    step    value    show_percentage    	   variants       
         �A      ?     �B                  Timer Plugin by TheSpoingle      @?  @?  @?  �?   ��*?          �?     �?  �?  �?  �?                                                         �?  �?  �?�~�>                 �?                    node_count             nodes     H   ��������       ����                                                    	      
         	      
                                             ����                                                                                           conn_count              conns               node_paths              editable_instances              version             RSRC RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script -   res://scripts/ActiveSessionLengthSelector.gd ��������      local://PackedScene_7f1u8 $         PackedScene          	         names "   !      Control    layout_mode    anchors_preset    anchor_left    anchor_top    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    Manager    script    Node    nextButton    offset_left    offset_top    offset_right    offset_bottom $   theme_override_font_sizes/font_size    text    Button    fifteenMinutes    twentyFiveMinutes    fiftyMinutes 	   Question    horizontal_alignment    vertical_alignment    Label    error    _on_next_button_pressed    pressed    _on_fifteen_minutes_pressed     _on_twenty_five_minutes_pressed    _on_fifity_minutes_pressed    	   variants    !                     ?                            ��     	C     �B     WC            Next      b�     �A     ��     �B      15 Minutes       25 Minutes      �B     cC      50 Minutes     ���     ��     �C     ��   "      0   How long do you want your Active Sessions to be            �     pC     �A     �C      error       node_count             nodes     �   ��������        ����                                                                   	   ����   
                        ����                              	      
                           ����                                    
                           ����                                    
                           ����                                    
                           ����	                                                                           ����                                                              conn_count             conns                                                                                                           node_paths              editable_instances              version             RSRC       RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    default_base_scale    default_font    default_font_size    script 	   _bundled       Script %   res://scripts/BreakLengthSelector.gd ��������      local://Theme_51nct z         local://PackedScene_ycjde �         Theme             PackedScene          	         names "   "      Control    layout_mode    anchors_preset    anchor_left    anchor_top    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    Manager    script    Node    Label    offset_left    offset_top    offset_right    offset_bottom    size_flags_horizontal    size_flags_vertical    text    horizontal_alignment    vertical_alignment    fiveMinutes    theme    Button    tenMinutes    fifteenMinutes    startButton    error    _on_five_minutes_pressed    pressed    _on_ten_minutes_pressed    _on_fifteen_minutes_pressed    _on_start_button_pressed    	   variants    !                     ?                            �     x�     C     �   '   How long do you want your breaks to be            ��     ��     ��     �B             
   5 Minutes      ��     �B      10 Minutes      C     �C      15 Minutes
      �B     C     aC      Next      �C     D     7D     "D      error       node_count             nodes     �   ��������        ����                                                                   	   ����   
                        ����
                              	                    
                                 ����	                                                                             ����                                                                       ����                                                                       ����                                                                       ����
                                                                            conn_count             conns                                                                                       !                    node_paths              editable_instances              version             RSRC         RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://scripts/pomodoro.gd ��������      local://PackedScene_ssyvi          PackedScene          	         names "   "      Control    layout_mode    anchors_preset    anchor_left    anchor_top    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    Manager    script    Node    pomodoroActive    Timer    pomodoroBreak    Label    offset_left    offset_top    offset_right    offset_bottom    size_flags_horizontal    size_flags_vertical $   theme_override_font_sizes/font_size    text    horizontal_alignment    vertical_alignment    autowrap_mode    startButton    Button    _on_pomodoro_active_timeout    timeout    _on_pomodoro_break_timeout    _on_start_button_pressed    pressed    	   variants                         ?                     ��     ��     �B     ��                  lorem ipsum            T�     @B     XB     �B   *         Start       node_count             nodes     f   ��������        ����                                                                   	   ����   
                        ����                      ����                      ����                                    	      	      
                                             ����	                                    	      	                         conn_count             conns                                                            !                        node_paths              editable_instances              version             RSRC            extends Node

@onready var next_button = get_node("/root/Control/nextButton")
@onready var fifteen_minutes = get_node("/root/Control/fifteenMinutes")
@onready var twenty_five_minutes = get_node("/root/Control/twentyFiveMinutes")
@onready var fifity_minutes = get_node("/root/Control/fiftyMinutes")
@onready var error = get_node("/root/Control/error")

var startTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	error.text = ""
   
func _on_fifteen_minutes_pressed():
	startTime = 900
	print("Time set to " + str(startTime) + " secs")
	error.text = "Active Session length set to 15 Minutes"
 
func _on_twenty_five_minutes_pressed():
	startTime = 1500
	print("Time set to " + str(startTime) + " secs")
	error.text = "Active Session length set to 25 Minutes"
	
func _on_fifity_minutes_pressed():
	startTime = 3000
	print("Time set to " + str(startTime) + " secs")
	error.text = "Active Session length set to 50 Minutes"
	 
func _on_next_button_pressed():
	if startTime == 0:
		error.text = "Please select an Active Session length"
	else: 
		Globals.activeSessionLength = startTime
		get_tree().change_scene_to_file("res://scenes/BreakLengthSelector.tscn")
      extends Node

@onready var error = get_node("/root/Control/error")

var breakTime: int

# Called when the node enters the scene tree for the first time.
func _ready():
	error.text = ""

func _on_five_minutes_pressed():
	breakTime = 300
	print("Set break time to " + str(breakTime) + " seconds")
	error.text = "Set Break Length to " + str(breakTime / 60) + " minutes"

func _on_ten_minutes_pressed():
	breakTime = 600
	print("Set break time to " + str(breakTime) + " seconds")
	error.text = "Set Break Length to " + str(breakTime / 60) + " minutes"


func _on_fifteen_minutes_pressed():
	breakTime = 900
	print("Set break time to " + str(breakTime) + " seconds") 
	error.text = "Set Break Length to " + str(breakTime / 60) + " minutes"


func _on_start_button_pressed():
	if breakTime == 0:
		error.text = "Please select a Break Length"
	else:
		Globals.breakLength = breakTime
		get_tree().change_scene_to_file("res://scenes/pomodoro.tscn")
   extends Node

@onready var pomodoroActive = get_node("/root/Control/pomodoroActive")
@onready var pomodoroBreak = get_node("/root/Control/pomodoroBreak")
@onready var label = get_node("/root/Control/Label")
@onready var start_button = get_node("/root/Control/startButton")

var activeSessionTime = Globals.activeSessionLength
var breakTime = Globals.breakLength
var timeUp: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Active Session Length: " + str(activeSessionTime) + " secs")
	print("Break Length: " + str(breakTime) + " secs")

# Define the time left in minutes and seconds
	var minutes = 0
	var seconds = 0

# Define a variable that prints those variables in a minute:second format

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var minutes = int(activeSessionTime / 60)
	var seconds = activeSessionTime % 60
	var activeTime = "%02d:%02d" % [minutes, seconds]
	Globals.activeTime = activeTime

	label.text = str(activeTime)

	if activeSessionTime == 0:
		timeUp = true

	if timeUp == true:
		pomodoroActive.stop()
		print("Break Time")
		label.text = "It's time for your break!"
		await get_tree().create_timer(5).timeout
		label.text = str(breakTime)

func _on_pomodoro_active_timeout():
	activeSessionTime -= 1

func _on_start_button_pressed():
	pomodoroActive.start()
	timeUp = false
	var nodeToRemove = get_node("/root/Control/startButton")
	nodeToRemove.hide()

func _on_pomodoro_break_timeout():
	breakTime -= 1
         extends Node

var activeSessionLength = 0
var breakLength = 0
var activeTime: int
              GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,��5xi�d�M���)3��$�V������3���$G�$2#�Z��v{Z�lێ=W�~� �����d�vF���h���ڋ��F����1��ڶ�i�엵���bVff3/���Vff���Ҿ%���qd���m�J�}����t�"<�,���`B �m���]ILb�����Cp�F�D�=���c*��XA6���$
2#�E.@$���A.T�p )��#L��;Ev9	Б )��D)�f(qA�r�3A�,#ѐA6��npy:<ƨ�Ӱ����dK���|��m�v�N�>��n�e�(�	>����ٍ!x��y�:��9��4�C���#�Ka���9�i]9m��h�{Bb�k@�t��:s����¼@>&�r� ��w�GA����ը>�l�;��:�
�wT���]�i]zݥ~@o��>l�|�2�Ż}�:�S�;5�-�¸ߥW�vi�OA�x��Wwk�f��{�+�h�i�
4�˰^91��z�8�(��yޔ7֛�;0����^en2�2i�s�)3�E�f��Lt�YZ���f-�[u2}��^q����P��r��v��
�Dd��ݷ@��&���F2�%�XZ!�5�.s�:�!�Њ�Ǝ��(��e!m��E$IQ�=VX'�E1oܪì�v��47�Fы�K챂D�Z�#[1-�7�Js��!�W.3׹p���R�R�Ctb������y��lT ��Z�4�729f�Ј)w��T0Ĕ�ix�\�b�9�<%�#Ɩs�Z�O�mjX �qZ0W����E�Y�ڨD!�$G�v����BJ�f|pq8��5�g�o��9�l�?���Q˝+U�	>�7�K��z�t����n�H�+��FbQ9���3g-UCv���-�n�*���E��A�҂
�Dʶ� ��WA�d�j��+�5�Ȓ���"���n�U��^�����$G��WX+\^�"�h.���M�3�e.
����MX�K,�Jfѕ*N�^�o2��:ՙ�#o�e.
��p�"<W22ENd�4B�V4x0=حZ�y����\^�J��dg��_4�oW�d�ĭ:Q��7c�ڡ��
A>��E�q�e-��2�=Ϲkh���*���jh�?4�QK��y@'�����zu;<-��|�����Y٠m|�+ۡII+^���L5j+�QK]����I �y��[�����(}�*>+���$��A3�EPg�K{��_;�v�K@���U��� gO��g��F� ���gW� �#J$��U~��-��u���������N�@���2@1��Vs���Ŷ`����Dd$R�":$ x��@�t���+D�}� \F�|��h��>�B�����B#�*6��  ��:���< ���=�P!���G@0��a��N�D�'hX�׀ "5#�l"j߸��n������w@ K�@A3�c s`\���J2�@#�_ 8�����I1�&��EN � 3T�����MEp9N�@�B���?ϓb�C��� � ��+�����N-s�M�  ��k���yA 7 �%@��&��c��� �4�{� � �����"(�ԗ�� �t�!"��TJN�2�O~� fB�R3?�������`��@�f!zD��%|��Z��ʈX��Ǐ�^�b��#5� }ى`�u�S6�F�"'U�JB/!5�>ԫ�������/��;	��O�!z����@�/�'�F�D"#��h�a �׆\-������ Xf  @ �q�`��鎊��M��T�� ���0���}�x^�����.�s�l�>�.�O��J�d/F�ě|+^�3�BS����>2S����L�2ޣm�=�Έ���[��6>���TъÞ.<m�3^iжC���D5�抺�����wO"F�Qv�ږ�Po͕ʾ��"��B��כS�p�
��E1e�������*c�������v���%'ž��&=�Y�ް>1�/E������}�_��#��|������ФT7׉����u������>����0����緗?47�j�b^�7�ě�5�7�����|t�H�Ե�1#�~��>�̮�|/y�,ol�|o.��QJ rmϘO���:��n�ϯ�1�Z��ը�u9�A������Yg��a�\���x���l���(����L��a��q��%`�O6~1�9���d�O{�Vd��	��r\�՜Yd$�,�P'�~�|Z!�v{�N�`���T����3?DwD��X3l �����*����7l�h����	;�ߚ�;h���i�0�6	>��-�/�&}% %��8���=+��N�1�Ye��宠p�kb_����$P�i�5�]��:��Wb�����������ě|��[3l����`��# -���KQ�W�O��eǛ�"�7�Ƭ�љ�WZ�:|���є9�Y5�m7�����o������F^ߋ������������������Р��Ze�>�������������?H^����&=����~�?ڭ�>���Np�3��~���J�5jk�5!ˀ�"�aM��Z%�-,�QU⃳����m����:�#��������<�o�����ۇ���ˇ/�u�S9��������ٲG}��?~<�]��?>��u��9��_7=}�����~����jN���2�%>�K�C�T���"������Ģ~$�Cc�J�I�s�? wڻU���ə��KJ7����+U%��$x�6
�$0�T����E45������G���U7�3��Z��󴘶�L�������^	dW{q����d�lQ-��u.�:{�������Q��_'�X*�e�:�7��.1�#���(� �k����E�Q��=�	�:e[����u��	�*�PF%*"+B��QKc˪�:Y��ـĘ��ʴ�b�1�������\w����n���l镲��l��i#����!WĶ��L}rեm|�{�\�<mۇ�B�HQ���m�����x�a�j9.�cRD�@��fi9O�.e�@�+�4�<�������v4�[���#bD�j��W����֢4�[>.�c�1-�R�����N�v��[�O�>��v�e�66$����P
�HQ��9���r�	5FO� �<���1f����kH���e�;����ˆB�1C���j@��qdK|
����4ŧ�f�Q��+�     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://cgqwhw7a0djqp"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                [remap]

path="res://.godot/exported/133200997/export-f98e2c43719a3e9fac5e2b9801a9be33-timer.scn"
              [remap]

path="res://.godot/exported/133200997/export-f7b9d321128aa45d8e597ab45c825991-ActiveSessionLengthSelector.scn"
        [remap]

path="res://.godot/exported/133200997/export-42ac1302a55dcdd76f56209c51ab9e5a-BreakLengthSelector.scn"
[remap]

path="res://.godot/exported/133200997/export-21612f452b92f3f0782bfa67dc105248-pomodoro.scn"
           list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 814 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H446l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z" fill="#478cbf"/><path d="M483 600c0 34 58 34 58 0v-86c0-34-58-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
           
   L���F�'T   res://addons/godot-vim/icon.svg�� $�   res://addons/timer/timer.tscn0��Y`�Ce    res://assets/timerBackground.png?v��0    res://assets/timerForeground.png�Y��X-   res://scenes/ActiveSessionLengthSelector.tscn�bD�v�w%   res://scenes/BreakLengthSelector.tscn���7��Hr!   res://scenes/circleTimerTest.tscn�ә���b   res://scenes/pomodoro.tscn���^Sf�#!   res://Themes/catppuccinMocha.tres��88؎H   res://icon.svg            res://addons/godot-git-plugin/git_plugin.gdextension
           ECFG      application/config/name      	   pomofocus      application/run/main_scene8      -   res://scenes/ActiveSessionLengthSelector.tscn      application/config/features$   "         4.2    Forward Plus       application/config/icon         res://icon.svg     autoload/Globals         *res://Globals.gd      editor_plugins/enabledT   "      "   res://addons/godot-vim/plugin.cfg      res://addons/timer/plugin.cfg          