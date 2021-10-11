# import sys
# sys.path.insert(0, "./pylibs/pexpect")
import pexpect
import re
import json
import os
import base64

VAULT_DIR=os.environ['HOME']+"/.local/share/bitwarden-ut.peprolinbot"

VAULT_FILE_NAME="vault.json"

VAULT_PATH=VAULT_DIR+"/"+VAULT_FILE_NAME

def get_items(session, folder_id=""):
    if folder_id == "":
        return get_vault(session)["items"]
    else:
        data = []
        for item in get_vault(session)["items"]:
            if item["folderId"] == folder_id:
                data.append(item)

        return data

def get_folders(session):
    return get_vault(session)["folders"]

    return data

def get_totp(session, id):
    child = pexpect.spawn("./bw get totp "+id, env={**os.environ, "BW_SESSION": session})
    return child.read().decode().split()[0]

def rename_object(session, type, id, new_name):
    json_data = json.dumps({"name": new_name})
    encoded_data = base64.b64encode(json_data.encode()).decode()
    pexpect.run("./bw edit "+type+" "+id+" "+encoded_data, env={**os.environ, "BW_SESSION": session})

def delete_object(session, type, id):
    pexpect.run("./bw delete "+type+" "+id, env={**os.environ, "BW_SESSION": session})

def login(server, email, password, tfaCode):
    pexpect.run("./bw logout")
    pexpect.run("./bw config server "+server)
    child = pexpect.spawn("./bw login")
    child.expect("Email address:")
    child.sendline(email)
    child.expect("Master password:")
    child.sendline(password)
    child.expect("Two-step login method:")
    child.sendline()
    child.expect("Two-step login code:")
    child.sendline(tfaCode)
    child.expect(pexpect.EOF)
    out = child.before.decode()
    session = re.search('BW_SESSION=".*=="', out).group()[12:-1]

    return session

def get_server():
    child = pexpect.spawn("./bw config server")
    return child.read().decode().split()[0]

def is_logged_in():
    child = pexpect.spawn("./bw status")
    str_data = child.read().decode()
    data = json.loads(str_data)
    if data["status"] == "unauthenticated":
        return False
    else:
        return True

def get_vault(session):
    with open(VAULT_PATH) as f:
        vault = json.load(f)

    return vault

def synchronize(session):
    pexpect.run("./bw sync", env={**os.environ, "BW_SESSION": session})

    try:
        child = pexpect.spawn("./bw list items", env={**os.environ, "BW_SESSION": session})
        items = json.loads('{"x": '+child.read().decode()+'}')["x"]

        child = pexpect.spawn("./bw list folders", env={**os.environ, "BW_SESSION": session})
        folders = json.loads('{"x": '+child.read().decode()+'}')["x"]

        data = {"items": items, "folders": folders}

        if not os.path.exists(VAULT_DIR):
            os.makedirs(VAULT_DIR)

        with open(VAULT_PATH, "w") as f:
            json.dump(data, f)

    except ValueError:
        raise Exception("Error decoding json. Bitwarden output: " + str_data)
