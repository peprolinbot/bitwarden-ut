# import sys
# sys.path.insert(0, "./pylibs/pexpect")
import pexpect
import re
import json
import os
import base64

def get_items(session, folder_id=""):
    if folder_id == "":
        child = pexpect.spawn("./bw list items --raw", env={**os.environ, "BW_SESSION": session})
    else:
        if folder_id == None:
            folder_id = "null" # This is to searc items which aren't in any folder
        child = pexpect.spawn("./bw list items --folderid "+folder_id+" --raw", env={**os.environ, "BW_SESSION": session})
    str_data = child.read().decode()
    try:
        data = json.loads('{"x": '+str_data+'}')["x"] # Turn it into a list of dicts
    except ValueError:
        raise Exception("Error decoding json. Bitwarden output: " + str_data)

    return data

def get_folders(session):
    child = pexpect.spawn("./bw list folders --raw", env={**os.environ, "BW_SESSION": session})
    str_data = child.read().decode()
    try:
        data = json.loads('{"x": '+str_data+'}')["x"] # Turn it into a list of dicts
    except ValueError:
        raise Exception("Error decoding json. Bitwarden output: " + str_data)

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

def synchronize(session):
    pexpect.run("./bw sync", env={**os.environ, "BW_SESSION": session})
