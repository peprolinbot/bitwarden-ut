import datetime
import pyotp

def get_remaining_time(totp_code):
    totp = pyotp.TOTP(totp_code)
    remaining_time = totp.interval - datetime.datetime.now().timestamp() % totp.interval
    return int(remaining_time)

def get_otp(totp_code):
    totp = pyotp.TOTP(totp_code)
    return totp.now()
