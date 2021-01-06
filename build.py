import os

functions_dir = "dzn_gear\\data\\functions"
target_file = "dzn_gear\\data\\functions.sqf"


def prepare_functions():
    if not os.path.isdir(functions_dir):
        print("Failed to find source dir!")
        return

    fncs = []
    header = "dzn_gear_fnc_{}"
    body = "{} = {{ \n{}\n}};\n\n\n"

    for f in os.listdir(functions_dir):
        fnc_head = header.format(strip_function_name(f))
        with open(os.path.join(functions_dir, f)) as txt_file:
            lines = txt_file.readlines()

        fnc_text = ""
        for l in lines:
            fnc_text = "{}    {}".format(fnc_text, l)

        fnc_body = body.format(fnc_head, fnc_text)
        fncs.append(fnc_body)

    return fncs


def strip_function_name(name):
    # Strips fnc_name.sqf to 'name'
    return (name[4:])[:-4]


def write_to_file(data):
    if not data:
        print("No data was generated!")
        return
    if not os.path.isfile(target_file):
        print("Failed to find target file!")
        return

    with open(target_file, "w") as f:
        for fnc in data:
            f.write(fnc)


if __name__ == "__main__":
    write_to_file(prepare_functions())
